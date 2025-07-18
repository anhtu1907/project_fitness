import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/personal/setting_row.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/personal/pages/personal_view.dart';
import 'package:projectflutter/presentation/profile/pages/achievement.dart';
import 'package:projectflutter/presentation/profile/pages/history.dart';
import 'package:projectflutter/presentation/profile/pages/profile_view.dart';
import 'package:projectflutter/presentation/profile/pages/workout_progress.dart';

class AccountSetting extends StatelessWidget {
  const AccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    List<AccoutSetting> accountData = [
      AccoutSetting(
          imageIcon: AppImages.pPersonsal,
          title: "Personal Data",
          onPressed: () {
            AppNavigator.push(context, const PersonalPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pAchi,
          title: "Achievement",
          onPressed: () {
            AppNavigator.push(context, const AchievementPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pActivity,
          title: "Activity History",
          onPressed: () {
            AppNavigator.push(context, const HistoryPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pWorkout,
          title: "Workout Progress",
          onPressed: () {
            AppNavigator.push(context, const WorkoutProgressPage());
          }),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: TextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.value16Text(context),
                fontWeight: FontWeight.bold),
          ),
           SizedBox(
            height: media.height * 0.03,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: accountData.length,
            itemBuilder: (context, index) {
              return SettingRow(
                  imageIcon: accountData[index].imageIcon,
                  title: accountData[index].title,
                  onPressed: accountData[index].onPressed);
            },
          )
        ],
      ),
    );
  }


}
