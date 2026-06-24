import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar(String title, String message, {bool isError = false}) {
  // Close any active snackbars to prevent stack up
  if (Get.isSnackbarOpen) {
    Get.closeAllSnackbars();
  }
  
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color(0xFF374151), // Cool dark grey
    colorText: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    borderRadius: 12,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    boxShadows: [
      BoxShadow(
        color: const Color(0x26000000),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
