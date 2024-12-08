import 'package:countdown_mobile/auth/auth_services.dart';
import 'package:countdown_mobile/screens/home/home_screen.dart';
import 'package:countdown_mobile/screens/welcomeScreen/welcome_screen.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final ThemeMode activeTheme;
  const LoadingScreen({required this.activeTheme, super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final AuthServices _authServices = AuthServices();
  @override
  void initState() {
    bool userIsSignedIn = _authServices.isUserSignedIn();
    Future.delayed(const Duration(seconds: 1), () {
      if (userIsSignedIn) {
        // if user is signed in take him to home
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        // if user is not signed in take him to welcome page
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(widget.activeTheme == ThemeMode.light
        ? "assets/icons/emptyapp.png" 
        : "assets/icons/appWhite.png"),
      ),
    );
  }
}
