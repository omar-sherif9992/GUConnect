//  user provider
import 'dart:io';
import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:GUConnect/src/services/notification_api.dart';
import 'package:GUConnect/src/utils/uploadImageToStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, User;
import 'package:GUConnect/src/models/User.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class UserProvider with ChangeNotifier {
  CustomUser? _user;
  bool _loggedIn = false;
  late FirebaseFirestore _firestore;
  bool get loggedIn => _loggedIn;
  CustomUser? get user => _user;
  late FirebaseAuth _firebaseAuth;

  late CollectionReference<CustomUser> usersRef;

  UserProvider(FirebaseAuth firebaseAuth, FirebaseFirestore firestore) {
    _firebaseAuth = firebaseAuth;
    _firestore = firestore;
    usersRef = _firestore.collection('users').withConverter<CustomUser>(
          fromFirestore: (snapshot, _) => CustomUser.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
    init();
  }

  Future<void> init() async {
    /*     await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform); */
    _firebaseAuth.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        final DocumentSnapshot<CustomUser> documentSnapshot =
            await usersRef.doc(user.uid).get();
        _user = documentSnapshot.data();
      } else {
        _loggedIn = false;
        _user = null;
      }
      // notifyListeners();
    });
  }

  Future<bool> isEmailInUse(String email) async {
    QuerySnapshot<CustomUser> querySnapshot =
        await usersRef.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  bool isWeakPassword(String password) {
    return password.length < 6;
  }

  bool isValidGUCEmail(String email) {
    final List<String> parts = email.split('@');
    if (parts.length == 2) {
      String domain = parts[1];
      return domain == 'guc.edu.eg' || domain == 'student.guc.edu.eg';
    }
    return false;
  }

  Future<String> register(CustomUser newUser) async {
    bool emailInUse = await isEmailInUse(newUser.email);
    if (emailInUse) {
      return 'email-already-in-use';
    }
    if (isWeakPassword(newUser.password)) {
      return 'weak-password';
    }

    if (!EmailValidator.validate(newUser.email) ||
        !isValidGUCEmail(newUser.email)) {
      return 'invalid-email';
    }
    if (newUser.fullName!.isEmpty || newUser.userName!.isEmpty) {
      return 'missing-data';
    }

    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: newUser.email, password: newUser.password);
      _firebaseAuth.currentUser!.sendEmailVerification();
      newUser.user_id = userCredential.user!.uid;
      await usersRef.doc(userCredential.user?.uid).set(newUser);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      print(e);
    }
    return 'failure';
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;
    try {
      UserCredential uc = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true; // Return true only on successful login
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        throw Exception('Wrong password provided for that user.');
      }
      // Handle other FirebaseAuthException types if needed
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      // Handle general exceptions
      print('Login failed: $e');
      throw Exception('Login failed: $e');
    }
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

  Future<bool> updateProfile(CustomUser editUser, File? pickedImageFile) async {
    try {
      print('pickedImageFile ==================');
      print(pickedImageFile);
      if (_user != null) {
        if (pickedImageFile != null) {
          final String? imageUrl = await uploadImageToStorage(
              pickedImageFile, 'user_images', _user!.user_id!);
          if (imageUrl != null) {
            _user!.image = imageUrl;
          }
        }
        _user!.biography = editUser.biography;
        _user!.fullName = editUser.fullName;
        _user!.phoneNumber = editUser.phoneNumber;
        _user!.userName = editUser.userName;

        await usersRef.doc(_user!.user_id).set(_user!);
      }
      notifyListeners();
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
      print("================================");
      print(e);
    }
    return false;
  }

  Future updateImage(File image) async {
    final String fileName = _firebaseAuth.currentUser!.uid;
    const String collectionName = 'users';
    final String? imageUrl =
        await uploadImageToStorage(image, collectionName, fileName);

    return usersRef
        .doc(_firebaseAuth.currentUser!.uid)
        .update({'image': imageUrl});
  }

  Future deleteUser() async {
    try {
      await _firebaseAuth.signOut();
      await _firebaseAuth.currentUser!.delete();
      await usersRef.doc(_firebaseAuth.currentUser!.uid).delete();
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

  Map<String, OTPData> otpStore = {};

  Future<void> sendOtpToEmail(String receiverEmail) async {
    const String sendermail = 'guconnect.help@gmail.com';
    const String password = 'guc12345';
    const String accesstoken = 'cfjrrcqxgjuntfke';
    final Random random = Random();
    final String otp = (100000 + random.nextInt(900000)).toString();
    final DateTime expiryTime = DateTime.now().add(const Duration(minutes: 5));
    otpStore[receiverEmail] = OTPData(otp: otp, expiryTime: expiryTime);
    final smtpServerDetails = gmail(sendermail, accesstoken);
//david.ywakeem@student.guc.edu.eg
    final message = Message()
      ..from = Address(sendermail.toString())
      ..recipients.add(receiverEmail)
      ..subject = 'OTP Verification'
      ..text = 'Your OTP is: $otp \n\nThis OTP will expire in 5 minutes.';

    try {
      final sendReport = await send(message, smtpServerDetails);

      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  bool verifyOTP(String email, String submittedOTP) {
    final OTPData? otpData = otpStore[email];
    if (otpData != null &&
        otpData.otp == submittedOTP &&
        DateTime.now().isBefore(otpData.expiryTime)) {
      otpStore.remove(email);
      return true;
    }
    return false;
  }

  Future<CustomUser?> getUser(String email) async {
    final QuerySnapshot<CustomUser> querySnapshot =
        await usersRef.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return querySnapshot.docs.first.data();
  }

  void setUser(CustomUser user) {
    _user = user;
    print(" Token " + FirebaseNotification.token!);
    user.updateToken(FirebaseNotification.token!);
  }

  Future getUsers() async {
    final QuerySnapshot<CustomUser> querySnapshot = await usersRef.get();
    return querySnapshot.docs;
  }
}

class OTPData {
  String otp;
  DateTime expiryTime;
  OTPData({required this.otp, required this.expiryTime});
}
