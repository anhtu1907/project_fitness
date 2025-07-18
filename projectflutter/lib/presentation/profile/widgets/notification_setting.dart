import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});
  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool positive = false;
  @override
  void initState() {
    super.initState();
    _loadPositiveState();
  }

  _loadPositiveState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      positive = prefs.getBool('positive') ?? false;
    });
  }

  // Lưu trạng thái vào SharedPreferences
  _savePositiveState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('positive', value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SwitchImageType.buildImage(
            AppImages.pNotification,
            height: 15,
            width: 15,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Text(
            "Pop-up Notification",
            style: TextStyle(color: AppColors.black, fontSize: 12),
          )),
          CustomAnimatedToggleSwitch<bool>(
            current: positive,
            values: const [false, true],
            spacing: 0.0,
            indicatorSize: const Size.square(30.0),
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.linear,
            onChanged: (b) => setState(() => positive = b),
            iconBuilder: (context, local, global) {
              return const SizedBox();
            },
            cursors:
                const ToggleCursors(defaultCursor: SystemMouseCursors.click),
            onTap: (b) {
              setState(() {
                positive = !positive;
                _savePositiveState(positive);
              });
            },
            iconsTappable: false,
            wrapperBuilder: (context, global, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      left: 10.0,
                      right: 10.0,
                      height: 30.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: AppColors.secondaryG),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                        ),
                      )),
                  child,
                ],
              );
            },
            foregroundIndicatorBuilder: (context, global) {
              return SizedBox.fromSize(
                size: const Size(10, 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 0.05,
                          blurRadius: 1.1,
                          offset: Offset(0.0, 0.8))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
