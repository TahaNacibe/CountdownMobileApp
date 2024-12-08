import 'package:countdown_mobile/animated/loading_handler.dart';
import 'package:countdown_mobile/dialogs/toast.dart';
import 'package:countdown_mobile/models/waitCard.dart';
import 'package:countdown_mobile/services/cards_services.dart';
import 'package:countdown_mobile/widgets/wait_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchPage extends StatefulWidget {
  final IconData pageIcon;
  const SearchPage({required this.pageIcon, super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //* consts
  static const double itemsSpacingValue = 8;
  // vars
  bool isLoading = false;
  bool isSearched = false;
  int crossAxisCount = 2;
  List<WaitCard> resultList = [];

  // controllers
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  //* instances
  WaitCardsServices waitCardsServices = WaitCardsServices();

  searchForCards(String value) async {
    setState(() {
      isSearched = false;
      isLoading = true;
    });

    List<WaitCard>? searchResult =
        await waitCardsServices.getSearchResultByTitle(searchTerm: value);

    setState(() {
      if (searchResult != null) {
        resultList = searchResult;
        //* in case the list is empty
        if (searchResult.isEmpty) {
          showCustomSnackBar(
              context, "we couldn't find anything, sorry (¨_¨!)");
        }
      } else {
        //* handle error
        showCustomSnackBar(
            context, "something went wrong while searching (u_u?)");
        isSearched = true;
      }
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  PreferredSizeWidget searchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(65),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextField(
          focusNode: _searchFocusNode,
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(widget.pageIcon),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.teal.shade400,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) => searchForCards(value),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  //* place holder in state of no search
  Widget noResultPlaceHolder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            "assets/images/search.svg",
            width: 200,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
            child: Text(
              textAlign: TextAlign.center,
              isSearched ? "Nothing To show" : "Try Typing something to search",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          )
        ],
      ),
    );
  }

  Widget searchResultBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: itemsSpacingValue),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //* items builder
            Padding(
              padding: const EdgeInsets.symmetric(vertical: itemsSpacingValue),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resultList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: itemsSpacingValue,
                      childAspectRatio: .5,
                      crossAxisSpacing: itemsSpacingValue),
                  itemBuilder: (context, index) {
                    //* the specific card item
                    WaitCard card = resultList[index];
                    //* ui for items
                    return WaitCardWidget(waitCardData: card);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyWidgetBuilder() {
    return isLoading
        ? Center(child: loadingAnimatedWidget(pageIcon: widget.pageIcon))
        : resultList.isEmpty
            ? noResultPlaceHolder()
            : searchResultBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the text field when tapping outside
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: searchBar(),
          body: bodyWidgetBuilder(),
        ),
      ),
    );
  }
}
