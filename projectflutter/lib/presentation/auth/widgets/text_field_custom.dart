import 'package:flutter/material.dart';
import 'package:projectflutter/common/components/fields/my_text_field.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final TextInputType inputType;
  const TextFieldCustom(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.icon,
      required this.validator,
      this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return MyTextField(
        controller: controller,
        hintText: hintText,
        obSecureText: false,
        prefixIcon: IconCustom(icon: icon),
        validator: validator,
        keyboardType: inputType);
  }
}
