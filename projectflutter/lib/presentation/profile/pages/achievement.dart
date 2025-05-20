import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';

class AchievementPage extends StatelessWidget {
  const AchievementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BasicAppBar(
        hideBack: false,
        title: Text(
          "Achievement",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Text('Achievement'),
      ),
    );
  }
}
