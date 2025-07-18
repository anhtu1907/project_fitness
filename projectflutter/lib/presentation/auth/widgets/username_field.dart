import 'package:flutter/material.dart';
import 'package:projectflutter/common/components/fields/my_text_field.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  const UsernameField({
    super.key,
    required this.controller,
    this.hintText = "Username",
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
          return 'Username is required';
        }
        if (value.length < 4) {
          return 'Username at least 4 characters';
        }
        return null;
      },
    );
  }
}
