import 'package:flutter/material.dart';
import 'package:projectflutter/common/components/fields/my_text_field.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';

class DobField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const DobField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: controller,
      hintText: "Date of Birth",
      onTap: onTap,
      obSecureText: false,
      prefixIcon: const IconCustom(icon: Icons.calendar_today),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'DoB is required';
        }
        return null;
      },
      keyboardType: TextInputType.datetime,
    );
  }
}
