import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/basic_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/bmi/pages/check_bmi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? firstname;
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstname = prefs.getString("firstname");
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Container(
        width: media.width,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: media.width * 0.1,
            ),
            Image.asset(
              AppImages.welcome,
              width: media.width * 0.75,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: media.width * 0.1,
            ),
            Text('Welcome, $firstname',
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            Text(
              "You are all set now, let’s reach your\ngoals together with us",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray, fontSize: 12),
            ),
            const Spacer(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BasicButton(
                    title: "Go To Home",
                    onPressed: () {
                      AppNavigator.pushAndRemoveUntil(
                          context, const CheckBmiPage());
                    }),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
