import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:moneycart/app/auth/models/user_model.dart';

class UserPreferences {
  // Save UserModel to SharedPreferences
  static Future<void> setUserModel(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user_model', userJson);
  }

  // Retrieve UserModel from SharedPreferences
  static Future<UserModel?> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_model');
    if (userJson == null) return null;
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserModel(
      id: userMap['id'],
      name: userMap['name'],
      email: userMap['email'],
      gender: userMap['gender'],
      phone: userMap['phone'],
      address: userMap['address'],
      profile: userMap['profile'],
      fcmToken: userMap['fcmToken'],
      referral: userMap['referral'],
    );
  }

  // Save user ID to SharedPreferences
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  // Retrieve user ID from SharedPreferences
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}
