import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/dialog/show_dialog.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:extended_image/extended_image.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_result.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_rest.dart';

class ExerciseStart extends StatefulWidget {
  final List<ExercisesEntity> exercises;
  final int currentIndex;
  const ExerciseStart(
      {super.key, required this.exercises, required this.currentIndex});

  @override
  State<ExerciseStart> createState() => _ExerciseStartsState();
}

class _ExerciseStartsState extends State<ExerciseStart> {
  late int _counter;
  late ExercisesEntity currentExercise;
  late Timer _timer;
  bool _showOverlay = true;
  bool _buttonState = false;
  int _countdown = 5;
  Timer? _countdownTimer;
  bool _isResting = false;

  @override
  void initState() {
    super.initState();
    currentExercise = widget.exercises[widget.currentIndex];
    // _counter = currentExercise.duration;
    _counter = 1;

    if (_showOverlay) {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _countdownTimer?.cancel();
          _showOverlay = false;
          _startTimer();
        }
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
          if (widget.currentIndex < widget.exercises.length - 1) {
            _isResting = true;
            _showOverlay = false;
          } else {
            _onExerciseFinished();
          }
        }
      });
    });
  }

  void _onExerciseFinished() {
    if (widget.currentIndex < widget.exercises.length - 1) {
      AppNavigator.pushReplacement(
          context,
          ExerciseStart(
              exercises: widget.exercises,
              currentIndex: widget.currentIndex + 1));
    } else {
      AppNavigator.pushReplacement(context, const ExerciseResultPage());
    }

    setState(() {
      _showOverlay = false;
      _isResting = false;
    });
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalSteps = widget.exercises.length;
    int currentStep = widget.currentIndex;

    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(color: AppColors.white),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    expandedHeight: 130,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(totalSteps, (index) {
                                bool isActive = index <= currentStep;

                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
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
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: InkWell(
                              onTap: () async {
                                final result = await ShowDialog.shouldPop(
                                    context,
                                    'Confirm',
                                    'Are you sure want to quit');
                                if (result == true && context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Column(
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
                    flex: 2.5.toInt(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentExercise.exerciseName,
                          style: TextStyle(
                              fontSize: 24, color: AppColors.primaryColor1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDuration(_counter),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2.5.toInt(),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.black,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _buttonState = !_buttonState;
                              if (_buttonState) {
                                _timer.cancel();
                              } else {
                                _startTimer();
                              }
                            });
                          },
                          color: Colors.white,
                          icon: Icon(
                              !_buttonState ? Icons.pause : Icons.play_arrow),
                          iconSize: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        if (_isResting)
          Positioned.fill(
            child: ExerciseRest(
              currentExercise: currentStep + 1,
              exerciseName: widget
                  .exercises[currentStep + 1 < widget.exercises.length
                      ? currentStep + 1
                      : currentStep]
                  .exerciseName,
              totalExercise: totalSteps,
              onRestFinished: () {
                setState(() {
                  _onExerciseFinished();
                });
                _startTimer();
              },
            ),
          ),
        if (_showOverlay)
          Container(
            color: Colors.black.withOpacity(0.7),
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'READY TO GO?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Exercise : ${currentStep + 1}/$totalSteps',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _countdown.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.exercises[currentStep].exerciseName,
                        style: TextStyle(
                            color: AppColors.primaryColor1, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 20),
                      ),
                      onPressed: () {
                        setState(() {
                          _showOverlay = false;
                        });
                        _startTimer();
                      },
                      child: const Text('Start'),
                    ),
                  ),
                ),
              ],
            ),
          )
      ]),
    );
  }
}
