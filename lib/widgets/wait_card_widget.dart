import 'package:countdown_mobile/screens/wait_card_page.dart/wait_card_page.dart';
import 'package:countdown_mobile/services/time_services.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:countdown_mobile/models/waitCard.dart';
import 'package:countdown_mobile/widgets/pfp_widget.dart';

class WaitCardWidget extends StatelessWidget {
  // The wait card data to be displayed
  final WaitCard waitCardData;

  const WaitCardWidget({super.key, required this.waitCardData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // navigate to the details page
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WaitCardDetailsPage(waitCardId: waitCardData.id))),
        child: Container(
          // Card container with subtle shadow and rounded corners
          decoration: _buildCardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expandable image section with waiting users overlay
              Expanded(child: _buildImageSection()),

              // Card content section with title, description, and owner profile
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Creates the container decoration with shadow and rounded corners
  BoxDecoration _buildCardDecoration(context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 15,
          offset: const Offset(2, 0),
        ),
      ],
    );
  }

  // Builds the image section with waiting users count overlay
  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(waitCardData.image),
        ),
      ),
      child: _buildWaitingUsersOverlay(),
    );
  }

  // Creates an overlay showing the number of waiting users
  Widget _buildWaitingUsersOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // waiting count
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 0.5),
                color: Colors.white.withOpacity(0.4),
              ),
              child: _buildWaitingUsersContent(),
            ),
          ),
        ),

        // wait timer widget
        _buildTimerWidget()
      ],
    );
  }

  // Build the Timer Widget for the wait card
  Widget _buildTimerWidget() {
    //* get service
    TimeServices timeServices = TimeServices();
    //* get time response from the service
    Map<String, dynamic> timeResponse = timeServices
        .getFormattedLeftTimeForCard(endDate: waitCardData.waitToDate);
    //* expired wait card widget
    if (timeResponse["expired"]) {
      return _expiredWaitCardIndicator();
    }
    return _waitIndicatorForWaitCard(leftTimeData: timeResponse);
  }

  // Build Wait Indicator for Card Widget
  Widget _waitIndicatorForWaitCard(
      {required Map<String, dynamic> leftTimeData}) {
    // Filter out invalid or skipped keys
    List<String> validKeys = leftTimeData.keys
        .where((key) =>
            key != "expired" && key != "seconds" && leftTimeData[key] != 0)
        .toList();

    // Determine the number of columns dynamically: max 3 but less if fewer items exist
    int crossAxisCount = validKeys.length > 3 ? 3 : validKeys.length;

    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          color: Theme.of(context).cardColor.withOpacity(.6),
        ),
        child: GridView(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent scrolling inside the grid
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                crossAxisCount, // Dynamically adjust the column count
            mainAxisSpacing: 8, // Spacing between rows
            crossAxisSpacing: 8, // Spacing between columns
            childAspectRatio: 1, // Aspect ratio for each grid item
          ),
          children: validKeys.map((key) {
            return Column(
              children: [
                //* Value container
                Expanded(
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Text(
                      "${leftTimeData[key]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
                //* Label below the value
                Text(
                  key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    });
  }

  // Build Expired wait card widget
  Widget _expiredWaitCardIndicator() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: .5, color: Theme.of(context).cardColor),
              color: Theme.of(context).cardColor.withOpacity(.6)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Ionicons.hourglass_outline,
              ),
              Text(
                "The Wait is Over",
                style: TextStyle(fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      );
    });
  }

  // Builds the content for waiting users (icon and count)
  Widget _buildWaitingUsersContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Ionicons.people_outline,
          size: 20,
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        Text(
          waitCardData.waitingUsersCount.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
        )
      ],
    );
  }

  // Builds the content section with title, description, and profile
  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          // Title and description
          Expanded(child: _buildTextContent()),

          // Owner profile picture
          _buildProfilePicture(),
        ],
      ),
    );
  }

  // Creates the text content (title and description)
  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          waitCardData.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          waitCardData.description,
          maxLines: 1,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.grey.withOpacity(0.7),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Builds the owner's profile picture
  Widget _buildProfilePicture() {
    return pfpWidgetWithFallBack(
      pfpUrl: waitCardData.ownerMetaData?.pfpUrl ?? "",
      userDisplayName: waitCardData.ownerMetaData?.userName ?? "",
      radiusValue: 14,
    );
  }
}
