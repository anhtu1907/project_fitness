import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_state.dart';

class DataProgressCaloriesAbsorption extends StatefulWidget {
  const DataProgressCaloriesAbsorption({super.key});

  @override
  State<DataProgressCaloriesAbsorption> createState() =>
      _DataProgressCaloriesAbsorptionState();
}

class _DataProgressCaloriesAbsorptionState
    extends State<DataProgressCaloriesAbsorption> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
          ),
          BlocProvider(
            create: (context) => UserMealCubit()..displayRecord(),
          ),
          BlocProvider(
            create: (context) => HealthCubit()..getDataHealth(),
          )
        ],
        child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
          builder: (context, state) {
            if (state is UserInfoLoaded) {
              final user = state.user;
              return BlocBuilder<UserMealCubit, UserMealState>(
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
                    final userMeal = state.entity;
                    return BlocBuilder<HealthCubit, HealthState>(
                      builder: (context, state) {
                        if (state is HealthLoaded) {
                          final health = state.bmi;
                          final now = DateTime.now();
                          var totalKcal;
                          if (health.last.bmi < 18.5) {
                            totalKcal = 2800;
                          }
                          if (health.last.bmi >= 18.5 &&
                              health.last.bmi < 24.9) {
                            totalKcal = 2400;
                          }
                          if (health.last.bmi >= 25 && health.last.bmi < 29.9) {
                            totalKcal = 1800;
                          }
                          if (health.last.bmi >= 30 && health.last.bmi < 34.9) {
                            totalKcal = 1500;
                          }
                          if (health.last.bmi >= 35) {
                            totalKcal = 1300;
                          }
                          final todayCalories = userMeal.where((calo) {
                            return now.year == calo.createdAt!.year &&
                                now.month == calo.createdAt!.month &&
                                now.day == calo.createdAt!.day;
                          }).toList();
                          final caloOfDay = todayCalories.fold<double>(
                              0, (sum, item) => sum += item.meal.kcal);
                          var percent = caloOfDay / totalKcal;
                          List<Color> progressColor = const [
                            Color(0xFF90C67C),
                            Color(0xff92A3FD),
                            Color(0xffF5C45E),
                            Color(0xffF93827)
                          ];
                          var colorIndex;
                          if (percent <= 0.25) {
                            colorIndex = 0;
                          } else if (percent > 0.25 && percent <= 0.5) {
                            colorIndex = 1;
                          } else if (percent > 0.5 && percent <= 0.75) {
                            colorIndex = 2;
                          } else if (percent > 0.75) {
                            colorIndex = 3;
                          }


                          return SingleChildScrollView(
                              child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.gray.withOpacity(0.15),
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Intake',
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: AppFontSize.value20Text(context),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: media.height * 0.01,
                                ),
                                SizedBox(
                                  height: media.height * 0.18,
                                  width: media.width,
                                  child: Center(
                                    child: CircularPercentIndicator(
                                      radius: 65,
                                      lineWidth: 10,
                                      percent: percent,
                                      center: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppImages.fat,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${caloOfDay.toStringAsFixed(0)} / $totalKcal',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'kcal',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      progressColor: progressColor[colorIndex],
                                      backgroundColor: Colors.grey[200]!,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                        }
                        return Container();
                      },
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ));
  }
}
