import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class BasicReactiveButton extends StatelessWidget {
  const BasicReactiveButton(
      {super.key, required this.title, required this.onPressed, this.height});
  final String title;
  final VoidCallback onPressed;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoadingState) {
          return _loading();
        }
        return _initial();
      },
    );
  }

  Widget _loading() {
    return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(height ?? 50)),
        child: Container(
            height: height ?? 50,
            alignment: Alignment.center,
            child: const CircularProgressIndicator()));
  }

  Widget _initial() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: AppColors.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(50)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(height ?? 50),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
    );
  }
}
