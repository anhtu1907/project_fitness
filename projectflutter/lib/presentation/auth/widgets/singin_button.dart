import 'package:flutter/material.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/data/auth/request/signin_request.dart';
import 'package:projectflutter/domain/auth/usecase/signin_usecase.dart';

class SinginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final void Function(AutovalidateMode mode)? onValidateModeChanged;

  const SinginButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    this.onValidateModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BasicReactiveButton(
      title: "Sign in",
      onPressed: () {
        onValidateModeChanged?.call(AutovalidateMode.always);

        if (formKey.currentState!.validate()) {
          context.read<ButtonStateCubit>().execute(
            usecase: SigninUseCase(),
            params: SigninRequest(
              username: usernameController.text,
              password: passwordController.text,
            ),
          );
        }
      },
    );
  }
}
