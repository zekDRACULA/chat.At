import 'dart:developer';
import 'package:chatapp/pages/auth/register_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.black),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 40),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 150, width: 265),
                    const Text(
                      "Chat@",
                      style: TextStyle(
                        fontFamily: 'Borel',
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Login to start messaging >.<",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 50,
                      width: 20,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                          log(email);
                        });
                      },

                      // check the email validation

                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(() {
                          password = val;
                          log(password);
                        });
                      },
                      validator: (val) {
                        if (val!.length < 8) {
                          return "Password must be at least 8 characters";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 17),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text.rich(TextSpan(
                        text: "Don't have an account? ",
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Register here!",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                }),
                        ]))
                  ],
                ),
              ),
            ),
    );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          //saving the values to our sharedpreferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.savedUserEmailSF(email);
          await HelperFunctions.savedUserNameSF(snapshot.docs[0]['username']);

          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.black, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
