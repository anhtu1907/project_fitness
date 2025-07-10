import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/auth/bloc/gender_selection_cubit.dart';

class GenderItem extends StatelessWidget {
  final int genderIndex;
  final String label;
  final int selectedIndex;

  const GenderItem({
    super.key,
    required this.genderIndex,
    required this.label,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == genderIndex;

    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          context.read<GenderSelectionCubit>().selectGender(genderIndex);
        },
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor3
                : AppColors.secondDarkBackground,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
