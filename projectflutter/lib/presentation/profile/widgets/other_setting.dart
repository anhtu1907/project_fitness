import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/personal/setting_row.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/profile/pages/contact_us.dart';
import 'package:projectflutter/presentation/profile/pages/privacy_policy.dart';
import 'package:projectflutter/presentation/profile/pages/profile_view.dart';
import 'package:projectflutter/presentation/profile/pages/setting.dart';

class OtherSetting extends StatelessWidget {
  const OtherSetting({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    List<AccoutSetting> otherData = [
      AccoutSetting(
          imageIcon: AppImages.pContact,
          title: "Contact Us",
          onPressed: () {
            AppNavigator.push(context, const ContactUsPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pPrivacy,
          title: "Privacy Policy",
          onPressed: () {
            AppNavigator.push(context, const PrivacyPolicyPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pSetting,
          title: "Setting",
          onPressed: () {
            AppNavigator.push(context, const SettingPage());
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
            'Other',
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
            itemCount: otherData.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return SettingRow(
                  imageIcon: otherData[index].imageIcon,
                  title: otherData[index].title,
                  onPressed: otherData[index].onPressed);
            },
          )
        ],
      ),
    );
  }
}
