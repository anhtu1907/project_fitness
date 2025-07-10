import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var titleStyle = TextStyle(
        fontSize: AppFontSize.value16Text(context),
        fontWeight: FontWeight.w700);
    var subTitleStyle = TextStyle(
        fontSize: AppFontSize.value14Text(context), color: AppColors.gray);
    var iconStyle = AppFontSize.value28Text(context);
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: false,
        title: Text(
          "Contact Us",
          style: TextStyle(
              fontSize: AppFontSize.titleAppBar(context),
              fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: Icon(Icons.email,size: iconStyle,),
              title: Text(
                "Email",
                style: titleStyle,
              ),
              subtitle: Text(
                "support@fitnesspro.com",
                style: subTitleStyle,
              ),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            ListTile(
              leading: Icon(Icons.phone,size: iconStyle,),
              title: Text("Phone", style: titleStyle,),
              subtitle: Text("+1 234 567 890",style: subTitleStyle),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            ListTile(
              leading: Icon(Icons.location_on,size: iconStyle,),
              title: Text("Address", style: titleStyle,),
              subtitle: Text("123 Fit Street, Workout City, Country",style: subTitleStyle),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            ListTile(
              leading: Icon(Icons.facebook,size: iconStyle,),
              title: Text("Facebook", style: titleStyle,),
              subtitle: Text("facebook.com/fitmate",style: subTitleStyle),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.instagram,size: iconStyle,),
              title: Text("Instagram", style: titleStyle,),
              subtitle: Text("@fitmate_official",style: subTitleStyle),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            ListTile(
              leading: Icon(Icons.access_time,size: iconStyle,),
              title: Text("Working Hours", style: titleStyle,),
              subtitle: Text("Mon - Fri: 9:00 AM - 6:00 PM",style: subTitleStyle),
            ),
            SizedBox(
              height: media.height * 0.01,
            ),
            ListTile(
              leading: Icon(Icons.help_outline,size: iconStyle,),
              title: Text("FAQs", style: titleStyle,),
              subtitle: Text("Find answers to common questions",style: subTitleStyle),
            ),
            SizedBox(
              height: media.height * 0.03,
            ),
            Text(
              'We’re here to help you on your fitness journey. Don’t hesitate to reach out!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppFontSize.value16Text(context)),
            )
          ],
        ),
      ),
    );
  }
}
