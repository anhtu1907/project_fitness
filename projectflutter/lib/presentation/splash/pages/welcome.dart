import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/basic_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
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
            SwitchImageType.buildImage(
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
                    fontSize: AppFontSize.heading1(context),
                    fontWeight: FontWeight.w700)),
            Text(
              "You are all set now, let’s reach your\ngoals together with us",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.gray,
                  fontSize: AppFontSize.caption(context)),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: double.infinity,
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
