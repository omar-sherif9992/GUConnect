import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockFirebaseUser extends Mock implements User {}

void main() {
  group('UserProvider', () {
    // WidgetsFlutterBinding.ensureInitialized();
    late UserProvider userProvider;
    late MockFirebaseAuth mockFirebaseAuth;
    // late BehaviorSubject<MockFirebaseUser> _user;
    final instance = FakeFirebaseFirestore();
    late CustomUser user;
    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      userProvider = UserProvider(mockFirebaseAuth, instance);
      // _user = BehaviorSubject<MockFirebaseUser>();
      user = CustomUser(
        fullName: 'a b c',
        userName: 'abc',
        email: 'a@guc.edu.eg',
        password: 'abcdef1',
      );
      instance.dump();
    });
    tearDown(() {
      // Clear data in the firestore instance
      user = CustomUser(
        fullName: 'a b c',
        userName: 'abc',
        email: 'a@guc.edu.eg',
        password: 'abcdef1',
      );
      instance.dump();
    });

    test('Login with valid credentials should succeed', () async {
      // Mock Firebase Authentication if needed
      final mockFirebaseAuth = MockFirebaseAuth();

      // Define test user credentials
      final email = 'test@example.com';
      final password = 'testpassword';

      // Simulate successful login
      bool userCredential = await userProvider.login(email, password);

      // Login using your actual implementation

      // Verify successful login
      expect(userCredential, isNotNull);
    });
    test('Login with invalid credentials should fail', () async {
      // Mock Firebase Authentication if needed
      final mockFirebaseAuth = MockFirebaseAuth();

      // Define invalid credentials
      final email = 'invalid@example.com';
      final password = 'wrongpassword';

      // Simulate error on login
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(FirebaseAuthException(
              code: 'invalid-credentials',
              message: 'Invalid email or password.'));

      // Login using your actual implementation
    });
    // when(mockFirebaseAuth.onAuthStateChanged).thenAnswer((_) {
    //   return _user;
    // });
    // when(mockFirebaseAuth.signInWithEmailAndPassword(
    //         email: "email", password: "password"))
    //     .thenAnswer((_) async {
    //   _user.add(MockFirebaseUser());
    //   return MockUserCredential();
    // });
    // when(mockFirebaseAuth.signInWithEmailAndPassword(
    //         email: "mail", password: "pass"))
    //     .thenThrow(() {
    //   return null;
    // });

    test('registering with valid data', () async {
      final String result = await userProvider.register(user);

      expect(result, 'success');
    });

    test('register fails on weak password', () async {
      user.email = 'b@guc.edu.eg';
      user.password = 'x';
      final result = await userProvider.register(user);
      expect(result, 'weak-password');
    });

    test('registering fails used email', () async {
      user.email = 'c@guc.edu.eg';
      final String res = await userProvider.register(user);
      final String res2 = await userProvider.register(user);
      final CollectionReference<Map<String, dynamic>> usersRef =
          instance.collection('users');
      expect(res, "success");
      expect(res2, "email-already-in-use");
    });

    test('registering fails non guc email', () async {
      user.email = 'a@gmail.com';
      final String res = await userProvider.register(user);
      expect(res, 'invalid-email');
    });

    test('registering fails invalid email', () async {
      user.email = 'x';
      final String res = await userProvider.register(user);
      expect(res, 'invalid-email');
    });

    test('registering fails empty username', () async {
      user.userName = '';
      user.email = 'd@guc.edu.eg';
      final String res = await userProvider.register(user);
      expect(res, 'missing-data');
    });

    test('registering fails empty fullname', () async {
      user.fullName = '';
      user.email = 'd@guc.edu.eg';
      final String res = await userProvider.register(user);
      expect(res, 'missing-data');
    });

    test('login fails with incorrect credentials', () async {
      final String mail = "Acafada@guc.edu.eg";
      final String password = "dwadagwagwafawfa";

      final bool res = await userProvider.login(mail, password);
      expect(res, isNull);
    });

    test('login returns true on successful login', () async {
      // when(mockFirebaseAuth.signInWithEmailAndPassword(
      //   email: anyNamed('email') ?? '',
      //   password: anyNamed('password') ?? '',
      // )).thenAnswer((_) async {
      //   // Simulate successful login
      //   return MockUserCredential();
      // });

      final bool res = await userProvider.login(user.email, user.password);
      expect(res, true);
    });

    test('login fails with correct credentials', () async {
      await userProvider.register(user);
      final bool res = await userProvider.login(user.email, user.password);
      expect(res, true);
    });

    test('login fails with empty email', () async {
      user.email = '';
      final bool res = await userProvider.login(user.email, user.password);
      expect(res, false);
    });

    test('login fails with empty password', () async {
      user.password = '';
      final bool res = await userProvider.login(user.email, user.password);
      expect(res, false);
    });

    // test('register should throw an exception when email is already in use',
    //     () async {
    //   final email = 'test@example.com';
    //   final password = 'password';

    //   mockFirebaseAuth
    //       .createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   )
    //       .catchError((error) {
    //     throw FirebaseAuthException(code: 'email-already-in-use');
    //   });

    //   //     expect(() => userProvider.register(email, password), throwsException);
    // });

    // test('login should return true when login is successful', () async {
    //   final email = 'test@example.com';
    //   final password = 'password';

    //   final result = await userProvider.login(email, password);

    //   expect(result, true);
    // });

    // test('login should throw an exception when user is not found', () async {
    //   final email = 'test@example.com';
    //   final password = 'password';

    //   mockFirebaseAuth.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );

    //   expect(() => userProvider.login(email, password), throwsException);
    // });

    // test('login should throw an exception when wrong password is provided',
    //     () async {
    //   final email = 'test@example.com';
    //   final password = 'password';

    //   mockFirebaseAuth
    //       .signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   )
    //       .catchError((error) {
    //     throw FirebaseAuthException(code: 'wrong-password');
    //   });

    //   expect(() => userProvider.login(email, password), throwsException);
    // });

    // test('logout should return true when logout is successful', () async {
    //   final result = await userProvider.logout();

    //   expect(result, true);
    // });
  });
}

class MockUserCredential extends Mock implements UserCredential {}
