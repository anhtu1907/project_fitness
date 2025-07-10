import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/other_plan_setting.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/time_plan_setting.dart';

class SettingPlanPage extends StatefulWidget {
  const SettingPlanPage({super.key});

  @override
  State<SettingPlanPage> createState() => _SettingPlanPageState();
}

class _SettingPlanPageState extends State<SettingPlanPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: false,
        title: Text('Adjust Plan',
            style: TextStyle(fontSize: AppFontSize.heading2(context))),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Center(
        child: Column(
          children: [
            const TimePlanSetting(),
            SizedBox(height: media.height * 0.02,),
            const OtherPlanSetting()
          ],
        ),
      ),
    );
  }
}
