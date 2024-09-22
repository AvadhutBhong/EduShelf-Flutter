import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USER_ID_KEY";
  static String userNameKey = "USER_NAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";
  static String userImageKey = "USER_IMAGE_KEY";
  static String userPhoneKey = "USER_PHONE_KEY";

  //SAVING CURRENT VALUES LOCALLY TO ACCESS WHENEVER REQUIRED
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  // Future<bool> saveUserPhone(String getUserPhone) async{
  //   print('Saving phone number , $getUserPhone');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(userPhoneKey, getUserPhone);
  // }

  Future<void> saveUserPhone(String userId, String phone) async {
    print('Saving phone $phone for userid $userId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("phone_$userId", phone); // Use userId as part of the key
  }


  //METHODS TO ACCESS LOCALLY SAVED DATA WHEN REQUIRED
  Future<String ?> getUserId() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String ?> getUserImage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<String?> getUserPhone(String userId) async {
    print('Sending phone for userid $userId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone_$userId"); // Use userId as part of the key
  }
}
