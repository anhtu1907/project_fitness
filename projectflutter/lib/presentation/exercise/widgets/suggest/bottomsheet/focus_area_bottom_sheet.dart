import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class FocusAreaBottomSheet extends StatefulWidget {
  final List<bool> selectedAreas;
  const FocusAreaBottomSheet({
    super.key,
    required this.selectedAreas,
  });

  @override
  State<FocusAreaBottomSheet> createState() => _FocusAreaBottomSheetState();
}

class _FocusAreaBottomSheetState extends State<FocusAreaBottomSheet> {
  late List<bool> selectedAreas;

  late int selectedAreaIndex;
  List<String> bodyArea = ['Arm', 'Shoulder', 'Chest', 'Core','Butt & Leg','Back','Full Body'];
  @override
  void initState() {
    super.initState();
    selectedAreas = List<bool>.from(widget.selectedAreas);
    if (selectedAreas.length == bodyArea.length &&
        selectedAreas[bodyArea.length - 1] == true) {
      for (int i = 0; i < selectedAreas.length; i++) {
        selectedAreas[i] = true;
      }
    }
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
            'Please choose your focus area',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.value20Text(context)),
          ),
          SizedBox(height: media.height * 0.02),
          SizedBox(
            width: media.width * 0.55,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bodyArea.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                String body = bodyArea[index];
                bool isSelected = selectedAreas[index];
                bool isFullBody = index == bodyArea.length - 1;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: selectedAreas[index]
                        ? AppColors.primaryColor1.withOpacity(0.2)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryColor1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: AppFontSize.value14Text(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          checkboxTheme: const CheckboxThemeData(shape: CircleBorder()),
                        ),
                        child: Checkbox(
                          value: selectedAreas[index],
                          activeColor: AppColors.primaryColor3,
                          onChanged: (value) {
                            setState(() {
                              final newSelected = List<bool>.from(selectedAreas);

                              if (isFullBody && value == true) {
                                for (int i = 0; i < newSelected.length; i++) {
                                  newSelected[i] = true;
                                }
                              } else if (isFullBody && value == false) {
                                for (int i = 0; i < newSelected.length; i++) {
                                  newSelected[i] = false;
                                }
                              } else {
                                newSelected[index] = value!;

                                if (!value) {
                                  newSelected[newSelected.length - 1] = false;
                                } else {
                                  bool allOthersSelected = newSelected
                                      .sublist(0, newSelected.length - 1)
                                      .every((e) => e);
                                  if (allOthersSelected) {
                                    newSelected[newSelected.length - 1] = true;
                                  }
                                }
                              }

                              selectedAreas = newSelected;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: media.height * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedAreas.contains(true) ?() {
                    final selectedNames = <String>[];
                    for (int i = 0; i < selectedAreas.length; i++) {
                      if (selectedAreas[i]) {
                        selectedNames.add(bodyArea[i]);
                      }
                    }

                    Navigator.of(context).pop(selectedNames);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAreas.contains(true)
                        ? AppColors.primaryColor3
                        : Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSize.value20Text(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
