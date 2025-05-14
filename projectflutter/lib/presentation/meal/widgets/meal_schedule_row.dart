import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/meal/entity/user_meals.dart';
import 'package:projectflutter/domain/meal/usecase/delete_record_meal.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_cubit.dart';
import 'package:projectflutter/presentation/meal/pages/meal_info_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealScheduleRow extends StatelessWidget {
  final UserMealsEntity entity;

  const MealScheduleRow({super.key, required this.entity});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          ClipRRect(
            // borderRadius: BorderRadius.circular(30),
            child: Image.network(
              entity.meal.mealImage == ''
                  ? AppImages.meat
                  : entity.meal.mealImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.meal.mealName,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '${entity.meal.weight.toStringAsFixed(0)} gram | ${entity.meal.kcal.toStringAsFixed(0)} kcal',
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          )),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'details') {
                final result = await AppNavigator.pushFuture(
                    context, MealInfoDetails(mealId: entity.meal.id));
                if (result == true) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      context.read<UserMealCubit>().displayRecord();
                    }
                  });
                }
              } else if (value == 'delete') {
                final deleteUseCase = DeleteRecordMealUseCase();
                await deleteUseCase.call(params: entity.id);

                if (context.mounted) {
                  context.read<UserMealCubit>().displayRecord();
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'details',
                child: Text('View Details'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            icon: Image.asset(
              AppImages.moreV,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}
