import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';

class ShowOverlay extends StatefulWidget {
  ShowOverlay(
      {super.key,
      required this.exercises,
      required this.currentStep,
      required this.totalSteps,
      required this.startExercise,
      required this.showOverlay,
      required this.countDown});
  final List<ExercisesEntity> exercises;
  final int currentStep;
  final int totalSteps;
  final VoidCallback startExercise;
  bool showOverlay;
  final int countDown;
  @override
  State<ShowOverlay> createState() => _ShowOverlayState();
}

class _ShowOverlayState extends State<ShowOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'Exercise : ${widget.currentStep + 1}/${widget.totalSteps}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.countDown.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.exercises[widget.currentStep].exerciseName,
                  style:
                      TextStyle(color: AppColors.primaryColor1, fontSize: 20),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                ),
                onPressed: () {
                  setState(() {
                    widget.showOverlay = false;
                  });
                  widget.startExercise();
                },
                child: const Text('Start'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
