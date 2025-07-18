import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/data/auth/request/register_request.dart';
import 'package:projectflutter/domain/auth/usecase/signup_usecase.dart';
import 'package:projectflutter/presentation/auth/bloc/gender_selection_cubit.dart';
import 'package:projectflutter/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController firstnameController;
  final TextEditingController lastnameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController dobController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final SecureStorage secureStorage;
  final void Function(AutovalidateMode mode)? onValidateModeChanged;

  const SignupButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.firstnameController,
    required this.lastnameController,
    required this.emailController,
    required this.passwordController,
    required this.dobController,
    required this.phoneController,
    required this.secureStorage,
    required this.addressController,
    this.onValidateModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BasicReactiveButton(
      title: "Sign up",
      onPressed: () async {
        onValidateModeChanged?.call(AutovalidateMode.always);

        await secureStorage.writeSecureData('username', usernameController.text);
        await secureStorage.writeSecureData('password', passwordController.text);

        if (formKey.currentState!.validate()) {
          final genderIndex = context.read<GenderSelectionCubit>().state;

          context.read<ButtonStateCubit>().execute(
            usecase: SignupUsecase(),
            params: RegisterRequest(
              username: usernameController.text,
              firstname: firstnameController.text,
              lastname: lastnameController.text,
              email: emailController.text,
              password: passwordController.text,
              dob: DateFormat('yyyy-MM-dd').parse(dobController.text),
              address: addressController.text,
              gender: genderIndex,
              phone: phoneController.text,
            ),
          );
        }
      },
    );
  }
}
