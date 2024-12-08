import 'package:countdown_mobile/animated/loading_handler.dart';
import 'package:countdown_mobile/dialogs/toast.dart';
import 'package:countdown_mobile/models/waitCard.dart';
import 'package:countdown_mobile/services/cards_services.dart';
import 'package:countdown_mobile/widgets/empty_list_widget.dart';
import 'package:countdown_mobile/widgets/wait_card_widget.dart';
import 'package:flutter/material.dart';

class CreatedByMeSection extends StatefulWidget {
  final IconData pageIcon;
  const CreatedByMeSection({required this.pageIcon, super.key});

  @override
  State<CreatedByMeSection> createState() => _CreatedByMeSectionState();
}

class _CreatedByMeSectionState extends State<CreatedByMeSection> {
  //* consts
  static const double itemsSpacingValue = 8;

  //* vars
  bool isCardsLoading = true;
  int crossAxisCount = 2;
  List<WaitCard>? createdByUserCards = [];

  //* instances
  WaitCardsServices waitCardsServices = WaitCardsServices();

  void getPageData() {
    isCardsLoading = true;
    // get the card list from firebase
    waitCardsServices.getWaitCardsCreatedByUser().then((cardsResult) {
      setState(() {
        if (cardsResult != null) {
          createdByUserCards = cardsResult;
        } else {
          showCustomSnackBar(context,
              "Something went wrong getting the cards you created (0-0?)");
        }
        isCardsLoading = false;
      });
    });
  }

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // loading widget
    if (isCardsLoading) {
      return Center(
        child: loadingAnimatedWidget(pageIcon: widget.pageIcon),
      );
    }

    //* empty list display
    if (createdByUserCards == null || createdByUserCards!.isEmpty) {
      return emptyListResult(
        message: "We couldn't find any card here?",
        icon: widget.pageIcon,
        action: getPageData,
      );
    }

    //* ui tree
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: itemsSpacingValue),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //* control bar for items

            //* items builder
            Padding(
              padding: const EdgeInsets.symmetric(vertical: itemsSpacingValue),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: createdByUserCards!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: itemsSpacingValue,
                      childAspectRatio: .5,
                      crossAxisSpacing: itemsSpacingValue),
                  itemBuilder: (context, index) {
                    //* the specific card item
                    WaitCard card = createdByUserCards![index];
                    //* ui for items
                    return WaitCardWidget(waitCardData: card);
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}
