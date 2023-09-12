import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chats");
  final CollectionReference friendsCollection =
      FirebaseFirestore.instance.collection("friends");
  //updating the userdata
  Future savingUserData(String username, String email) async {
    return await userCollection.doc(uid).set({
      "username": username,
      "email": email,
      "chats": [],
      "friends": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user chats
  getUserChats() async {
    return userCollection.doc(uid).snapshots();
  }

  getUserFriends() async {
    return userCollection.doc(uid).snapshots();
  }
}
