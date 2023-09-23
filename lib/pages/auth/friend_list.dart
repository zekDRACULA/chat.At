import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/Login_Page.dart';
import 'package:chatapp/pages/auth/friend_list.dart';
import 'package:chatapp/pages/auth/search_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/pages/requests.dart';
import 'package:chatapp/pages/user_search.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class FriendList extends StatefulWidget {
  FriendList({super.key});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  //String key = "";
  String userName = "";
  String email = "";
  List<String> friendlist = [];
  String? currentUserUid;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    await HelperFunctions.getUserEmailFromSf().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshot in friends stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserFriends()
        .then((snapshot) {
      setState(() {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .get()
            .then((docSnapshot) {
          if (docSnapshot.exists) {
            setState(() {
              friendlist = List<String>.from(docSnapshot['friends']);
            });
          }
        });
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(69),
          child: AppBar(
              elevation: 0,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  onPressed: () {
                    nextScreen(context, UserSearch());
                  },
                  icon: const Icon(Icons.person_search_rounded),
                )
              ],
              centerTitle: true,
              title: const Text(
                "Friends",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Borel',
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ))),
      body: Stack(
        children: <Widget>[
          friendList(),
          Positioned(
            bottom: 25,
            right: 10,
            child: RawMaterialButton(
              onPressed: () {
                nextScreen(context, UserSearch());
              },
              shape: const CircleBorder(),
              fillColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 55,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.black,
            ),
            //elevated button for Profile
            const SizedBox(
              height: 30,
            ),
            //username
            Text(userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Borel",
                    fontSize: 25,
                    fontStyle: FontStyle.italic)),
            //email
            Text(email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Borel",
                    fontSize: 20,
                    fontStyle: FontStyle.italic)),
            //chats
            const SizedBox(
              height: 50,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 15,
                  ),
                  const Icon(Icons.chat, size: 35),
                  const SizedBox(
                    width: 10,
                  ),
                  Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(
                          text: "Chats",
                          style: const TextStyle(
                              fontFamily: 'Borel',
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const HomePage());
                            }))
                ]),
            //Profile
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 15,
                  ),
                  const Icon(Icons.account_circle_sharp, size: 35),
                  const SizedBox(
                    width: 10,
                  ),
                  Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(
                          text: "Profile",
                          style: const TextStyle(
                              fontFamily: 'Borel',
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreenReplace(
                                  context,
                                  ProfilePage(
                                    userName: userName,
                                    email: email,
                                  ));
                            }))
                ]),
            //Account

            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 15,
                  ),
                  const Icon(Icons.settings, size: 35),
                  const SizedBox(
                    height: 5,
                    width: 10,
                  ),
                  Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(
                          text: "Account",
                          style: const TextStyle(
                              fontFamily: 'Borel',
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()..onTap = () {}))
                ]),
            //Requests

            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 15,
                  ),
                  const Icon(Icons.notifications_on_rounded, size: 35),
                  const SizedBox(
                    height: 5,
                    width: 10,
                  ),
                  Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(
                          text: "Requests",
                          style: const TextStyle(
                              fontFamily: 'Borel',
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, Requests());
                            }))
                ]),
            //LogOut
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 15,
                  ),
                  const Icon(Icons.logout_sharp, size: 35),
                  const SizedBox(
                    width: 10,
                  ),
                  Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(
                          text: "Log Out",
                          style: const TextStyle(
                              fontFamily: 'Borel',
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Log Out"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                              "Are you sure you want to logout?"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await authService.SignOut();
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginPage()),
                                                          (route) => false);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black),
                                                child: const Text("Yes"),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black),
                                                child: const Text("Cancel"),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                              // nextScreenReplace(context, const LoginPage());
                            }))
                ])
            //elevated button for LogOut
          ],
        ),
      ),
    );
  }

  searchAppBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(69),
        child: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_search_rounded),
              )
            ],
            title: const Text(
              "Friends",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Borel',
                fontSize: 15,
                fontWeight: FontWeight.w200,
              ),
            )));
  }

  friendList() {
    if (friendlist.isEmpty) {
      return noFrinedsWidget();
    }
    return ListView.builder(
      itemCount: friendlist.length,
      itemBuilder: (context, index) {
        final friendUid = friendlist[index];
        return FutureBuilder(
            future: getUserData(friendUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              } else if (snapshot.hasData) {
                return Text('Error: ${snapshot.error}');
              } else {
                final friendData = snapshot.data as Map<String, dynamic>;
                final friendName = friendData['username'] as String;
                final friendEmail = friendData['email'] as String;

                return Card(
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    leading: const Icon(
                      Icons.account_circle_sharp,
                      color: Colors.black,
                      size: 60,
                    ),
                    title: Text(
                      friendName,
                    ),
                  ),
                );
              }
            });
      },
    );
  }

  //extracting User Data
  Future<Map<String, dynamic>> getUserData(String uid) async {
    final friendDocument =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final friendSnapshot = await friendDocument.get();
    if (friendSnapshot.exists) {
      return friendSnapshot.data() as Map<String, dynamic>;
    } else {
      return {}; // Return an empty map if sender data is not found
    }
  }

  noFrinedsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "No Friends so far :'(",
            style: TextStyle(
              fontFamily: 'Borel',
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ))
        ],
      ),
    );
  }
}
