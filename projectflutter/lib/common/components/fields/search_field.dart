import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;
  const SearchField(
      {super.key, required this.hintText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    TextEditingController mealNameCon = TextEditingController();
    return TextFormField(
      controller: mealNameCon,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: BorderSide(color: AppColors.primaryColor1)),
          prefixIcon: const Icon(Icons.search),
          hintText: hintText),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) {
        value = mealNameCon.text;
        mealNameCon.clear();
        onPressed();
      },
    );
  }
}
