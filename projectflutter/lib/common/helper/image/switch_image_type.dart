import 'package:flutter/cupertino.dart';

class SwitchImageType{
  static Widget buildImage(String imagePath,
      {double? width, double? height, BoxFit? fit, BorderRadius? borderRadius, Color? color}) {
    final imageWidget = imagePath.startsWith('http')
        ? Image.network(imagePath, width: width, height: height, fit: fit,color: color,)
        : Image.asset(imagePath, width: width, height: height, fit: fit,color: color);

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}