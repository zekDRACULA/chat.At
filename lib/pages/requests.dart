import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? recievedRequests;

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserUid)
        .collection('recieved_Requests')
        .snapshots();

    setState(() {
      recievedRequests = snapshot;
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
            )),
      ),
      body: Stack(
        children: [
          recievedRequestList(),
        ],
      ),
    );
  }

  recievedRequestList() {
    if (recievedRequests == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }
    return StreamBuilder(
        stream: recievedRequests,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return noRequestsWidget();
          } else {
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data!.docs;
            return showRecievedRequests(documents);
          }
        });
  }

  showRecievedRequests(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) async {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> data = documents[index].data();
        final String senderName = data['username'] as String;
        final String senderEmail = data['email'] as String;
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
                  fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              senderEmail,
              style: const TextStyle(
                  fontFamily: "Borel",
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
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
          ))
        ],
      ),
    );
  }

  //Stream<QuerySnapshot> getDataRealTime() {
  // return FirebaseFirestore.instance.collection('users').snapshots();
  //}
}
