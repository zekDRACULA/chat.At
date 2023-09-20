import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys

  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String uid = "UID";
  // saving the data to SF
  static Future<bool> saveUserLoggedInStatus(bool isUerLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUerLoggedIn);
  }

  static Future<bool> savedUserNameSF(String UserName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, UserName);
  }

  static Future<bool> savedUserEmailSF(String UserEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, UserEmail);
  }
  
  static Future<bool> savedUserUid(String uid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(uid, uid);
  }
  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
  static Future<String?> getUserUidFromSf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userLoggedInKey);
  }
  
}
