import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/presentation/meal/pages/meal_info_details.dart';
import 'package:projectflutter/presentation/meal/pages/meal_search_list.dart';

class MealSearchField extends StatefulWidget {
  const MealSearchField({super.key});

  @override
  State<MealSearchField> createState() => _MealSearchFieldState();
}

class _MealSearchFieldState extends State<MealSearchField> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => MealsCubit()..listMeal(),
    child: BlocBuilder<MealsCubit,MealsState>(builder: (context, state) {
      if(state is MealsLoaing){
        return const Center(child: CircularProgressIndicator(),);
      }
      if(state is LoadMealsFailure){
        return Center(child: Text(state.errorMessage),);
      }
      if(state is MealsLoaded){
        final meals = state.entity;
        return LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<MealsEntity>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<MealsEntity>.empty();
                }
                return meals.where((MealsEntity meal) {
                  return meal.mealName.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (MealsEntity option) => option.mealName,
              onSelected: (MealsEntity selection) {
                AppNavigator.push(
                  context,
                  MealInfoDetails(mealId: selection.id),
                );
              },
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return StatefulBuilder(builder: (context, setState) {
                  textEditingController.addListener((){
                    setState((){});
                  });
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor1),
                      ),
                      enabledBorder: InputBorder.none,
                      suffixIcon: textEditingController.text.isEmpty
                          ? Icon(Icons.search, color: AppColors.gray.withOpacity(0.6), size: 20)
                          : IconButton(
                        onPressed: () {
                          textEditingController.clear();
                        },
                        icon: Icon(Icons.close, color: AppColors.gray.withOpacity(0.6), size: 20),
                      ),
                      hintText: 'Search by meal...',
                    ),
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      AppNavigator.push(
                        context,
                        MealSearchList(mealName: value),
                      );
                    },
                  );
                },);

              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: constraints.maxWidth, // 🌟 Đây là width của TextFormField
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(option.mealImage, width: 40, height: 40,
                                    fit: BoxFit.cover,),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(
                                    option.mealName,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }
      return Container();
    },),);
  }
}
