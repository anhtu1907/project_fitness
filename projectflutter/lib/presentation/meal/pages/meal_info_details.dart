import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_id_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_id_state.dart';
import 'package:readmore/readmore.dart';

class MealInfoDetails extends StatelessWidget {
  final int mealId;

  const MealInfoDetails({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return BlocProvider(
        create: (context) => MealByIdCubit()..mealById(mealId),
        child: BlocBuilder<MealByIdCubit, MealByIdState>(
            builder: (context, state) {
          if (state is MealByIdLoaing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoadMealFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          if (state is MealByIdLoaded) {
            List<NutritionData> nutritionArr = [
              NutritionData(
                  image: AppImages.weight,
                  value: state.entity.weight,
                  unit: 'g'),
              NutritionData(
                  image: AppImages.fire,
                  value: state.entity.kcal,
                  unit: 'kcal'),
              NutritionData(
                  image: AppImages.fat, value: state.entity.fat, unit: 'g'),
              NutritionData(
                  image: AppImages.sugar, value: state.entity.sugar, unit: 'g'),
              NutritionData(
                  image: AppImages.grass, value: state.entity.fiber, unit: 'g'),
              NutritionData(
                  image: AppImages.carbo,
                  value: state.entity.carbonhydrate,
                  unit: 'g'),
            ];
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: false,
                      expandedHeight: media.width * 0.5,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            state.entity.mealImage,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 8,
                            left: 16,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                  ),
                  child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: AppColors.gray.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(3)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    state.entity.mealName,
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Nutrition",
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: nutritionArr.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 4),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColors.primaryColor2
                                                      .withOpacity(0.4),
                                                  AppColors.primaryColor1
                                                      .withOpacity(0.4)
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                nutritionArr[index %
                                                        nutritionArr.length]
                                                    .image,
                                                width: 25,
                                                height: 25,
                                                fit: BoxFit.cover,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${nutritionArr[index % nutritionArr.length].value.toStringAsFixed(0)} ${nutritionArr[index % nutritionArr.length].unit}',
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ));
                                    }),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Descriptions",
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ReadMoreText(
                                  'Pancakes are some people\'s favorite breakfast, who doesn\'t like pancakes? Especially with the real honey splash on top of the pancakes, of course everyone loves that! besides being Pancakes are some people\'s favorite breakfast, who doesn\'t like pancakes? Especially with the real honey splash on top of the pancakes, of course everyone loves that! besides being',
                                  trimLines: 4,
                                  colorClickableText: AppColors.black,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' Read More ...',
                                  trimExpandedText: ' Read Less',
                                  style: TextStyle(
                                    color: AppColors.gray,
                                    fontSize: 16,
                                  ),
                                  moreStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: RoundButton(
                                    title: "Add to calculate",
                                    onPressed: () {
                                      if (context.mounted) {
                                        context
                                            .read<MealByIdCubit>()
                                            .saveRecordMeal(state.entity.id);
                                        Navigator.pop(context, true);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  '1 item has been added to the meal schedule ')),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )
                      ])),
                ));
          }
          return Container();
        }));
  }
}

class NutritionData {
  final String image;
  final double value;
  final String unit;
  NutritionData({required this.image, required this.value, required this.unit});
}
