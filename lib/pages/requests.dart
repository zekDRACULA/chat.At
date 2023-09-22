import 'package:chatapp/pages/auth/friend_list.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  List<String> recievedRequests = [];
  String? currentUserUid;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final userDocument =
        FirebaseFirestore.instance.collection('users').doc(currentUserUid);
    //getting data from recieved_Requests list

    // Assuming 'recieved_Requests' is an array field in the user's document
    userDocument.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          // this is a very important part as this takes recievedRequests as
          //list in my older tries even i dont know in what format i was converting that shit
          recievedRequests =
              List<String>.from(docSnapshot['recieved_Requests']);
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(69),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Requests",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Borel',
              fontSize: 30,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          recievedRequestList(currentUserUid),
          Positioned(
            bottom: 25,
            right: 10,
            child: RawMaterialButton(
              onPressed: () {},
              shape: const CircleBorder(),
              fillColor: Colors.black,
              child: const Icon(
                Icons.notification_add,
                color: Colors.white,
                size: 55,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Method to show recieved requests
  recievedRequestList(currentUserUid) {
    if (recievedRequests.isEmpty) {
      return noRequestsWidget();
    }

    return ListView.builder(
      itemCount: recievedRequests.length,
      itemBuilder: (context, index) {
        final senderUid = recievedRequests[index];
        return FutureBuilder(
          future: getUserData(senderUid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final senderData = snapshot.data as Map<String, dynamic>;
              final senderName = senderData['username'] as String;
              final senderEmail = senderData['email'] as String;

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.account_circle_sharp,
                    color: Colors.black,
                    size: 60,
                  ),
                  title: Text(
                    senderName,
                    style: const TextStyle(
                      fontFamily: "Borel",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    senderEmail,
                    style: const TextStyle(
                      fontFamily: "Borel",
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 25,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.account_circle_sharp,
                                    size: 150,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    senderName,
                                    style: const TextStyle(
                                        fontFamily: "Borel",
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(senderEmail,
                                      style: const TextStyle(
                                          fontFamily: 'Borel',
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          AcceptFriendRequest(
                                              currentUserUid, senderUid);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black),
                                        child: const Text(
                                          "Accept",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          rejectFriendRequest(
                                              currentUserUid, senderUid);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black),
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                          );
                        });
                  },
                ),
              );
            }
          },
        );
      },
    );
  }

//Accept Request

// acccessing currentusers recievedRequests
//to move it to friends list and delete from recievedRequests
//and doing same for sender oppositely(if its a word)
  void AcceptFriendRequest(String currentUserUid, String senderUid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'friends': FieldValue.arrayUnion([senderUid])
    });
    print("Senderuid Added to friend list successfully!!!!");

    await FirebaseFirestore.instance.collection('users').doc(senderUid).update({
      'friends': FieldValue.arrayUnion([currentUserUid])
    });
    print("currentUserUid Added to friend list successfully!!!!");
    await FirebaseFirestore.instance.collection('users').doc(senderUid).update({
      'sent_Requests': FieldValue.arrayRemove([currentUserUid])
    });
    print("currentUserUid removed from  sent_Requests successfully!!!!");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'recieved_Requests': FieldValue.arrayRemove([senderUid])
    });
    print("Senderuid removed from recieved_Requests  successfully!!!!");
  }

//Rejecting a friend requests

  void rejectFriendRequest(String currentUserUid, String senderUid) async {
    await FirebaseFirestore.instance.collection('users').doc(senderUid).update({
      'sent_Requests': FieldValue.arrayRemove([currentUserUid])
    });
    print("currentUserUid removed from recieved_Requests  successfully!!!!");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'recieved_Requests': FieldValue.arrayRemove([senderUid])
    });
    print("Senderuid removed from recieved_Requests  successfully!!!!");
  }

//extracting user data
  Future<Map<String, dynamic>> getUserData(String uid) async {
    final senderDocument =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final senderSnapshot = await senderDocument.get();
    if (senderSnapshot.exists) {
      return senderSnapshot.data() as Map<String, dynamic>;
    } else {
      return {}; // Return an empty map if sender data is not found
    }
  }

  noRequestsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "No Request for now ^.^;",
              style: TextStyle(
                fontFamily: 'Borel',
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        ],
      ),
    );
  }
}
