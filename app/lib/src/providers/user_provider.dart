//  user provider
import 'dart:io';

import 'package:GUConnect/src/utils/uploadImageToStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, User;
import 'package:GUConnect/src/models/User.dart';

class UserProvider with ChangeNotifier {
  CustomUser? _user;
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;
  CustomUser? get user => _user;
  late FirebaseAuth _firebaseAuth;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<CustomUser>(
        fromFirestore: (snapshot, _) => CustomUser.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  UserProvider([FirebaseAuth? firebaseAuth]) {
    init();
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  }

  Future<void> init() async {
/*     await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform); */

    _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        //_user = CustomUser.fromJson(jsonDecode(user.toString()));
        final DocumentSnapshot<CustomUser> documentSnapshot =
            await usersRef.doc(user.uid).get();
        _user = documentSnapshot.data();
      } else {
        _loggedIn = false;
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<bool> register(CustomUser newUser) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: newUser.email, password: newUser.password);
      _firebaseAuth.currentUser!.sendEmailVerification();

      usersRef.add(newUser);

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

  Future<bool> updateEmail(String email) async {
    try {
      await _firebaseAuth.currentUser!.updateEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('The email provided is invalid.');
        throw Exception('The email provided is invalid.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateProfile(
      {String? fullName,
      String? userName,
      String? phoneNumber,
      String? biography}) async {
    try {
      final DocumentSnapshot<CustomUser> documentSnapshot =
          await usersRef.doc(_firebaseAuth.currentUser!.uid).get();
      final CustomUser user = documentSnapshot.data()!;
      user.fullName = fullName;
      user.userName = userName;
      user.phoneNumber = phoneNumber;
      user.biography = biography;
      await usersRef.doc(_firebaseAuth.currentUser!.uid).set(user);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-display-name') {
        print('The display name provided is invalid.');
        throw Exception('The display name provided is invalid.');
      } else if (e.code == 'invalid-photo-url') {
        print('The photo URL provided is invalid.');
        throw Exception('The photo URL provided is invalid.');
      } else if (e.code == 'invalid-phone-number') {
        print('The phone number provided is invalid.');
        throw Exception('The phone number provided is invalid.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future updateImage(File image) async {
    final String fileName = _firebaseAuth.currentUser!.uid;
    const String collectionName = 'users';
    final String imageUrl =
        await uploadImageToStorage(image, collectionName, fileName);
    return usersRef
        .doc(_firebaseAuth.currentUser!.uid)
        .update({'image': imageUrl});
  }

  
  Future deleteUser() async {
    try {
      await usersRef.doc(_firebaseAuth.currentUser!.uid).delete();

      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be done.');
        throw Exception(
            'The user must reauthenticate before this operation can be done.');
      }
    } catch (e) {
      print(e);
    }
  }
}
