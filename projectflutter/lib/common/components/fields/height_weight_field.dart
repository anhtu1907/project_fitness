import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class HeightWeightField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obSecureText;
  final TextInputType keyboardType;
  final String? suffixText;
  final VoidCallback? onTap;
  final Widget? borderSide;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;

  const HeightWeightField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obSecureText,
      required this.keyboardType,
      this.suffixText,
      this.onTap,
      this.prefixIcon,
      this.borderSide,
      this.validator,
      this.focusNode,
      this.errorMsg,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            obscureText: obSecureText,
            keyboardType: keyboardType,
            validator: validator,
            focusNode: focusNode,
            onTap: onTap,
            onChanged: onChanged,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              enabledBorder:
                  Theme.of(context).inputDecorationTheme.enabledBorder,
              focusedBorder:
                  Theme.of(context).inputDecorationTheme.focusedBorder,
              errorText: errorMsg,
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (suffixText != null)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.secondaryG),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              suffixText!,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
      ],
    );
  }
}
