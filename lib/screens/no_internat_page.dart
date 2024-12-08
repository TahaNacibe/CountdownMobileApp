import 'package:flutter/material.dart';

class NoInternetPage extends StatefulWidget {
  final IconData icon;
  const NoInternetPage({required this.icon, super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  //* const
  final double iconSize = 35;
  final double fontSize = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: iconSize,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontSize),
                  "Can't connect!\nNo Network Available"),
            )
          ],
        ),
      ),
    );
  }
}
