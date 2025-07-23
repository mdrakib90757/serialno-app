

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {

  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onOkPressed,
  }) async {
    await Flushbar(
      title: title,
      titleColor: Colors.green.shade700,
      icon: const Icon(Icons.check_circle, color: Colors.green),
      message: message,
      messageColor: Colors.black,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      borderRadius: BorderRadius.circular(12),
      borderColor: Colors.green.shade300,
      borderWidth: 1.5,
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible: true,
      mainButton: TextButton(
        onPressed: () {
          if (onOkPressed != null) onOkPressed();
        },
        child: const Text(
          "OK",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).show(context);
  }
}
