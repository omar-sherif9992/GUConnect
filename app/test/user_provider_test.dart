import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';

void main() {
  group('UserProvider', () {
    WidgetsFlutterBinding.ensureInitialized();
    late UserProvider userProvider;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      userProvider = UserProvider(mockFirebaseAuth);
    });

    test('register should return true when registration is successful',
        () async {
      final email = 'test@example.com';
      final password = 'password';

/*       final result = await userProvider.register(User(
        email: email,
        password: password,

      
      ));

      expect(result, true); */
    });

    test('register should throw an exception when weak password is provided',
        () async {
      final email = 'test@example.com';
      final password = 'weak';
    });

    test('register should throw an exception when email is already in use',
        () async {
      final email = 'test@example.com';
      final password = 'password';

      mockFirebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .catchError((error) {
        throw FirebaseAuthException(code: 'email-already-in-use');
      });

      //     expect(() => userProvider.register(email, password), throwsException);
    });

    test('login should return true when login is successful', () async {
      final email = 'test@example.com';
      final password = 'password';

      final result = await userProvider.login(email, password);

      expect(result, true);
    });

    test('login should throw an exception when user is not found', () async {
      final email = 'test@example.com';
      final password = 'password';

      mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(() => userProvider.login(email, password), throwsException);
    });

    test('login should throw an exception when wrong password is provided',
        () async {
      final email = 'test@example.com';
      final password = 'password';

      mockFirebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .catchError((error) {
        throw FirebaseAuthException(code: 'wrong-password');
      });

      expect(() => userProvider.login(email, password), throwsException);
    });

    test('logout should return true when logout is successful', () async {
      final result = await userProvider.logout();

      expect(result, true);
    });
  });
}
