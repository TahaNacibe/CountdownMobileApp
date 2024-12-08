import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//* Show profile picture or first letters as fallback
Widget pfpWidgetWithFallBack({
  required String? pfpUrl,
  required String? userDisplayName,
  double radiusValue = 25,
}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.teal.withOpacity(.6),
    ),
    child: CircleAvatar(
      radius: radiusValue,
      backgroundColor: Colors.teal.withOpacity(.6),
      child: ClipOval(
        child: pfpUrl != null && pfpUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: pfpUrl,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return fallBackWidget(
                      userName: userDisplayName ?? "Guest User");
                },
              )
            : fallBackWidget(userName: userDisplayName ?? "Guest User"),
      ),
    ),
  );
}

//* FallBack Widget for initials
Widget fallBackWidget({required String userName}) {
  // Split the name into parts (handle multiple spaces)
  List<String> nameParts =
      userName.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
  String displayText = "";

  // Handle cases where the name might have one or two parts
  int partsMaxCount = nameParts.length > 2 ? 2 : nameParts.length;
  for (int i = 0; i < partsMaxCount; i++) {
    displayText += nameParts[i][0].toUpperCase();
  }

  return Center(
    child: Text(
      displayText.isEmpty
          ? "GU"
          : displayText, // Default to "GU" if no initials
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
