import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class SwitchPageButton extends StatelessWidget {
  final String questionText;
  final String buttonText;
  final VoidCallback onTap;

  const SwitchPageButton({
    super.key,
    required this.questionText,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: questionText,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: AppFontSize.questionText(context)
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: buttonText,
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor3,
                fontSize: AppFontSize.buttonText(context)),
          ),
        ],
      ),
    );
  }
}
