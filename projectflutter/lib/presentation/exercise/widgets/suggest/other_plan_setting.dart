import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/bottomsheet/app_bottom_sheet.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/bottomsheet/duration_bottom_sheet.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/bottomsheet/equipment_bottom_sheet.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/bottomsheet/focus_area_bottom_sheet.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/bottomsheet/goal_bottom_sheet.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/bottomsheet/plan_difficulty_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherPlanSetting extends StatefulWidget {
  final VoidCallback? onApply;
  const OtherPlanSetting({super.key, this.onApply});

  @override
  State<OtherPlanSetting> createState() => _OtherPlanSettingState();
}

class _OtherPlanSettingState extends State<OtherPlanSetting> {
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedEquipments = prefs.getStringList('selectedEquipments') ?? [];
    final savedAreas = prefs.getStringList('selectedBodyAreas');
    if (savedAreas != null) {
      _selectedBodyAreas = List.generate(7, (i) => savedAreas.contains(bodyArea[i]));
      _selectedFocusAreaText = savedAreas.contains('Full Body')
          ? 'Full Body'
          : savedAreas.join(', ');
    }

    _selectedDuraitonIndex = prefs.getInt('selectedDurationIndex') ?? 0;

    _selectedDifficultyIndex = prefs.getInt('selectedDifficultyIndex') ?? 0;
    _selectedGoalIndex = prefs.getInt('selectedGoalIndex') ?? 0;

    setState(() {});
  }
  List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  List<String> durations = ['<10 min/day', '10-20 min/day', '20-30 min/day', '30-45 min/day'];
  List<bool> _selectedBodyAreas = List.generate(7, (i) => i == 6);
  List<String> bodyArea = ['Arm', 'Shoulder', 'Chest', 'Core','Butt & Leg','Back','Full Body'];
  List<String> goals = ['Lose Weight', 'Build Muscle', 'Keep Fit'];
  String _selectedFocusAreaText = 'Full Body';
  int _selectedDifficultyIndex = 0;
  int _selectedDuraitonIndex = 0;
  int _selectedGoalIndex = 0;
  List<String> _selectedEquipments = [];
  bool _shouldShowApplyButton() {
    final isBodyAreaDefault =
        _selectedBodyAreas.every((e) => e == false) || _selectedFocusAreaText == 'Full Body';

    return _selectedDifficultyIndex != 0 ||
        _selectedDuraitonIndex != 0 ||
        _selectedGoalIndex != 0 ||
        _selectedEquipments.isNotEmpty ||
        !isBodyAreaDefault;
  }
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> plans = [
      {
        'title': 'Plan Difficulty',
        'subtitle': difficulties[_selectedDifficultyIndex],
        'onTap': () async {
          final result = await AppBottomSheet.display(
            context,
            PlanDifficultyBottomSheet(initialIndex: _selectedDifficultyIndex),
          );

          if (result != null && result is int) {
            setState(() {
              _selectedDifficultyIndex = result;
            });
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('selectedDifficultyIndex', result);
        },
      },
      {
        'title': 'Focus Area',
        'subtitle': _selectedFocusAreaText,
        'onTap': () async {
          final result = await AppBottomSheet.display(
            context,
            FocusAreaBottomSheet(
              selectedAreas: _selectedBodyAreas,
            ),
          );

          if (result != null && result is List<String>) {
            setState(() {
              if (result.contains('Full Body')) {
                _selectedFocusAreaText = 'Full Body';
              } else {
                _selectedFocusAreaText = result.join(', ');
              }

              _selectedBodyAreas =
                  List.generate(7, (i) => result.contains(bodyArea[i]));
            });
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setStringList('selectedBodyAreas', result);
        },
      },
      {
        'title': 'Preferred Duration',
        'subtitle': durations[_selectedDuraitonIndex],
        'onTap': () async {
          final result = await AppBottomSheet.display(
            context,
            DurationBottomSheet(initialIndex: _selectedDuraitonIndex),
          );

          if (result != null && result is int) {
            setState(() {
              _selectedDuraitonIndex = result;
            });
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('selectedDurationIndex', result);
        },
      },
      {
        'title': 'Goal',
        'subtitle': goals[_selectedGoalIndex],
        'onTap': () async {
          final result = await AppBottomSheet.display(
            context,
            GoalBottomSheet(initialIndex: _selectedGoalIndex,),
          );

          if (result != null && result is int) {
            setState(() {
              _selectedGoalIndex = result;
            });
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('selectedGoalIndex', result);
        },
      },
      {
        'title': 'Available Equipment',
        'subtitle': _selectedEquipments.isEmpty
            ? 'None'
            : _selectedEquipments.join(', '),
        'onTap': () async {
          final result = await AppBottomSheet.display(
            context,
            EquipmentBottomSheet(initialSelected: _selectedEquipments),
          );

          if (result != null && result is List<String>) {
            setState(() {
              _selectedEquipments = result;
            });
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setStringList('selectedEquipments', result);
        },
      },
    ];
    var media = MediaQuery.of(context).size;
    return Container(
      width: media.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey.shade500.withOpacity(0.1), width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
          children: [
            ...List.generate(
              plans.length * 2 - 1,
                  (index) {
                if (index.isEven) {
                  int realIndex = index ~/ 2;
                  final item = plans[realIndex];
                  return _listTile(
                    item['title'],
                    item['subtitle'],
                    item['onTap'],
                  );
                } else {
                  return Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.shade200,
                  );
                }
              },
            ),
            SizedBox(height: media.height * 0.2,),
            if (_shouldShowApplyButton()) ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply!();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor3,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSize.value20Text(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ]),
    );
  }


  Widget _listTile(String title, String subTitle, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(title,
          style: TextStyle(
              fontSize: AppFontSize.value12Text(context),
              color: Colors.grey,
              fontWeight: FontWeight.w700)),
      subtitle: Text(subTitle,
          style: TextStyle(
              fontSize: AppFontSize.value16Text(context),
              fontWeight: FontWeight.bold)),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: AppFontSize.value16Text(context),
        color: Colors.grey.shade400,
      ),
    );
  }
}
