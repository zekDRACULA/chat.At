import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Stream? requests;
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserRequests()
        .then((snapshot) {
      setState(() {
        requests = snapshot;
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
        children: <Widget>[
          requestList(),
        ],
      ),
    );
  }

  requestList() {
    return StreamBuilder(
        stream: requests,
        builder: (context, AsyncSnapshot snapshot) {
          //make some checks
          if (snapshot.hasData) {
            if (snapshot.data['friends'] != null) {
              if (snapshot.data['friends'].length != 0) {
                return const Text("Hello");
              } else {
                return noRequestsWidget();
              }
            } else {
              return noRequestsWidget();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
        });
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
}
