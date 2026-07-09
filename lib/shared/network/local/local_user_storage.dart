import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user/user_model.dart';

class LocalUserStorage {
  static const String _userKey = 'local_user_data';

  /// Save full user model to local storage
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final json = user.toJson();
    await prefs.setString(_userKey, jsonEncode(json));
  }

  /// Load full user model from local storage
  static Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString);
      return UserModel.fromJson(json);
    } catch (e) {
      debugPrint('Error loading user: $e');
      return null;
    }
  }

  /// Check if a user exists locally
  static Future<bool> hasExistingUser() async {
    final user = await loadUser();
    return user != null && user.name.trim().isNotEmpty;
  }

  /// Clear all user data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<UserModel?> loadUserById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString);
      final user = UserModel.fromJson(json);
      if (user.id == id) return user;
      return null;
    } catch (e) {
      debugPrint('Error loading user by id: $e');
      return null;
    }
  }
}