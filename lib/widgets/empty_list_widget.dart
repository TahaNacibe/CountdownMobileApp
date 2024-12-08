import 'package:countdown_mobile/animated/loading_handler.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

Widget emptyListResult({
  required String message,
  required IconData icon,
  required Function() action,
}) {
  bool loading = false;
  return StatefulBuilder(builder: (context, setState) {
    return loading
    // loading for refetch
        ? loadingAnimatedWidget(pageIcon: icon)
        // the actual page 
        : Center(
            child: GestureDetector(
              onTap: () {
                action();
                setState(() {
                  loading = true;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Icon(Ionicons.reload),
                ],
              ),
            ),
          );
  });
}
