//  user provider

import 'dart:convert';

import 'package:GUConnect/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, User;
import 'package:GUConnect/src/models/User.dart';
import 'package:firebase_core/firebase_core.dart';

class UserProvider with ChangeNotifier {
  CustomUser? _user;
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;
  CustomUser? get user => _user;
  late FirebaseAuth _firebaseAuth;

  UserProvider([FirebaseAuth? firebaseAuth]) {
    init();
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _user = CustomUser.fromJson(jsonDecode(user.toString()));
      } else {
        _loggedIn = false;
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<bool> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _firebaseAuth.currentUser!.sendEmailVerification();
      return true;
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
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        throw Exception('Wrong password provided for that user.');
      }
    }
    return false;
  }

  Future<bool> logout() async {
    await _firebaseAuth.signOut();
    return true;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw Exception('No user found for that email.');
      }
    }
    return false;
  }

  Future<bool> updatePassword(String password) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(password);
      return true;
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
    return false;
  }



}
