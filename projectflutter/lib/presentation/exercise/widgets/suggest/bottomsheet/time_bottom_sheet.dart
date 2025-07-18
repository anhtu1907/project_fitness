  import 'package:flutter/material.dart';
  import 'package:projectflutter/core/config/themes/app_color.dart';
  import 'package:projectflutter/core/config/themes/app_font_size.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class TimeBottomSheet extends StatefulWidget {
    final bool initialIsScheduled;
    const TimeBottomSheet({
      super.key,
      required this.initialIsScheduled,
    });

    @override
    State<TimeBottomSheet> createState() => _TimeBottomSheetState();
  }

  class _TimeBottomSheetState extends State<TimeBottomSheet> {
    bool isScheduled = false;
    List<bool> selectedDays = List.generate(7, (_) => false);
    final List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    @override
    void initState() {
      super.initState();
      _loadPreferences();
    }

    Future<void> _loadPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      final savedSchedule = prefs.getBool('isScheduled');
      final savedDays = prefs.getStringList('selectedDays');

      setState(() {
        isScheduled = savedSchedule ?? widget.initialIsScheduled;
        if (savedDays != null && savedDays.length == 7) {
          selectedDays = savedDays.map((e) => e == 'true').toList();
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      var media = MediaQuery.of(context).size;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Workout Days',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSize.value20Text(context)),
            ),
            SizedBox(
              height: media.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule My Week',
                  style: TextStyle(
                      fontSize: AppFontSize.value16Text(context),
                      fontWeight: FontWeight.w500),
                ),
                Switch(
                    value: isScheduled,
                    activeColor: AppColors.primaryColor3,
                    onChanged: (value) {
                      setState(() {
                        isScheduled = value;
                        if(isScheduled){
                          selectedDays = List.generate(7, (_) => true);
                        }
                      });
                    })
              ],
            ),
            SizedBox(
              height: media.height * 0.02,
            ),
            Text(
              isScheduled
                  ? 'Schedule your workout days for the week. Turn it off if you don\'t need a specific schedule'
                  : 'You can start your plan on any day of the week',
              style: TextStyle(
                  color: AppColors.gray,
                  fontSize: AppFontSize.value16Text(context)),
            ),
            SizedBox(
              height: media.height * 0.02,
            ),
            if (isScheduled)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: weekdays.asMap().entries.map((entry) {
                    int index = entry.key;
                    String day = entry.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                              fontSize: AppFontSize.value18Text(context),
                              fontWeight: FontWeight.w600),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            checkboxTheme: const CheckboxThemeData(
                              shape: CircleBorder(),
                            ),
                          ),
                          child: Checkbox(
                                value: selectedDays[index],
                                activeColor: AppColors.primaryColor3,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == false &&
                                        selectedDays.where((e) => e == true).length == 1) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: Row(
                                              children: [
                                                Icon(Icons.warning_amber_rounded, color: Colors.deepOrange, size: AppFontSize.value20Text(context),),
                                                const SizedBox(width: 8,),
                                                Text('Notice', style: TextStyle(fontSize: AppFontSize.value20Text(context)),)
                                              ],
                                            ),
                                            content: Text('Please select at least one workout day', style: TextStyle(color: AppColors.gray,fontSize: AppFontSize.value16Text(context)),),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(); // Đóng dialog
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    selectedDays[index] = value!;
                                  });
                                },
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            SizedBox(
              height: media.height * 0.02,
            ),
            if(isScheduled)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                   setState(() {
                     selectedDays = List.generate(7, (index) {
                       return [1, 3, 4, 6].contains(index);
                     });
                   });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Let your coach decided',
                        style: TextStyle(
                            color: AppColors.gray.withOpacity(0.4),
                            decoration: TextDecoration.underline,
                            fontSize: AppFontSize.value12Text(context)),
                      ),
                      SizedBox(width: media.width * 0.02,),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: AppFontSize.value12Text(context),
                        color: AppColors.gray.withOpacity(0.3),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: media.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isScheduled', isScheduled);
                        await prefs.setStringList(
                          'selectedDays',
                          selectedDays.map((e) => e.toString()).toList(),
                        );

                        Navigator.of(context).pop({
                          'isScheduled': isScheduled,
                          'selectedDays': selectedDays,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor3,
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.value20Text(context),
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
