import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/presentation/auth/pages/signin.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ElevatedButton.icon(
          onPressed: () {
            context.read<UserInfoDisplayCubit>().logout();
            AppNavigator.pushAndRemoveUntil(context, const SigninPage());
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, side: BorderSide.none),
          label: const Text('Logout'),
          icon: const Icon(Icons.logout),
        );
      },
    );
  }
}
