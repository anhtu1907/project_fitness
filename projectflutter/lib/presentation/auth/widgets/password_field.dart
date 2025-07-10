import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/field/field_state.dart';
import 'package:projectflutter/common/bloc/field/field_state_cubit.dart';
import 'package:projectflutter/common/components/fields/my_text_field.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = "Password",
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FieldStateCubit(),
      child: BlocBuilder<FieldStateCubit, FieldState>(
        builder: (context, state) {
          final obSecureText = state is HideTextState;

          return MyTextField(
            controller: controller,
            hintText: hintText,
            obSecureText: obSecureText,
            keyboardType: TextInputType.text,
            prefixIcon: const IconCustom(icon: Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                context.read<FieldStateCubit>().toggleVisibility();
              },
              icon: Icon(
                obSecureText ? Icons.visibility_off : Icons.visibility,
                size: 25,
              ),
            ),
            validator: validator ??
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
          );
        },
      ),
    );
  }
}
