import 'package:flutter/material.dart';

class FormEditWeight extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  final double weight;
  final TextStyle weightStyle;
  final String unit;
  final TextStyle unitStyle;
  final Icon icon;
  final CrossAxisAlignment cross;
  final MainAxisAlignment main;
  final VoidCallback onTap;
  final bool isPressed;

  const FormEditWeight(
      this.title,
      this.textStyle,
      this.weight,
      this.weightStyle,
      this.unit,
      this.unitStyle,
      this.icon,
      this.cross,
      this.main,
      this.onTap,
      this.isPressed,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: main,
              children: [
                Text(weight.toStringAsFixed(1),
                    style: isPressed
                        ? weightStyle
                        : weightStyle.copyWith(color: Colors.grey)),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  unit,
                  style: isPressed
                      ? unitStyle
                      : unitStyle.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  width: 4,
                ),
                icon,
              ],
            ))
      ],
    );
  }
}
