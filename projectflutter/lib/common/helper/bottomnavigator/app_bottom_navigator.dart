import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class AppBottomNavigator extends StatelessWidget {
  const AppBottomNavigator({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final Function(int) onTap;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 2.0,
      color: AppColors.secondLightBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.home_filled, index: 0, label: 'Home'),
          _buildNavItem(icon: Icons.fastfood, index: 1, label: 'Meal'),
          _buildNavItem(icon: Icons.bar_chart, index: 2, label: 'Personal'),
          _buildNavItem(
              icon: Icons.fitness_center, index: 3, label: 'Exercise'),
          _buildNavItem(icon: Icons.person, index: 4, label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon, required int index, required String label}) {
    return Flexible(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: SizedBox(
          // height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 24,
                  color: currentIndex == index
                      ? AppColors.underweight
                      : Colors.black),
              Text(label,
                  style: TextStyle(
                      color: currentIndex == index
                          ? AppColors.underweight
                          : Colors.black,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
