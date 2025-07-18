import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/bottomsheet/app_bottom_sheet.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/bottomsheet/time_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimePlanSetting extends StatefulWidget {
  const TimePlanSetting({super.key});

  @override
  State<TimePlanSetting> createState() => _TimePlanSettingState();
}

class _TimePlanSettingState extends State<TimePlanSetting> {
  bool _isScheduled = false;
  List<bool> _selectedDays = List.generate(7, (_) => false);
  @override
  void initState() {
    super.initState();
    _loadSavedSchedule();
  }

  void _openTimeBottomSheet() async {
    final result = await AppBottomSheet.display(
      context,
      TimeBottomSheet(initialIsScheduled: _isScheduled),
    );

    if (result != null && result is Map) {
      setState(() {
        _isScheduled = result['isScheduled'] ?? false;
        _selectedDays = List<bool>.from(result['selectedDays'] ?? []);
      });
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isScheduled', _isScheduled);
    await prefs.setStringList(
      'selectedDays',
      _selectedDays.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _loadSavedSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSchedule = prefs.getBool('isScheduled');
    final savedDays = prefs.getStringList('selectedDays');

    setState(() {
      _isScheduled = savedSchedule ?? false;
      if (savedDays != null && savedDays.length == 7) {
        _selectedDays = savedDays.map((e) => e == 'true').toList();
      }
    });
  }

  String _buildSelectedDaysText(List<bool> selectedDays) {
    if (!_isScheduled) return 'None Scheduled';
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selected = <String>[];

    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) selected.add(weekdays[i]);
    }

    if (selected.length == 7) return 'Every day';
    return selected.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      width: media.width * 0.9,
      height: media.height * 0.1,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey.shade500.withOpacity(0.1), width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: _openTimeBottomSheet,
            title: Text(
              'Workout Days',
              style: TextStyle(
                  fontSize: AppFontSize.value12Text(context),
                  color: Colors.grey,
                  fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              _buildSelectedDaysText(_selectedDays),
              style: TextStyle(
                  fontSize: AppFontSize.value16Text(context),
                  fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              size: AppFontSize.value16Text(context),
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
