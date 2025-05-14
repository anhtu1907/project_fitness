import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/presentation/meal/pages/meal_search_list.dart';

class MealSearchField extends StatelessWidget {
  const MealSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController mealNameCon = TextEditingController();
    return TextFormField(
      controller: mealNameCon,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search by meal...'),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) {
        value = mealNameCon.text;
        mealNameCon.clear();
        AppNavigator.push(
            context,
            MealSearchList(
              mealName: value,
            ));
      },
    );
  }
}
