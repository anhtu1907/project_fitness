import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        hideBack: false,
        title: Text(
          "Contact Us",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: const [
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text("support@fitnesspro.com"),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Phone"),
              subtitle: Text("+1 234 567 890"),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Address"),
              subtitle: Text("123 Fit Street, Workout City, Country"),
            ),
            ListTile(
              leading: Icon(Icons.facebook),
              title: Text("Facebook"),
              subtitle: Text("facebook.com/fitnesspro"),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Instagram"),
              subtitle: Text("@fitnesspro_official"),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text("Working Hours"),
              subtitle: Text("Mon - Fri: 9:00 AM - 6:00 PM"),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("FAQs"),
              subtitle: Text("Find answers to common questions"),
            ),
            SizedBox(height: 20),
            Text(
              'We’re here to help you on your fitness journey. Don’t hesitate to reach out!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
