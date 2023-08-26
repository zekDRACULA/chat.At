import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys

  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

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
  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
