import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class ForgotPassword extends StatelessWidget {
  final VoidCallback onTap;

  const ForgotPassword({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Forgot Password?",
        recognizer: TapGestureRecognizer()..onTap = onTap,
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.bold,fontSize: AppFontSize.questionText(context)),
      ),
    );
  }
}
