import 'package:cloud_firestore/cloud_firestore.dart';

class TimeServices {
  // get the end date of the card and return formed left time
Map<String, dynamic> getFormattedLeftTimeForCard({required Timestamp endDate}) {
  // Convert Timestamp to DateTime
  DateTime endDateTime = endDate.toDate();
  DateTime now = DateTime.now();

  // Calculate time difference
  Duration timeLeft = endDateTime.difference(now);

  if (timeLeft.isNegative) {
    // Handle the case when the end date is in the past
    return {
      "years": 0,
      "months": 0,
      "days": 0,
      "hours": 0,
      "minutes": 0,
      "seconds": 0,
      "expired": true,
    };
  }

  // Breakdown timeLeft
  int days = timeLeft.inDays;
  int hours = timeLeft.inHours % 24;
  int minutes = timeLeft.inMinutes % 60;
  int seconds = timeLeft.inSeconds % 60;

  // Approximate months and years
  int years = days ~/ 365;
  int months = (days % 365) ~/ 30;
  days = (days % 365) % 30;

  return {
    "years": years,
    "months": months,
    "days": days,
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds,
    "expired": false,
  };
}

}
