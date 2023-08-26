import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/Login_Page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 40),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 60, width: 265),
                    const Text(
                      "Chat@",
                      style: TextStyle(
                        fontFamily: 'Borel',
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Register Now >.<",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 80,
                      width: 20,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: "Username",
                          prefixIcon: const Icon(
                            Icons.account_box,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(
                          () {
                            username = val;
                          },
                        );
                      },
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          return null;
                        } else {
                          return "Username cannot be empty";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: "Eamil",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(() {
                          email = val;
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
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(
                          () {
                            password = val;
                          },
                        );
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
                      height: 10,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                          onPressed: () {
                            register();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            "Register",
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login!",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreenReplace(context, const LoginPage());
                                }),
                        ])),
                  ],
                ),
              ),
            ),
    );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(username, email, password)
          .then((value) async => {
                if (value == true)
                  {
                    //saving the shared preferences
                    await HelperFunctions.saveUserLoggedInStatus(true),
                    await HelperFunctions.savedUserEmailSF(email),
                    await HelperFunctions.savedUserNameSF(username),
                    nextScreenReplace(context, const HomePage())
                  }
                else
                  {
                    showSnackbar(context, Colors.black, value),
                    setState(() {
                      _isLoading = false;
                    })
                  }
              });
    }
  }
}
