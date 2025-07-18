import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EquipmentBottomSheet extends StatefulWidget {
  final List<String> initialSelected;
  const EquipmentBottomSheet({super.key, required this.initialSelected});

  @override
  State<EquipmentBottomSheet> createState() => _EquipmentBottomSheetState();
}

class _EquipmentBottomSheetState extends State<EquipmentBottomSheet> {
  bool hasDumbbell = false;
  bool hasChair = false;

  @override
  void initState() {
    super.initState();
    hasDumbbell = widget.initialSelected.contains('Dumbbell');
    hasChair = widget.initialSelected.contains('Chair');
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
              'Available Equipment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.value20Text(context),
              ),
            ),
            const SizedBox(height: 20),
            _equipmentRow(
              context,
              label: 'Dumbbell',
              assetPath: 'assets/images/dumbbell.png',
              value: hasDumbbell,
              onChanged: (val) => setState(() => hasDumbbell = val),
            ),
            const SizedBox(height: 20),
            _equipmentRow(
              context,
              label: 'Chair',
              assetPath: 'assets/images/chair.png',
              value: hasChair,
              onChanged: (val) => setState(() => hasChair = val),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final selected = <String>[];
                  if (hasDumbbell) selected.add('Dumbbell');
                  if (hasChair) selected.add('Chair');
                  Navigator.of(context).pop(selected);
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
            )
          ],
        ));
  }

  Widget _equipmentRow(BuildContext context,
      {required String label,
      required String assetPath,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    var media = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SwitchImageType.buildImage(assetPath, width: 50, height: 50),
            SizedBox(width: media.width * 0.05),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.value16Text(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          activeColor: AppColors.primaryColor3,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
