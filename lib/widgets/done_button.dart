import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Common done button for Application.
Container customDoneButton() {
  return Container(
    child: Semantics(
      label: "Done",
      child: const Icon(
        Icons.done,
        color: AppColors.primaryFocusColor,
      ),
    ),
  );
}
