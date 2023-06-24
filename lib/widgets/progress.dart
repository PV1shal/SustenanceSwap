import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Custom Circular Progress Indicatior
Container customCircularProgressIndicator() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 10.0),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(AppColors.primaryFocusColor),
    ),
  );
}

/// Custom Linear Progress Indicatior
Container customLinearProgressIndicator() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(bottom: 10.0),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(AppColors.primaryFocusColor),
    ),
  );
}
