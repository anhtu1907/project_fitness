import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class GoalBottomSheet extends StatefulWidget {
  final int initialIndex;

  const GoalBottomSheet({
    super.key,
    required this.initialIndex,
  });

  @override
  State<GoalBottomSheet> createState() => _GoalBottomSheetState();
}

class _GoalBottomSheetState extends State<GoalBottomSheet> {
  late int selectedIndex;

  final List<String> goals = [
    'Lose Weight',
    'Build Muscle',
    'Keep Fit',
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
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
            'Choose Your Goal',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.value20Text(context)),
          ),
          SizedBox(height: media.height * 0.02),
          Center(
            child: SizedBox(
              width: media.width * 0.88,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: goals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  String goal = goals[index];
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor1.withOpacity(0.2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor1
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                goal,
                                style: TextStyle(
                                  fontSize: AppFontSize.value20Text(context),
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primaryColor3
                                      : Colors.black87,
                                ),
                              ),
                              SwitchImageType.buildImage(
                                _getImageForGoal(goal),
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 12,
                            right: 10,
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.primaryColor3,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: media.height * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedIndex);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor3,
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

  String _getImageForGoal(String goal) {
    switch (goal) {
      case 'Loss Weight':
        return 'assets/images/lose_weight.png';
      case 'Build Muscle':
        return 'assets/images/build_muscle.png';
      case 'Keep Fit':
        return 'assets/images/keep_fit.png';
      default:
        return 'assets/images/full_body.png';
    }
  }
}
