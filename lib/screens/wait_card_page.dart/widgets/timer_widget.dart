import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// Models and Services
import 'package:countdown_mobile/models/waitCard.dart';
import 'package:countdown_mobile/services/time_services.dart';

class TimerWidget extends StatefulWidget {
  final WaitCard waitCard;
  final TimeServices timeServices;

  const TimerWidget({
    required this.waitCard,
    required this.timeServices,
    super.key,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Map<String, dynamic> _timeResponse;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Start a timer that updates every second
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  // Update the remaining time from the TimeServices
  void _updateTime() {
    final timeResponse = widget.timeServices
        .getFormattedLeftTimeForCard(endDate: widget.waitCard.waitToDate);

    // If the wait card has expired, stop updating
    if (timeResponse["expired"]) {
      _timer.cancel();
    }

    setState(() {
      _timeResponse = timeResponse;
    });
  }

  // Expired indicator widget
  Widget _buildExpiredWaitCardIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade100,
            Colors.green.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Ionicons.checkmark_circle,
            color: Colors.green.shade700,
            size: 32,
          ),
          const SizedBox(width: 12),
          Text(
            "Wait Completed",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  // Modern Wait indicator
  Widget _buildModernWaitIndicator(
      Map<String, dynamic> leftTimeData, BuildContext context) {
    // Filter out invalid or skipped keys
    List<String> validKeys =
        leftTimeData.keys.where((key) => key != "expired").toList();

    // Determine the number of columns dynamically: max 3 but less if fewer items exist
    int crossAxisCount = validKeys.length > 3 ? 3 : validKeys.length;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: validKeys.length,
      itemBuilder: (context, index) {
        String key = validKeys[index];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal.withOpacity(0.1),
                Colors.teal.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.teal.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  "${leftTimeData[key]}",
                  key: ValueKey(leftTimeData[
                      key]), // Key for AnimatedSwitcher to identify changes
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                key,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.teal.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If the wait card is expired, show the expired indicator
    if (_timeResponse["expired"]) {
      return _buildExpiredWaitCardIndicator(context);
    }

    // Otherwise, show the modern wait indicator with animations
    return _buildModernWaitIndicator(_timeResponse, context);
  }
}
