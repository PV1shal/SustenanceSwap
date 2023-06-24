import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Common header for application
AppBar header({String titleText = ""}) {
  return AppBar(
    title: Text(
      titleText,
      style: const TextStyle(
        color: AppColors.primaryFontColor,
        fontSize: 30.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: AppColors.primaryAppBarBackgroundColor,
  );
}
