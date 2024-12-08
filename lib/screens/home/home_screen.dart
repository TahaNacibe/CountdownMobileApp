import 'package:countdown_mobile/auth/auth_services.dart';
import 'package:countdown_mobile/providers/network_provider.dart';
import 'package:countdown_mobile/screens/home/pages/created_cards.dart';
import 'package:countdown_mobile/screens/home/pages/serach_page.dart';
import 'package:countdown_mobile/screens/home/pages/settings_section.dart';
import 'package:countdown_mobile/screens/home/pages/trending_cards.dart';
import 'package:countdown_mobile/screens/no_internat_page.dart';
import 'package:countdown_mobile/widgets/pfp_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //* consts
  static const double tabBarHeight = 45;
  static const int tabBarSlots = 5;

  //* vars
  User? userDetails;
  late TabController tabController;
  int activeTabIndex = 0;

  //* instances
  NetworkProvider networkProvider = NetworkProvider();

  // tabs list
  List<Map<String, dynamic>> tabsData = [
    {
      "icon": Ionicons.home_outline,
      "label": "Home",
      "page": const CreatedByMeSection(
        pageIcon: Ionicons.home_outline,
      )
    },
    {
      "icon": Ionicons.flame_outline,
      "label": "Popular",
      "page": const TrendingCardsSection(
        pageIcon: Ionicons.flame_outline,
      )
    },
    {
      "icon": Ionicons.search_outline,
      "label": "Search",
      "page": const SearchPage(
        pageIcon: Ionicons.search_outline,
      )
    },
    {
      "icon": Ionicons.bookmark_outline,
      "label": "Bookmarks",
      "page": const TrendingCardsSection(pageIcon: Ionicons.bookmark_outline)
    },
    {
      "icon": Ionicons.library_outline,
      "label": "Library",
      "page": const SettingsSection()
    },
  ];

// functions
  List<Tab> tabBraItemsList() {
    return tabsData
        .map((elem) => Tab(
              child: Icon(size: 25, elem["icon"]),
            ))
        .toList();
  }

  //* instances
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    //* get current user details
    userDetails = authServices.getCurrentUser();
    tabController = TabController(length: tabBarSlots, vsync: this);
    // get the active tab index for the title
    tabController.addListener(() {
      setState(() {
        activeTabIndex = tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // dispose of the controller on need
    tabController.dispose();
    super.dispose();
  }

  //* tab app bar
  PreferredSizeWidget tabAppBarWidget() {
    return AppBar(
      //* title (dynamic based on active tab)
      title: Text(tabsData[activeTabIndex]["label"]),

      //* pfp widget
      actions: [
        //* fall back will handle the null state
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: pfpWidgetWithFallBack(
              pfpUrl: userDetails!.photoURL,
              userDisplayName: userDetails!.displayName),
        )
      ],

      //* bottom space for tab bar
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(tabBarHeight),
          child: TabBar(
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            dividerColor: Colors.grey.withOpacity(.3),
            tabs: tabBraItemsList(),
            controller: tabController,
          )),
    );
  }

  //* body widget
  Widget mainBodyWidget() {
    return StreamBuilder(
        stream: networkProvider.isUserConnectedToNetwork().asStream(),
        builder: (context, snapShot) {
          return TabBarView(
              controller: tabController,
              children: tabsData.map((tab) {
                Widget activePageContent =
                    snapShot.data ?? false ? tab["page"] : NoInternetPage(icon: tab["icon"],);
                return activePageContent;
              }).toList());
        });
    //* check connectivity state
    // bool isUserConnected = true;
    // networkProvider.isUserConnectedToNetwork().then((result) => setState(() {
    //       isUserConnected = result;
    //     }));
    // return TabBarView(
    //     controller: tabController,
    //     children: tabsData.map((tab) {
    //       Widget activePageContent =
    //           isUserConnected ? tab["page"] : Container();
    //       return activePageContent;
    //     }).toList());
  }

  @override
  Widget build(BuildContext context) {
    //* no user case build
    if (userDetails == null) {
      return Container();
    }

    //* normal build
    return Scaffold(
      appBar: tabAppBarWidget(),
      body: mainBodyWidget(),
    );
  }
}
