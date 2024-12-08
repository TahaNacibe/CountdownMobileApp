import 'package:flutter/material.dart';

// Fast and reusable Snackbar function
void showCustomSnackBar(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 2)}) {
  // duration is editable from the call
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).iconTheme.color),
      ),
      duration: duration,
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
