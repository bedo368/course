import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/core/errors/api_exeption.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/data/modules/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgetPassword(String email);
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> getUserData();

  Future<void> updateUser({
    required String currentPassword,
    String? fullName,
    String? email,
    String? password,
    String? bio,
    File? profilePic,
  });
}

class AuthRemoteDataSourceIpl extends AuthRemoteDataSource {
  AuthRemoteDataSourceIpl(
    this._firebaseAuth,
    this._firestore,
    this._firebaseStorage,
  );
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  @override
  Future<void> forgetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerExpiton(
        message: e.message ?? 'error occured ',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw const ServerExpiton(
          message: 'something wrong happend please try again later ',
          statusCode: 500,
        );
      }
      final userData = await _getUserData(user.uid);

      if (userData.exists) {
        return UserModel.fromMap(userData.data()!);
      } else {
        await _createUserInDataBase(user, email);

        final userData = await _getUserData(user.uid);

        return UserModel.fromMap(userData.data()!);
      }
    } on ServerExpiton catch (_) {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw ServerExpiton(
        message: e.message ?? 'error occured',
        statusCode: e.code,
      );
    } catch (e) {
      throw ApiExpetion.createNewException(statusCode: 500);
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final usercred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await usercred.user?.updateDisplayName(fullName);

      await usercred.user?.updatePhotoURL(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/220px-User_icon_2.svg.png',
      );

      await _createUserInDataBase(_firebaseAuth.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerExpiton(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUser({
    required String currentPassword,
    String? fullName,
    String? email,
    String? password,
    String? bio,
    File? profilePic,
  }) async {
    try {
      final newData = <String, dynamic>{};
      final currentUser = _firebaseAuth.currentUser;

      final auth = await currentUser?.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: currentUser.email ?? email ?? '',
          password: currentPassword,
        ),
      );

      if (auth == null) {
        throw const ServerExpiton(message: 'wrong password ', statusCode: 500);
      }
      if (email != null) {
        await currentUser?.verifyBeforeUpdateEmail(email);

        newData['email'] = email;
      }

      if (password != null) {
        await currentUser?.updatePassword(password);
      }
      if (profilePic != null) {
        final ref = _firebaseStorage
            .ref()
            .child('profile_pics/${currentUser?.uid}-${DateTime.now()}');
        await ref.putFile(profilePic);
        final profilePicUrl = await ref.getDownloadURL();
        await currentUser?.updatePhotoURL(profilePicUrl);
        newData['profilePic'] = profilePicUrl;
      }
      if (fullName != null) {
        await currentUser?.updateDisplayName(fullName);
        newData['fullName'] = fullName;
      }
      if (bio != null) {
        newData['bio'] = bio;
      }

      await _updateUserData(newData);
    } on FirebaseAuthException catch (e) {
      throw ServerExpiton(
        message: e.message ??
            'something wrong happend while updateing please try again',
        statusCode: e.code,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String userId) async {
    try {
      final user = await _firestore.collection('users').doc(userId).get();

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _createUserInDataBase(User user, String email) async {
    await _firestore.collection('users').doc(user.uid).set(
          UserModel(
            fullName: user.displayName ?? '',
            email: email,
            uid: user.uid,
            point: 0,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      if (_firebaseAuth.currentUser == null) {
        throw const ServerExpiton(
          message: 'currntly no user singing in ',
          statusCode: 500,
        );
      }
      final userData = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .get();
      if (userData.exists == false) {
        throw const InformationalFailure(
          message: 'user data is not exist in database',
          statusCode: 500,
        );
      }
      final data = userData.data()!;
      data['uid'] = _firebaseAuth.currentUser?.uid;
      return UserModel.fromMap(data);
    } on FirebaseException catch (e) {
      throw ServerExpiton(
        message:
            e.message ?? 'something wrong happend while getting user data ',
        statusCode: e.code,
      );
    } catch (e) {
      rethrow;
    }
    //
  }
}
