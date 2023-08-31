import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/friend_list.dart';
import 'package:chatapp/pages/auth/search_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'auth/Login_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  Stream? chats;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
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
    //getting teh list of snapshots in our streams
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserChats()
        .then((snapshot) {
      setState(() {
        chats = snapshot;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(69),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(
                  Icons.search,
                ))
          ],
          centerTitle: true,
          title: const Text(
            "Chat@",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Borel',
              fontSize: 22,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          const Center(
              child: Text(
            "No Chats so far O.O",
            style: TextStyle(
              fontFamily: 'Borel',
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          )),
          Positioned(
            bottom: 25,
            right: 10,
            child: RawMaterialButton(
              onPressed: () {
                nextScreen(context, const FriendList());
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
      // Drawer for side menu
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
            //profile
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

                  // Log Out
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
                                      title: Text("Log Out"),
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

  chatList() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          //make some checks
          if (snapshot.hasData) {
            if (snapshot.data['chats'] != null) {
            } else {
              return noChatWidgets();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
        });
  }
}
