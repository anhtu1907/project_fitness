import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/common/helper/dialog/show_dialog.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:extended_image/extended_image.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_batch_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_request.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/start_exercise_multiple.dart';
import 'package:projectflutter/domain/exercise/usecase/get_session_reset_batch.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_result.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_rest.dart';
import 'package:projectflutter/presentation/exercise/widgets/show/show_overlay.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseStart extends StatefulWidget {
  final List<ExercisesEntity> exercises;
  final double kcal;
  final int subCategoryId;
  final bool markAsDayCompleted;
  final int? day;
  const ExerciseStart({
    super.key,
    required this.exercises,
    required this.kcal,
    this.day,
    this.markAsDayCompleted = false,
    required this.subCategoryId,
  });

  @override
  State<ExerciseStart> createState() => _ExerciseStartState();
}

class _ExerciseStartState extends State<ExerciseStart> {
  int _currentIndex = 0;
  late ExercisesEntity _currentExercise;
  int _counter = 10;
  // late int _counter;
  Timer? _timer;
  Timer? _totalDurationTimer;
  int _totalDuration = 0;
  bool _showOverlay = true;
  bool _isResting = false;
  int _countdown = 3;
  int? _resetBatch;
  int _exerciseDuration = 0;
  bool _isPaused = false;
  final List<ExerciseSessionRequest> _sessionRequests = [];

  @override
  void initState() {
    super.initState();
    _currentExercise = widget.exercises[_currentIndex];
    // _counter = widget.exercises[_currentIndex].duration;
    _initResetBatchAndStart();
  }

  Future<void> _initResetBatchAndStart() async {
    _resetBatch = await sl<GetSessionResetBatchUseCase>()
        .call(params: widget.subCategoryId);
    final overlayPref =
        (await SharedPreferences.getInstance()).getBool('overlay') ?? true;
    setState(() {
      _showOverlay = _currentIndex == 0 || overlayPref;
    });
    _showOverlay ? _startCountdown() : _startExercise();
  }

  void _startTotalDurationTimer() {
    _exerciseDuration = 0;
    _totalDurationTimer?.cancel();
    _totalDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _exerciseDuration++;
        });
      }
    });
  }

  void _stopTotalDurationTimer() {
    _totalDurationTimer?.cancel();
  }

  void _startGenericTimer({
    required int initialValue,
    required void Function() onFinish,
    required void Function(int) onTick,
  }) {
    int value = initialValue;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isPaused) return;
      setState(() {
        if (value > 0) {
          value--;
          onTick(value);
        } else {
          timer.cancel();
          onFinish();
        }
      });
    });
  }

  void _startCountdown() {
    _startGenericTimer(
      initialValue: _countdown,
      onTick: (val) => _countdown = val,
      onFinish: () async {
        setState(() {
          _showOverlay = false;
          _counter = 10;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) _startExercise();
      },
    );
  }

  void _startExercise({bool skipDurationTimer = false}) {
    _stopTotalDurationTimer();
    if (!skipDurationTimer) {
      _startTotalDurationTimer();
    }

    _startGenericTimer(
      initialValue: _counter,
      onTick: (val) => _counter = val,
      onFinish: _prepareExerciseSession,
    );
  }

  void _prepareExerciseSession() {
    _stopTotalDurationTimer();
    _totalDuration += _exerciseDuration;

    _sessionRequests.add(ExerciseSessionRequest(
      exerciseId: _currentExercise.id,
      duration: _exerciseDuration,
      subCategoryId: widget.subCategoryId,
      resetBatch: _resetBatch!,
    ));

    if (_currentIndex < widget.exercises.length - 1) {
      setState(() => _isResting = true);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _finishAllExercises();
      });
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _nextExercise() {
    setState(() {
      _currentIndex++;
      _currentExercise = widget.exercises[_currentIndex];
      _isResting = false;
      _counter = 10;
    });
    _startTotalDurationTimer();
    _startExercise();
  }

  void _finishAllExercises() async {
    _stopTotalDurationTimer();
    final userId = SharedPreferenceService.userId!;
    final batchRequest = ExerciseSessionBatchRequest(
      userId: userId,
      subCategoryId: widget.subCategoryId,
      resetBatch: _resetBatch!,
      sessions: _sessionRequests,
    );
    if (widget.markAsDayCompleted && widget.day != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('day_${widget.day}_completed', true);
    }
    await StartExerciseUseCase().call(params: batchRequest);
    if (mounted) {
      AppNavigator.pushReplacement(
        context,
        ExerciseResultPage(
          resetBatch: _resetBatch!,
          totalExercise: widget.exercises.length,
          kcal: widget.kcal,
          markAsDayCompleted: widget.markAsDayCompleted,
          day: widget.day,
          duration: _totalDuration,
        ),
      );
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _totalDurationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(),
              Expanded(child: _buildExerciseView()),
            ],
          ),
          if (_isResting) _buildRestOverlay(),
          if (_showOverlay) _buildStartOverlay(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await ShowDialog.shouldPop(
                      context,
                      'Confirm',
                      'Are you sure you want to quit?',
                    );
                    if (result == true && mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 8,
                children: List.generate(widget.exercises.length, (index) {
                  bool isActive = index <= _currentIndex;
                  return Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryColor1
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseView() {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: ExtendedImage.network(
            'https://i.pinimg.com/originals/b7/6c/d5/b76cd5cff2452b9b3d839d2018863fbb.gif',
            fit: BoxFit.cover,
            enableLoadState: false,
            width: double.infinity,
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_currentExercise.exerciseName,
                  style:
                      TextStyle(fontSize: 24, color: AppColors.primaryColor1)),
              const SizedBox(height: 8),
              Text(_formatDuration(_counter),
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _togglePause,
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(_isPaused ? 'Resume' : 'Pause'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor1,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestOverlay() {
    return Positioned.fill(
      child: ExerciseRest(
        currentExercise: _currentIndex + 1,
        exerciseName: widget.exercises[_currentIndex + 1].exerciseName,
        totalExercise: widget.exercises.length,
        onRestFinished: _nextExercise,
      ),
    );
  }

  Widget _buildStartOverlay() {
    return ShowOverlay(
      exercises: widget.exercises,
      currentStep: _currentIndex,
      totalSteps: widget.exercises.length,
      showOverlay: _showOverlay,
      countDown: _countdown,
    );
  }
}
