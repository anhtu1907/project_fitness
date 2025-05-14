import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        hideBack: false,
        titlte: Text(
          "Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
            subtitle: Text("Manage your profile and password"),
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text("Workout Preferences"),
            subtitle: Text("Set your goals and unit (kg/lb)"),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            subtitle: Text("Reminders and workout alerts"),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Privacy Policy"),
            subtitle: Text("Learn how we handle your data"),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Support & FAQ"),
            subtitle: Text("Need help?"),
          ),
        ],
      ),
    );
  }
}
