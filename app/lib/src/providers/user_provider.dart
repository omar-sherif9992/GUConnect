//  user provider

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, User;
import 'package:GUConnect/src/models/User.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;
  User? get user => _user;

  UserProvider() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        print(user.toString());
        _user = User.fromJson(jsonDecode(user.toString()));
      } else {
        _loggedIn = false;
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
