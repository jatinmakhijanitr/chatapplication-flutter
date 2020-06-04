import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedUserLoginKey = "Logged In";
  static String sharedUserNameKey = "Username Key";
  static String sharedUserEmailKey = "User Email Key";

  // Saving Data

  static Future<bool> savedUserLogin(bool isUserLogedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(sharedUserLoginKey, isUserLogedIn);
  }

  static Future<bool> savedUserName(String userName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedUserNameKey, userName);
  }

  static Future<bool> savedEmail(String userEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedUserEmailKey, userEmail);
  }

  // Getting Data

  static Future<bool> getLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(sharedUserLoginKey);
  }

  static Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedUserNameKey);
  }

  static Future<String> getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedUserEmailKey);
  }
}
