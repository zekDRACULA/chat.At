//un updated user_search
import 'dart:core';

import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  String? _searchQuery = "";
  String SenderUserName = "";
  String SenderUserEmail = "";
  String RecieverUid = "";
  String RequestButton_text = "Send Request";

  User CurrentUser = FirebaseAuth.instance.currentUser!;

  final TextEditingController _searchController = TextEditingController();

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
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
              "Chat@",
              textAlign: TextAlign.center,
              style: TextStyle(
                //fontFamily: 'Borel',
                fontSize: 30,
                fontWeight: FontWeight.w200,
              ),
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: textInputDecoration.copyWith(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  onPressed: () {
                    //_searchQuery!.clear();
                  },
                  icon: const Icon(Icons.clear),
                  color: Colors.black,
                ),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: getDataRealTime(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var documents = snapshot.data!.docs;
              // Filter data based on searchQuery
              var filteredData = documents.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                String title = data['username'].toString().toLowerCase();

                return title.contains(_searchQuery!.toLowerCase()) &&
                    data['uid'] != CurrentUser.uid;
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    // data =
                    //  filteredData[index].data() as Map<String, dynamic>;
                    // String recievers_uid = data["uid"];
                    var data =
                        filteredData[index].data() as Map<String, dynamic>;
                    String recievers_uid = data["uid"];
                    return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: ListTile(
                            leading: const Icon(
                              Icons.account_circle_sharp,
                              color: Colors.black,
                              size: 60,
                            ),
                            title: Text(
                              data["username"],
                              style: const TextStyle(
                                  fontFamily: "Borel",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              data["email"],
                              style: const TextStyle(
                                  fontFamily: "Borel",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
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
                                            data["username"],
                                            style: const TextStyle(
                                                fontFamily: "Borel",
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),
                                          Text(
                                            data["email"],
                                            style: const TextStyle(
                                                fontFamily: "Borel",
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _changeButtonText();
                                              sendFriendRequest(CurrentUser.uid,
                                                  recievers_uid);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              RequestButton_text,
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _changeButtonText() {
    setState(() {
      // Change the button text when pressed
      RequestButton_text = 'Sent!';
    });
  }

  void sendFriendRequest(String CurrentUserUid, String recievers_uid) async {
    try {
      // Update recievers receivedRequests field to include senders UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recievers_uid)
          .update({
        'recieved_Requests': FieldValue.arrayUnion([CurrentUserUid]),
      });
      print('Friend request sent successfully.');
      // Update senders sent requests field to include recievers UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CurrentUserUid)
          .update({
        'sent_Requests': FieldValue.arrayUnion([recievers_uid])
      });
      print('Friend sent erquest added successfully.');
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  Stream<QuerySnapshot> getDataRealTime() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }
}
