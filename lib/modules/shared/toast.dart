import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationShowError {
  static void showToast({
    required BuildContext context,
    String description = "Something went wrong. Please try again later.",
    Duration autoCloseDuration = const Duration(seconds: 2),
    Color backgroundColor = Colors.red,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: const Text("Error"),
      autoCloseDuration: autoCloseDuration,
      description: Text(
        description,
        style: const TextStyle(
            //color: Colors.white
            ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: false,
    );
  }
}

class ToastificationShow {
  static void showToast({
    required BuildContext context,
    required title,
    required description,
    Duration autoCloseDuration = const Duration(seconds: 2),
    Color backgroundColor = Colors.green,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text("$title"),
      autoCloseDuration: autoCloseDuration,
      description: Text(
        "$description ",
        style: const TextStyle(
            //color: Colors.white
            ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: false,
    );
  }
}
