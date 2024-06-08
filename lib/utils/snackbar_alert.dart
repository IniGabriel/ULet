import 'package:flutter/material.dart';
import 'package:ulet_1/utils/colors.dart';
import 'package:ulet_1/utils/font_size.dart';

class CustomSnackbarAlert {
  void showSnackbarWarning(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: CustomFontSize.primaryFontSize,
        ),
      ),
      backgroundColor: CustomColors.warningColor,
      duration: const Duration(milliseconds: 1300),
    ));
  }

  void showSnackbarError(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: CustomFontSize.primaryFontSize,
        ),
      ),
      backgroundColor: CustomColors.primaryColor,
      duration: const Duration(milliseconds: 1300),
    ));
  }
}
