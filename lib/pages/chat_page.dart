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
          title: Text(friendName ??
              'Friend'), // Display friend's name or a default value
        ),
      ),
      body: Stack(
        children: [
          Text(currentUserName ?? 'User')
        ], // Display current user's name or a default value
      ),
    );
  }

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
