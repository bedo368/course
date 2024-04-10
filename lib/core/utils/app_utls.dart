import 'package:course_app/core/res/colors.dart';
import 'package:flutter/material.dart';

class AppUtils {
  const AppUtils._();

  static void showSnackBar(
      {required BuildContext context,
      required String message,
      bool error = false,}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? Colours.redColor : Colours.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
        ),
      );
  }
}
