import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

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
          _buildNavItem(context,icon: FontAwesomeIcons.house, index: 0, label: 'Home'),
          _buildNavItem(context,
              icon: FontAwesomeIcons.bowlRice, index: 1, label: 'Meal'),
          _buildNavItem(context,
              icon: FontAwesomeIcons.calendarCheck, index: 2, label: 'Personal'),
          _buildNavItem(context,
              icon: FontAwesomeIcons.dumbbell, index: 3, label: 'Exercise'),
          _buildNavItem(context,
              icon: FontAwesomeIcons.userShield, index: 4, label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon, required int index, required String label}) {
    var media = MediaQuery.of(context).size;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: SizedBox(
          // height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon,
                  size: AppFontSize.tabIcon(context),
                  color: currentIndex == index
                      ? AppColors.primaryColor1
                      : const Color(0xFF4C585B)),
              SizedBox(height: media.height * 0.004,),
              Text(label,
                  style: TextStyle(
                      color: currentIndex == index
                          ? AppColors.primaryColor1
                          : const Color(0xFF4C585B),
                      fontSize: AppFontSize.content(context))),
            ],
          ),
        ),
      ),
    );
  }
}
