import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var titleStyle = TextStyle(
        fontSize: AppFontSize.value18Text(context),
        fontWeight: FontWeight.w700);
    var subTitleStyle = TextStyle(
        fontSize: AppFontSize.value16Text(context),
        fontWeight: FontWeight.w700);
    var contentStyle = TextStyle(
        fontSize: AppFontSize.value14Text(context), color: AppColors.gray);
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: false,
        title: Text(
          "Privacy Policy",
          style: TextStyle(
              fontSize: AppFontSize.titleAppBar(context),
              fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: titleStyle,
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                'We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information.',
                style: contentStyle,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              Text(
                '1. Information We Collect',
                style: subTitleStyle,
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                '- Personal information (name, email, age, gender)\n'
                '- Health and fitness data (workout logs, weight, goals)\n'
                '- Device and app usage information',
                style: contentStyle,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              Text(
                '2. How We Use Your Data',
                style: subTitleStyle,
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                '- To personalize your fitness experience\n'
                '- To improve our app features\n'
                '- To send you updates or support',
                style: contentStyle,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              Text(
                '3. Data Sharing',
                style: subTitleStyle,
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                '- We do NOT sell your data.\n'
                '- We may share anonymized analytics with partners to improve the app.',
                style: contentStyle,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              Text(
                '4. Data Security',
                style: subTitleStyle,
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                '- Your data is stored securely and encrypted where applicable.\n'
                '- We implement security measures to protect your information.',
                style: contentStyle,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              Text(
                '5. Your Rights',
                style: subTitleStyle,
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                '- You can access, update, or delete your data at any time.\n'
                '- Contact us at support@fitnesspro.com for any requests.',
                style: contentStyle,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              Text(
                'By using this app, you consent to this privacy policy.',
                style:contentStyle,
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                'Last Updated: July 2025',
                style: TextStyle(
                    fontSize: AppFontSize.value14Text(context),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
