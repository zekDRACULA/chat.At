import 'package:chatapp/pages/auth/search_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'auth/Login_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
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
              onPressed: () {},
              shape: const CircleBorder(),
              fillColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 45,
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
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textBaseline: TextBaseline.alphabetic,
                children: [
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
                            ..onTap = () {
                              nextScreenReplace(context, const LoginPage());
                            }))
                ])
            //elevated button for LogOut
          ],
        ),
      ),
    );
  }
}
