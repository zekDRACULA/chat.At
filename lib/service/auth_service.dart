import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithEmailandPassword(String email, String password) async {
    try {
      print(password);
      //password = "12345678";
      final user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print(user);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  //register

  Future registerUserWithEmailandPassword(
      String username, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      await DatabaseService(uid: user.uid).savingUserData(
        username,
        email, //massage change here swapped password with username
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signout
  Future SignOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.savedUserEmailSF("");
      await HelperFunctions.savedUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
