import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanDifficultyBottomSheet extends StatefulWidget {
  final int initialIndex;
  const PlanDifficultyBottomSheet({super.key, required this.initialIndex});

  @override
  State<PlanDifficultyBottomSheet> createState() =>
      _PlanDifficultyBottomSheetState();
}

class _PlanDifficultyBottomSheetState extends State<PlanDifficultyBottomSheet> {
  List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  late int selectedDifficultyIndex;
  late FixedExtentScrollController _controller;
  @override
  void initState() {
    super.initState();
    selectedDifficultyIndex = widget.initialIndex;
    _controller = FixedExtentScrollController(initialItem: selectedDifficultyIndex);
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan Difficulty',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.value20Text(context)),
          ),
          SizedBox(
            height: media.height * 0.02,
          ),
          SizedBox(
            height: 150, // Chiều cao của wheel
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.003,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedDifficultyIndex = index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= difficulties.length) return null;
                  final isSelected = index == selectedDifficultyIndex;
                  return Center(
                    child: Container(
                      width: media.width * 0.8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor3.withOpacity(0.1) : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryColor4 : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        difficulties[index],
                        style: TextStyle(
                          fontSize: AppFontSize.value18Text(context),
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primaryColor3 : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(selectedDifficultyIndex);
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
