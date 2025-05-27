import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BasicAppBar(
        hideBack: false,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      body: const  SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  '1. Information We Collect',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '- Personal information (name, email, age, gender)\n'
                  '- Health and fitness data (workout logs, weight, goals)\n'
                  '- Device and app usage information',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  '2. How We Use Your Data',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '- To personalize your fitness experience\n'
                  '- To improve our app features\n'
                  '- To send you updates or support',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  '3. Data Sharing',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '- We do NOT sell your data.\n'
                  '- We may share anonymized analytics with partners to improve the app.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  '4. Data Security',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '- Your data is stored securely and encrypted where applicable.\n'
                  '- We implement security measures to protect your information.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  '5. Your Rights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '- You can access, update, or delete your data at any time.\n'
                  '- Contact us at support@fitnesspro.com for any requests.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  'By using this app, you consent to this privacy policy.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'Last Updated: April 2025',
                  style: TextStyle(
                      fontSize: 12,
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
