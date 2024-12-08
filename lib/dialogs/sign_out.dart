import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  return (await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User chose "No"
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User chose "Yes"
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  )) ??
      false; // If null, return false by default
}
