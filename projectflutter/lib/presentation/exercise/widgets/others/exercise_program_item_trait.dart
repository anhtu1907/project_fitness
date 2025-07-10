import 'package:flutter/material.dart';

class ExerciseProgramItemTrait extends StatelessWidget {
  const ExerciseProgramItemTrait(
      {super.key, required this.totalWorkouts, required this.categoryName});

  final int totalWorkouts;
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            categoryName,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalWorkouts workouts',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
