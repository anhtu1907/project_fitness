import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppBar(
            hideBack: true,
            titlte: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Personal Daily'),
                const SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.database,
                  color: AppColors.iconColor,
                )
              ],
            )),
        body: const Center(
          child: Text('Personal Data'),
        ));
  }
}
