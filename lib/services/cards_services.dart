import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_mobile/auth/auth_services.dart';
import 'package:countdown_mobile/models/waitCard.dart';
import 'package:countdown_mobile/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaitCardsServices {
  //* get created by me wait cards list
  Future<List<WaitCard>?> getWaitCardsCreatedByUser() async {
    //* get user id
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    // return null in case no user signed in
    if (firebaseAuth.currentUser == null) return null;

    //* user id
    String userId = firebaseAuth.currentUser!.uid;
    try {
      // get references for the user cards
      var q = firebaseFireStore
          .collection("items")
          .where("ownerId", isEqualTo: userId);
      // get the cards by the ref
      var querySnapshot = await q.get();
      // get the docs
      var docsList = querySnapshot.docs;
      // turn the map of each card into a object
      List<WaitCard> userWaitCards = docsList
          .map((doc) => WaitCard.fromMap({
                ...doc.data(),
                "ownerMetaData": UserModel(
                    userName: firebaseAuth.currentUser!.displayName!,
                    pfpUrl: firebaseAuth.currentUser!.photoURL)
              }))
          .toList();
      return userWaitCards;
    } catch (e) {
      throw "error accrues when getting user cards ${e.toString()}";
    }
  }

  //* get single card data with full details
  Future<WaitCard?> getSpecificWaitCardById({required String cardId}) async {
    //* get instances
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    try {
      // Fetch the card snapshot
      var cardSnapShot =
          await firebaseFirestore.collection("items").doc(cardId).get();
      Map<String, dynamic>? cardData = cardSnapShot.data();

      // Exit if the card doesn't exist
      if (cardData == null) return null;

      // Extract `ownerId` and the list of `waitingUsers` (up to 3)
      String ownerId = cardData["ownerId"];
      List<String> waitingListIds = List<String>.from(cardData["waitingUsers"])
          .take(3) // Take only the first 3 users
          .toList();

      // Fetch owner's metadata
      var ownerMetaDataSnapShot =
          await firebaseFirestore.collection("users").doc(ownerId).get();
      Map<String, dynamic>? ownerMetaData = ownerMetaDataSnapShot.data();

      // Fetch metadata of waiting users
      List<Map<String, dynamic>> waitingUsersData = [];
      if (waitingListIds.isNotEmpty) {
        var waitingUsersSnapShot = await firebaseFirestore
            .collection("users")
            .where("uid", whereIn: waitingListIds)
            .get();

        waitingUsersData =
            waitingUsersSnapShot.docs.map((doc) => doc.data()).toList();
      }

      WaitCard waitCard = WaitCard.fromMap({
        ...cardData,
        "ownerMetaData": UserModel(
            userName: ownerMetaData!["displayName"],
            pfpUrl: ownerMetaData["photoURL"]),
        "waitingUsersMetaData": waitingUsersData
            .map((user) => UserModel(
                userName: user["displayName"], pfpUrl: user["photoURL"]))
            .toList()
      });

      return waitCard;
    } catch (e) {
      throw "error getting the $cardId card data ${e.toString()}";
    }
  }

  Future<void> updateUserWaitState(
      {required String cardId, required bool isAdd}) async {
    //* get instances
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var userId = firebaseAuth.currentUser!.uid;
    try {
      var cardSnap =
          await firebaseFirestore.collection("items").doc(cardId).get();
      if (!cardSnap.exists) {
        return;
      }
      var cardRef = firebaseFirestore.collection("items").doc(cardId);
      if (isAdd) {
        // in case it add
        await cardRef.update({
          "waitingUsers": FieldValue.arrayUnion([userId]),
          "waitingUsersCount": FieldValue.increment(1)
        });
      } else {
        // in case it's remove
        await cardRef.update({
          "waitingUsers": FieldValue.arrayRemove([userId]),
          "waitingUsersCount": FieldValue.increment(-1)
        });
      }
    } catch (e) {
      throw "error happened while handling change in wait state ${e.toString()}";
    }
  }

  //* get trending wait cards based on their wait count
  Future<List<WaitCard>?> getTrendingWaitCards() async {
    //* get user id
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    try {
      // get references for the user cards
      var q = firebaseFireStore
          .collection("items")
          .orderBy("waitingUsersCount", descending: true);
      // get the cards by the ref
      var querySnapshot = await q.get();
      // get the docs
      var docsList = querySnapshot.docs;
      List<dynamic> usersIds = docsList.map((doc) {
        Map<String, dynamic> cardData = doc.data();
        return cardData["ownerId"];
      }).toList();

      //* get users data
      var qUsers =
          firebaseFireStore.collection("users").where("uid", whereIn: usersIds);
      var qUsersSnapshot = await qUsers.get();
      List<Map<String, dynamic>> qUsersData =
          qUsersSnapshot.docs.map((doc) => doc.data()).toList();

      // turn the map of each card into a object
      List<WaitCard> popularWaitCards = docsList.map((doc) {
        Map<String, dynamic> docData = doc.data();
        Map<String, dynamic> userDoc =
            qUsersData.firstWhere((e) => e["uid"] == docData["ownerId"]);
        return WaitCard.fromMap({
          ...docData,
          "ownerMetaData": UserModel(
              userName: userDoc["displayName"], pfpUrl: userDoc["photoURL"])
        });
      }).toList();
      return popularWaitCards;
    } catch (e) {
      throw "error accrues when getting Popular wait cards ${e.toString()}";
    }
  }

  //* get cards the user is joined to the wait list in
  Future<List<WaitCard>?> getUserJoinedToCards() async {
    //* get user id
    AuthServices authServices = AuthServices();
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    User? user = authServices.getCurrentUser();
    if (user == null) return null;
    try {
      // get references for the user cards
      var q = firebaseFireStore
          .collection("items")
          .where("waitingUsers", arrayContains: user.uid);
      // get the cards by the ref
      var querySnapshot = await q.get();
      // get the docs
      var docsList = querySnapshot.docs;
      List<dynamic> usersIds = docsList.map((doc) {
        Map<String, dynamic> cardData = doc.data();
        return cardData["ownerId"];
      }).toList();

      //* get users data
      var qUsers =
          firebaseFireStore.collection("users").where("uid", whereIn: usersIds);
      var qUsersSnapshot = await qUsers.get();
      List<Map<String, dynamic>> qUsersData =
          qUsersSnapshot.docs.map((doc) => doc.data()).toList();

      // turn the map of each card into a object
      List<WaitCard> joinedToWaitCards = docsList.map((doc) {
        Map<String, dynamic> docData = doc.data();
        Map<String, dynamic> userDoc =
            qUsersData.firstWhere((e) => e["uid"] == docData["ownerId"]);
        return WaitCard.fromMap({
          ...docData,
          "ownerMetaData": UserModel(
              userName: userDoc["displayName"], pfpUrl: userDoc["photoURL"])
        });
      }).toList();
      return joinedToWaitCards;
    } catch (e) {
      return null;
    }
  }

  //* get cards by the title search
  Future<List<WaitCard>?> getSearchResultByTitle(
      {required String searchTerm}) async {
    //* get search values
    List<String> searchTerms = searchTerm.split(' ');
    //* get user id
    AuthServices authServices = AuthServices();
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    User? user = authServices.getCurrentUser();
    if (user == null) return null;
    try {
      // get references for the user cards
      var q = firebaseFireStore
          .collection("items")
          .where("titleKeywords", arrayContainsAny: searchTerms);
      // get the cards by the ref
      var querySnapshot = await q.get();
      // get the docs
      var docsList = querySnapshot.docs;

      if (docsList.isEmpty) {
        return [];
      }

      List<dynamic> usersIds = docsList.map((doc) {
        Map<String, dynamic> cardData = doc.data();
        return cardData["ownerId"];
      }).toList();

      //* get users data
      var qUsers =
          firebaseFireStore.collection("users").where("uid", whereIn: usersIds);
      var qUsersSnapshot = await qUsers.get();
      List<Map<String, dynamic>> qUsersData =
          qUsersSnapshot.docs.map((doc) => doc.data()).toList();

      // turn the map of each card into a object
      List<WaitCard> searchedForCards = docsList.map((doc) {
        Map<String, dynamic> docData = doc.data();
        Map<String, dynamic> userDoc =
            qUsersData.firstWhere((e) => e["uid"] == docData["ownerId"]);
        return WaitCard.fromMap({
          ...docData,
          "ownerMetaData": UserModel(
              userName: userDoc["displayName"], pfpUrl: userDoc["photoURL"])
        });
      }).toList();
      return searchedForCards;
    } catch (e) {
      throw "error accrues when getting Joined To wait cards ${e.toString()}";
    }
  }
}
