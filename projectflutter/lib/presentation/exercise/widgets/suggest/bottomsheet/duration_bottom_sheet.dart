import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DurationBottomSheet extends StatefulWidget {
  final int initialIndex;
  const DurationBottomSheet({super.key, required this.initialIndex});

  @override
  State<DurationBottomSheet> createState() =>
      _DurationBottomSheetState();
}

class _DurationBottomSheetState extends State<DurationBottomSheet> {
  List<String> difficulties = ['<10 min/day', '10-20 min/day', '20-30 min/day', '30-45 min/day'];
  late int selectedDuraitonIndex;
  late FixedExtentScrollController _controller;
  @override
  void initState() {
    super.initState();
    selectedDuraitonIndex = widget.initialIndex;
    _controller = FixedExtentScrollController(initialItem: selectedDuraitonIndex);
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
            'Preferred Duration',
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
                  selectedDuraitonIndex = index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= difficulties.length) return null;
                  final isSelected = index == selectedDuraitonIndex;
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
                      Navigator.of(context).pop(selectedDuraitonIndex);
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
