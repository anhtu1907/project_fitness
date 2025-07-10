import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/dialog/show_dialog.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/user_meals.dart';
import 'package:projectflutter/domain/meal/usecase/delete_all_record_meal.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_state.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_nutritions_row.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_schedule_row.dart';
import 'package:projectflutter/presentation/profile/widgets/calendar_custom.dart';

class MealSchedule extends StatefulWidget {
  const MealSchedule({super.key});

  @override
  State<MealSchedule> createState() => _MealScheduleState();
}

class _MealScheduleState extends State<MealSchedule> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: BasicAppBar(
          title: Text(
            'Meal Schedule',
            style: TextStyle(fontSize: AppFontSize.titleAppBar(context)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UserMealCubit()..displayRecord(),
              ),
              BlocProvider(
                create: (context) => HealthCubit()..getDataHealth(),
              )
            ],
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                    height: media.height * 0.2,
                    child: Builder(builder: (context) {
                      return CalendarCustom(onDateSelected: (selectedDate) {
                        setState(() {
                          date = selectedDate;
                        });
                        context
                            .read<UserMealCubit>()
                            .filterMealsByDate(selectedDate);
                      });
                    })),
                BlocBuilder<UserMealCubit, UserMealState>(
                    builder: (context, state) {
                  if (state is UserMealLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is LoadUserMealFailure) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  }

                  if (state is UserMealLoaded) {
                    final listUserMeal = state.entity;
                    return BlocBuilder<HealthCubit, HealthState>(
                        builder: (context, state) {
                      if (state is LoadedHealthFailure) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      }
                      if (state is HealthLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is HealthLoaded) {
                        final health = state.bmi;

                        final kcal = listUserMeal.fold<double>(
                            0, (sum, item) => sum += item.meal.kcal);
                        final protein = listUserMeal.fold<double>(
                            0, (sum, item) => sum += item.meal.protein);
                        final fat = listUserMeal.fold<double>(
                            0, (sum, item) => sum += item.meal.fat);
                        final carbo = listUserMeal.fold<double>(
                            0, (sum, item) => sum += item.meal.carbonhydrate);
                        final fiber = listUserMeal.fold<double>(
                            0, (sum, item) => sum += item.meal.fiber);
                        final sugar = listUserMeal.fold<double>(
                            0, (sum, item) => sum += item.meal.sugar);

                        var totalKcal;
                        var totalProtein;
                        var totalFat;
                        var totalCarbo;
                        var totalFiber;
                        var totalSugar;
                        if (health.last.bmi < 18.5) {
                          totalKcal = 2800.0;
                          totalProtein = 80.0;
                          totalFat = 90.0;
                          totalCarbo = 380.0;
                          totalFiber = 28.0;
                          totalSugar = 70.0;
                        }
                        if (health.last.bmi >= 18.5 && health.last.bmi < 24.9) {
                          totalKcal = 2400.0;
                          totalProtein = 70.0;
                          totalFat = 80.0;
                          totalCarbo = 330.0;
                          totalFiber = 32.0;
                          totalSugar = 50.0;
                        }
                        if (health.last.bmi >= 25 && health.last.bmi < 29.9) {
                          totalKcal = 1800.0;
                          totalProtein = 90.0;
                          totalFat = 80.0;
                          totalCarbo = 240.0;
                          totalFiber = 35.0;
                          totalSugar = 25.0;
                        }
                        if (health.last.bmi >= 30 && health.last.bmi < 34.9) {
                          totalKcal = 1500.0;
                          totalProtein = 100.0;
                          totalFat = 55.0;
                          totalCarbo = 180.0;
                          totalFiber = 40.0;
                          totalSugar = 20.0;
                        }
                        if (health.last.bmi >= 35) {
                          totalKcal = 1300.0;
                          totalProtein = 120.0;
                          totalFat = 40.0;
                          totalCarbo = 120.0;
                          totalFiber = 45.0;
                          totalSugar = 16.0;
                        }

                        Map<String, List<UserMealsEntity>> groupedByTime = {};
                        for (var meal in listUserMeal) {
                          for (var time in meal.meal.timeOfDay) {
                            groupedByTime
                                .putIfAbsent(time.timeName, () => [])
                                .add(meal);
                          }
                        }

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Meal Plan',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: AppFontSize.body(context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          var shouldConfirm =
                                              await ShowDialog.shouldContinue(
                                                  context,
                                                  'Confirm?',
                                                  'Are you sure want to clear?');
                                          if (shouldConfirm == true) {
                                            await DeleteAllRecordMealUseCase()
                                                .call(params: date);
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 300),
                                                () async {
                                              if (context.mounted) {
                                                context
                                                    .read<UserMealCubit>()
                                                    .displayRecord();
                                              }
                                            });
                                          }
                                        },
                                        child: Text(
                                          'CLEAR ALL',
                                          style: TextStyle(
                                              color: AppColors.primaryColor1,
                                              fontSize: AppFontSize.caption(context),
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ),
                              listUserMeal.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: groupedByTime.entries
                                              .map((entry) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(entry.key,
                                                    style:  TextStyle(
                                                        fontSize: AppFontSize.mealItemSchedule(context),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: entry.value.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return MealScheduleRow(
                                                        entity:
                                                            entry.value[index]);
                                                  },
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child:
                                            Text('No meals for selected date'),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today Meal Nutritions',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: AppFontSize.titleScheduleMeal(context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: media.height * 0.01,
                                    ),
                                    // Calories
                                    MealNutritionsRow(
                                        title: "Calories",
                                        value: kcal,
                                        totalValue: totalKcal,
                                        image: AppImages.burn,
                                        unit: "kcal"),
                                    // Protein
                                    MealNutritionsRow(
                                        title: "Protein",
                                        value: protein,
                                        totalValue: totalProtein,
                                        image: AppImages.proteins,
                                        unit: "g"),
                                    // Fats
                                    MealNutritionsRow(
                                        title: "Fats",
                                        value: fat,
                                        totalValue: totalFat,
                                        image: AppImages.fat,
                                        unit: "g"),
                                    // Carbo
                                    MealNutritionsRow(
                                        title: "Carbo",
                                        value: carbo,
                                        totalValue: totalCarbo,
                                        image: AppImages.carbo,
                                        unit: "g"),
                                    // Fiber
                                    MealNutritionsRow(
                                        title: "Fiber",
                                        value: fiber,
                                        totalValue: totalFiber,
                                        image: AppImages.grass,
                                        unit: "g"),
                                    // Sugar
                                    MealNutritionsRow(
                                        title: "Sugar",
                                        value: sugar,
                                        totalValue: totalSugar,
                                        image: AppImages.sugar,
                                        unit: "g"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      return Container();
                    });
                  }
                  return Container();
                })
              ],
            ))));
  }
}
