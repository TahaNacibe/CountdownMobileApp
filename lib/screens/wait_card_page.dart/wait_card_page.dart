import 'package:countdown_mobile/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// Services and Models
import 'package:countdown_mobile/services/cards_services.dart';
import 'package:countdown_mobile/services/time_services.dart';
import 'package:countdown_mobile/models/waitCard.dart';

// Widgets
import 'package:countdown_mobile/widgets/pfp_widget.dart';
import 'package:countdown_mobile/screens/wait_card_page.dart/widgets/timer_widget.dart';
import 'package:countdown_mobile/animated/loading_handler.dart';

class WaitCardDetailsPage extends StatefulWidget {
  final String waitCardId;
  const WaitCardDetailsPage({required this.waitCardId, super.key});

  @override
  State<WaitCardDetailsPage> createState() => _WaitCardDetailsPageState();
}

class _WaitCardDetailsPageState extends State<WaitCardDetailsPage> {
  //* vars
  WaitCard? _waitCardData;
  bool _isLoading = true;

  //* instances
  final WaitCardsServices _waitCardsServices = WaitCardsServices();
  final AuthServices _authServices = AuthServices();
  final TimeServices _timeServices = TimeServices();

  //* init
  @override
  void initState() {
    super.initState();
    _fetchWaitCardDetails();
  }

  // get the card details
  Future<void> _fetchWaitCardDetails() async {
    final cardDetails = await _waitCardsServices.getSpecificWaitCardById(
      cardId: widget.waitCardId,
    );

    setState(() {
      _waitCardData = cardDetails;
      _isLoading = false;
    });
  }

  // check if user is IN the waitList
  bool isUserInWaitListForTheCard() {
    User? user = _authServices.getCurrentUser();
    if (user == null) return false;
    String userId = user.uid;
    return _waitCardData!.waitingUsers.contains(userId);
  }

  // handle wait state change for the user
  void handleTheWaitStateChange() {
    bool isInTheList = isUserInWaitListForTheCard();
    var userId = _authServices.getCurrentUser()!.uid;
    _waitCardsServices
        .updateUserWaitState(cardId: _waitCardData!.id, isAdd: !isInTheList)
        .then((_) {
      setState(() {
        if (isInTheList) {
          _waitCardData!.waitingUsers.remove(userId);
          _waitCardData!.waitingUsersCount -= 1;
        } else {
          _waitCardData!.waitingUsers.add(userId);
          _waitCardData!.waitingUsersCount += 1;
        }
      });
    });
  }

  // loading widget builder
  Widget _buildLoadingWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingAnimatedWidget(pageIcon: Ionicons.infinite_outline),
            const SizedBox(height: 16),
            Text(
              'Loading Wait Card...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.teal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

//* build the no card details received widget
  Widget _buildNoDataWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.alert_circle_outline,
              color: Colors.red.shade300,
              size: 100,
            ),
            const SizedBox(height: 16),
            Text(
              'No Wait Card Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  //* build the real data
  Widget _buildSectionContainer({required Widget child}) {
    return Builder(builder: (context) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: .2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.1),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
    });
  }

  Widget _buildPageContent() {
    if (_waitCardData == null) return _buildNoDataWidget();
    bool userWaitState = isUserInWaitListForTheCard();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Dynamic App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _waitCardData!.image,
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          // Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Wait Card Details
                _buildSectionContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _waitCardData!.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _waitCardData!.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        //* space
                        const SizedBox(height: 16),
                        //* wait list button
                        GestureDetector(
                          onTap: () => handleTheWaitStateChange(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: (userWaitState
                                        ? Colors.indigo
                                        : Colors.teal)
                                    .withOpacity(.8)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    userWaitState
                                        ? Ionicons.remove_circle_outline
                                        : Ionicons.add_circle_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  userWaitState
                                      ? "Leave The wait"
                                      : 'Join The Wait',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Creator Info
                _buildSectionContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        pfpWidgetWithFallBack(
                          radiusValue: 30,
                          pfpUrl: _waitCardData!.ownerMetaData!.pfpUrl,
                          userDisplayName:
                              _waitCardData!.ownerMetaData!.userName,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Created by',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                _waitCardData!.ownerMetaData!.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Ionicons.ribbon_outline,
                          color: Colors.teal,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),

                // Timer Widget
                _buildSectionContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Ionicons.time_outline,
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Wait Timer',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _timeServices.getFormattedLeftTimeForCard(
                                endDate: _waitCardData!.waitToDate)["expired"]
                            ? _buildSectionContainer(
                                child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                child: Row(
                                  children: [
                                    Icon(Ionicons.hourglass_outline),
                                    Text("Already Ended")
                                  ],
                                ),
                              ))
                            : TimerWidget(
                                waitCard: _waitCardData!,
                                timeServices: _timeServices,
                              ),
                      ],
                    ),
                  ),
                ),

                // Waiting Users
                _buildSectionContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Ionicons.people_outline,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Waiting Users',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              '${_waitCardData!.waitingUsersCount} Total',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 60,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ..._waitCardData!.waitingUsersMetaData!
                                  .take(3)
                                  .map((user) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: pfpWidgetWithFallBack(
                                          pfpUrl: user.pfpUrl,
                                          userDisplayName: user.userName,
                                        ),
                                      )),
                              if (_waitCardData!.waitingUsersCount > 3)
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.teal.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${_waitCardData!.waitingUsersCount - 3}',
                                      style: const TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _buildLoadingWidget() : _buildPageContent();
  }
}
