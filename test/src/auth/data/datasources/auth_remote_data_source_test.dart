import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/core/errors/api_exeption.dart';
import 'package:course_app/core/res/media_res.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:course_app/src/auth/data/modules/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock UserCredential
class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

// Mock User
class MockUser extends Mock implements User {
  String _uid = '';
  @override
  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }
}

void main() {
  late AuthRemoteDataSourceIpl authDataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore mockFirestore;
  late MockFirebaseStorage mockFirebaseStorage;
  late UserCredential mockUserCredential;
  late MockUser mockUser;

  late DocumentReference<DataMap> documentReference;
  setUpAll(() async {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = FakeFirebaseFirestore();
    documentReference = mockFirestore.collection('users').doc();
    mockFirebaseStorage = MockFirebaseStorage();
    mockUser = MockUser()..uid = documentReference.id;
    mockUserCredential = MockUserCredential(mockUser);

    authDataSource = AuthRemoteDataSourceIpl(
      mockFirebaseAuth,
      mockFirestore,
      mockFirebaseStorage,
    );
    registerFallbackValue(
      const AuthCredential(providerId: '', signInMethod: ''),
    );
    registerFallbackValue(File(''));

    when(
      () => mockFirebaseAuth.currentUser,
    ).thenReturn(mockUser);
  });

  const tpassword = 'tpassword';
  const tfullName = 'tname';
  const temail = 'temail';

  // every group should run by it self for some reason becuase the out
  // dependency ;

  group('forgetPassword', () {
    test('should send password reset email', () async {
      const email = 'test@example.com';

      when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenAnswer((_) => Future.value());

      final call = authDataSource.forgetPassword(email);
      expect(call, completes);

      verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .called(1);
    });

    test('should throw ServerException if FirebaseAuthException occurs',
        () async {
      const email = 'test@example.com';

      when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenThrow(
        FirebaseAuthException(code: 'error_code', message: 'error_message'),
      );

      expect(
        () => authDataSource.forgetPassword(email),
        throwsA(
          predicate(
            (e) =>
                e is ServerExpiton &&
                e.message == 'error_message' &&
                e.statusCode == 'error_code',
          ),
        ),
      );
    });
  });

  group('sign up ', () {
    test('sign uop success', () async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (invocation) async => mockUserCredential,
      );

      when(() => mockUser.updateDisplayName(any()))
          .thenAnswer((invocation) => Future.value());
      when(() => mockUser.updatePhotoURL(any()))
          .thenAnswer((invocation) => Future.value());

      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );

      final call = authDataSource.signUp(
        email: temail,
        password: tpassword,
        fullName: tfullName,
      );
      final doc =
          await mockFirestore.collection('users').doc(mockUser.uid).get();

      expect(call, completes);
      expect(mockUser.uid, documentReference.id);
      expect(doc.id, mockUser.uid);
    });

    test('sign up fail ', () async {
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        FirebaseAuthException(
          code: 'code ',
          message: 'some thing worng ',
        ),
      );

      // act
      final call = authDataSource.signUp;

      expect(
        () => call(email: temail, fullName: tfullName, password: tpassword),
        throwsA(isA<ServerExpiton>()),
      );
    });
  });

  group('sign in ', () {
    test('sign in success ', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((invocation) async => mockUserCredential);
      final result =
          await authDataSource.signIn(email: temail, password: tpassword);
      final userData = await mockFirestore
          .collection('users')
          .doc(mockUserCredential.user?.uid)
          .get();
      final user = UserModel.fromMap(userData.data()!);
      expect(result, user);
      expect(result.email, temail);
    });

    test('sign in fail ', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'fffff', message: 'wrong'));
      final result = authDataSource.signIn;

      expect(
        result(email: temail, password: tpassword),
        throwsA(isA<ServerExpiton>()),
      );
    });
  });

  group('update user ', () {
    setUp(() async {
      documentReference = await mockFirestore
          .collection('users')
          .add(UserModel.empty().toMap());
      mockUser.uid = documentReference.id;
    });
    test('update user success ', () async {
      // arrange

      when(
        () => mockUser.reauthenticateWithCredential(any()),
      ).thenAnswer((invocation) async => mockUserCredential);
      when(
        () => mockUser.verifyBeforeUpdateEmail(any()),
      ).thenAnswer((invocation) => Future.value());
      when(
        () => mockUser.updateDisplayName(any()),
      ).thenAnswer((invocation) => Future.value());
      when(
        () => mockUser.updatePhotoURL(any()),
      ).thenAnswer((invocation) async => 'photourl');
      when(
        () => mockUser.updatePassword(any()),
      ).thenAnswer((invocation) => Future.value());

      await authDataSource.updateUser(
        currentPassword: 'tpassword',
        email: 'email',
        fullName: 'fullName',
        password: 'new',
        profilePic: File(MediaRes.iconatoms),
      );

      final userData =
          await mockFirestore.collection('users').doc(mockUser.uid).get();
      final re = userData.data();

      expect(re?['email'], 'email');
      expect(re?['fullName'], 'fullName');
      expect(re?['fullName'], 'fullName');
      expect(re?['profilePic'], isA<String>());
    });

    test(
        'update user fail for  wrong password and i am lazy to handdle '
        'the other cases of fail  ', () async {
      // arrange

      when(
        () => mockUser.reauthenticateWithCredential(any()),
      ).thenThrow(FirebaseAuthException(code: 'worg ', message: 'worng'));

      final call = authDataSource.updateUser;

      expect(
        call(
          currentPassword: 'tpassword',
          email: 'email',
          fullName: 'fullName',
          password: 'new',
          profilePic: File(MediaRes.iconatoms),
        ),
        throwsA(isA<ServerExpiton>()),
      );
    });
  });

  group('get user Data', () {
    setUp(() async {
      documentReference = await mockFirestore
          .collection('users')
          .add(UserModel.empty().toMap());
      mockUser.uid = documentReference.id;
    });
    test('getUserData success', () async {
      final result = await authDataSource.getUserData();

      expect(result.uid, mockUser._uid);
      expect(result.fullName, '');
    });
    test('getUserData fail because there is no user sign in ', () async {
      when(
        () => mockFirebaseAuth.currentUser,
      ).thenReturn(null);
      final result = authDataSource.getUserData;

      expect(result(), throwsA(isA<ServerExpiton>()));
    });
  });
}
