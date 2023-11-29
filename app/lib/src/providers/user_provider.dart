//  user provider

import 'package:GUConnect/src/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> register(String email, String password) async {
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;

    notifyListeners();
  }
}
