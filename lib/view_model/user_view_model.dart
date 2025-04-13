// ignore_for_file: avoid_print

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _wasConnected = false;

  UserViewModel() {
    _monitorConnectivity();
    loadUsers();
  }

  Future<void> addUser(UserModel user) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("📴 No internet. Saving user locally.");
      await _localStorageService.saveUserLocally(user);
    } else {
      print("🌐 Internet available. Saving user to Firebase.");
      await _firebaseService.addUserToFirebase(user);
      await _syncLocalData(); // Sync local data after adding user to Firebase
    }
    _users.add(user); // Add the user to the list immediately
    notifyListeners(); // Notify listeners to update the UI
    loadUsers(); // Refresh the list to avoid duplications
  }

  Future<void> loadUsers() async {
    try {
      List<UserModel> localUsers = await _localStorageService.getLocalUsers();
      List<UserModel> firebaseUsers = [];

      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        print("📥 Loading users from local storage...");
      } else {
        print("☁️ Loading users from Firebase...");
        firebaseUsers = await _firebaseService.fetchUsersFromFirebase();
      }

      // Clear the current users list
      _users.clear();

      // Add Firebase users to the list and print their source
      for (var user in firebaseUsers) {
        _users.add(user);
        print("🔥 Firebase User: ${user.firstName}");
      }

      // Add local users to the list and print their source
      for (var user in localUsers) {
        if (!_users.any((u) => u.id == user.id)) {
          _users.add(user);
          print("📦 Local User: ${user.firstName}");
        }
      }

      notifyListeners();
    } catch (e) {
      print("Error loading users: $e");
    }
  }

  void _monitorConnectivity() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isEmpty || results.first == ConnectivityResult.none) {
        if (_wasConnected) {
          Fluttertoast.showToast(msg: "📴 No internet connection");
          print("📴 Connection lost. Will use local storage.");
          _wasConnected = false;
        }
      } else {
        if (!_wasConnected) {
          Fluttertoast.showToast(msg: "🌐 Internet connected");
          print("🌐 Connection restored. Syncing data to Firebase.");
          _syncLocalData();
          loadUsers();
          _wasConnected = true;
        }
      }
    });
  }

  Future<void> _syncLocalData() async {
    print("🔁 Syncing local data to Firebase...");
    List<UserModel> localUsers = await _localStorageService.getLocalUsers();
    for (var user in localUsers) {
      print("➡️ Pushing local user to Firebase: ${user.firstName}");
      await _firebaseService.addUserToFirebase(user);
    }
    await _localStorageService.clearLocalUsers();
    print("✅ Local data synced and cleared.");
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
