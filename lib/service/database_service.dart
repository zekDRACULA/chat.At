import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      "friends": [],
      "recieved_Requests": [],
      "sent_Requests": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getUserData() async {
    return userCollection.doc(uid).snapshots();
  }

  // get user chats
  Future<List<dynamic>> getUserChats() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      Map<String, dynamic>? userData =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        List? chatsData = userData['chats'] as List<dynamic>?;
        return chatsData ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  getUserFriends() async {
    return userCollection.doc(uid).snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserRequests() async {
    return FirebaseFirestore.instance
        .collection('recieved_Requests')
        .snapshots();
  }

  // Get chat data for a specific chat ID

  // Send a message to a chat room
}
