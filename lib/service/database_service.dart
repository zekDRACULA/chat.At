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
  Future<List<String>> getUserChats() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot chatSnapshot =
          await chatCollection.where('participants', arrayContains: uid).get();

      List<String> chatIds = chatSnapshot.docs.map((doc) => doc.id).toList();
      return chatIds;
    } catch (e) {
      print("Error getting user chats: $e");
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

  Future<String> createChatRoom(List<String> participants) async {
    // Generate a unique chat ID, for example, by sorting and concatenating participant UIDs
    participants.sort();
    final chatId = participants.join('_');

    // Create a new chat document with the list of participants
    await chatCollection.doc(chatId).set({
      "participants": participants,
      "created_at": FieldValue.serverTimestamp(), // Add a timestamp
    });

    return chatId; // Return the chat ID
  }

  // Get chat data for a specific chat ID
  Stream<DocumentSnapshot<Map<String, dynamic>>> getChatData(String chatId) {
    return chatCollection.doc(chatId).snapshots().map(
          (snapshot) => snapshot as DocumentSnapshot<Map<String, dynamic>>,
        );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(String chatId) {
    // Reference the chat messages subcollection for the specified chat ID
    final messagesCollection =
        chatCollection.doc(chatId).collection('messages');

    // Create a query to order messages by timestamp
    final messagesQuery =
        messagesCollection.orderBy('timestamp', descending: true);

    // Return a stream of query snapshots to listen for new messages
    return messagesQuery.snapshots();
  }

  // Send a message to a chat room
  Future<void> sendMessage(
      String chatId, String senderUid, String messageText) async {
    // Add a new message document to the chat's messages subcollection
    await chatCollection.doc(chatId).collection('messages').add({
      "sender": senderUid,
      "text": messageText,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future getChats() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      Map<String, dynamic>? userData =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData['chats'] != null) {
        List<dynamic> chatsData = userData['chats'] as List<dynamic>;
        return chatsData ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
