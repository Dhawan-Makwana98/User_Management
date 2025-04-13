import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class LocalStorageService {
  final String _key = "local_users";

  Future<void> saveUserLocally(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_key) ?? [];
    users.add(jsonEncode(user.toMap()));
    await prefs.setStringList(_key, users);
  }

  Future<List<UserModel>> getLocalUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_key) ?? [];
    return users
        .map((userJson) => UserModel.fromMap(jsonDecode(userJson)))
        .toList();
  }

  Future<void> clearLocalUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
