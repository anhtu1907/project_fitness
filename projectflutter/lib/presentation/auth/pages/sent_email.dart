import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/common/widget/button/basic_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/presentation/auth/pages/signin.dart';

class SentEmailPage extends StatelessWidget {
  const SentEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(hideBack: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.sentEmail),
          const SizedBox(
            height: 15,
          ),
          const Text('We sent you an email to reset your password'),
          const SizedBox(
            height: 15,
          ),
          BasicButton(
              title: 'Return to Login',
              onPressed: () {
                AppNavigator.pushAndRemoveUntil(context, SigninPage());
              })
        ],
      ),
    );
  }
}
