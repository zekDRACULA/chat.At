import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chat_page extends StatefulWidget {
  final String? currentUserUid;
  final String? friendUid;

  const chat_page({
    super.key,
    required this.currentUserUid,
    required this.friendUid,
  });

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  String? currentUserName;
  String? friendName;
  AuthService authService = AuthService();
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, dynamic> userData =
        await getUserData(widget.currentUserUid!, widget.friendUid!);

    DocumentSnapshot? currentUserDoc = userData['currentUserDoc'];
    DocumentSnapshot? friendDoc = userData['friendDoc'];

    // Now you can access the data from these documents, e.g., user name and friend name.
    setState(() {
      currentUserName = currentUserDoc?['username'];
      friendName = friendDoc?['username'];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(69),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            friendName ?? 'Friend',
            style: TextStyle(fontFamily: 'Borel'),
          ),
          // Display friend's name or a default value
        ),
      ),
      body: Stack(
        children: <Widget>[
          //chatMessages(),
          Column(
            mainAxisAlignment: MainAxisAlignment
                .end, // Pushes the inner container to the bottom
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 2), // Adjust the horizontal padding as needed
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Send Message....",
                            hintStyle: TextStyle(
                              fontFamily: 'Borel',
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2), // Adjust the height as needed
            ],
          ),
        ], // Display current user's name or a default value
      ),
    );
  }

  chatMessages() {}
  Future<Map<String, dynamic>> getUserData(
      String currentUserUid, String friendUid) async {
    final CurrentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    final friendDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .get();

    if (CurrentUserDoc.exists && friendDoc.exists) {
      return {
        'currentUserDoc': CurrentUserDoc,
        'friendDoc': friendDoc,
      };
    } else {
      return {
        'currentUserDoc': null,
        'friendDoc': null,
      };
    }
  }
}
