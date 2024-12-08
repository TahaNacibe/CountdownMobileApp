import 'package:countdown_mobile/auth/auth_services.dart';
import 'package:countdown_mobile/dialogs/toast.dart';
import 'package:countdown_mobile/models/welcome_section.dart';
import 'package:countdown_mobile/providers/theme_provider.dart';
import 'package:countdown_mobile/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WelcomeScreenSection extends StatefulWidget {
  final bool isPageActive;
  final int pageIndex;
  final WelcomeSectionData screenDetails;
  const WelcomeScreenSection(
      {required this.isPageActive,
      required this.screenDetails,
      required this.pageIndex,
      super.key});

  @override
  State<WelcomeScreenSection> createState() => _WelcomeScreenSectionState();
}

class _WelcomeScreenSectionState extends State<WelcomeScreenSection>
    with SingleTickerProviderStateMixin {
  // controllers
  late AnimationController animationController;
  //* instances
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    animationController = AnimationController(
      duration: const Duration(seconds: 1), // Duration for one jump
      vsync: this,
    )..repeat(
        reverse:
            true); // Repeat the animation with reverse to make it jump up and down
  }

  @override
  void dispose() {
    animationController
        .dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  // handle sign in process
  void handleSignInProcess() async {
    var response = await authServices.signInWithGoogle();
    if (response != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      showCustomSnackBar(
          context, "Couldn't sign in! try checking your network connection");
    }
  }

  //* get the needed button bused on the page
  Widget bottomPageButtonWidget(pageIndex) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // if las page show sign in option
    if (pageIndex == 2) {
      return // Login Button
          Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () => handleSignInProcess(),
                child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: .5,
                            color: Theme.of(context).iconTheme.color!)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          // load suitable icon based on active theme
                          child: Image.asset(
                            themeProvider.themeMode == ThemeMode.light
                                ? "assets/icons/google_black.png"
                                : "assets/icons/google_white.png",
                            scale: 4,
                          ),
                        ),
                        const Text(
                          "Continue with Google",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    )),
              ));
    } else {
      // show arrow down to show the scroll direction
      return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            // Using a curve to make the jump more natural
            double offset = 20 *
                (1 -
                    animationController
                        .value); // The value varies between 0 and 1
            return Transform.translate(
              offset: Offset(0, -offset), // Moves the icon up and down
              child: child,
            );
          },
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 35,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),
          // Rich Text Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedOpacity(
              opacity: widget.isPageActive ? 1 : 0,
              duration: const Duration(seconds: 1),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                  children: [
                    TextSpan(text: widget.screenDetails.preSpecialText),
                    TextSpan(
                      text: widget.screenDetails.specialText,
                      style: const TextStyle(color: Colors.teal),
                    ),
                    TextSpan(text: widget.screenDetails.afterSpecialText),
                    TextSpan(
                      text: widget.screenDetails.subText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // SVG Illustration
          AnimatedOpacity(
            opacity: widget.isPageActive ? 1 : 0,
            duration: const Duration(milliseconds: 1300),
            child: SvgPicture.asset(
              widget.screenDetails.ilu,
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 40),

          // bottom Button
          bottomPageButtonWidget(widget.pageIndex)
        ],
      ),
    );
  }
}
