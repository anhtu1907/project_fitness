import 'package:flutter/material.dart';
import 'package:projectflutter/common/components/fields/my_text_field.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  const EmailField({
    super.key,
    required this.controller,
    this.hintText = "Email",
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: controller,
      hintText: hintText,
      obSecureText: false,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const IconCustom(icon: Icons.email),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
          return 'Invalid email format';
        }
        return null;
      },
    );
  }
}
