//  user provider

import 'package:GUConnect/src/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late User? _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  User? get user => _user;

  void logout() {
    _user = null;
    notifyListeners();
  }
}
