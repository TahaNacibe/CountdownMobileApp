import 'package:countdown_mobile/models/welcome_section.dart';
import 'package:countdown_mobile/screens/welcomeScreen/widgets/welcome_page_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //* vars
  int currentActivePage = 0;
  List<WelcomeSectionData> welcomeScreenPages = [
    // first page informations
    WelcomeSectionData(
        preSpecialText: "Wait For ",
        specialText: "Important ",
        afterSpecialText: "Events\n",
        subText: "Debuts, Announcements, Aired and More",
        ilu: "assets/images/wait.svg"),

    // second page section
    WelcomeSectionData(
        preSpecialText: "With Many Others Who ",
        specialText: "Share ",
        afterSpecialText: "The Same\n",
        subText: "Interests and Hobbies...",
        ilu: "assets/images/together.svg"),

    // third page section
    WelcomeSectionData(
        preSpecialText: "Through All Your Devices ",
        specialText: "Mobile, ",
        afterSpecialText: "Pc And Tablet\n",
        subText: "Access everyWhere and at anyTime",
        ilu: "assets/images/devices.svg"),
  ];
  @override
  Widget build(BuildContext context) {
    // Set the status bar style and make it transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    //* controllers
    final PageController welcomePageController = PageController();

    //* ui tree
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          itemCount: welcomeScreenPages.length,
          controller: welcomePageController,
          onPageChanged: (pageIndex) {
            setState(() {
              currentActivePage = pageIndex;
            });
          },
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return WelcomeScreenSection(
              isPageActive: currentActivePage == index,
              pageIndex: index,
              screenDetails: welcomeScreenPages[index],
            );
          },
        ),
      ),
    );
  }
}
