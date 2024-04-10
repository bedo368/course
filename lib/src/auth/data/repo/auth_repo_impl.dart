import 'dart:io';

import 'package:course_app/core/errors/failure.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';
import 'package:course_app/src/auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;
  @override
  FutureResult<void> forgetPassword(String email) async {
    try {
      await _remoteDataSource.forgetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(Failure.createNewFailure(error: e));
    }
  }

  @override
  FutureResult<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result =
          await _remoteDataSource.signIn(email: email, password: password);

      return Right(result);
    } catch (e) {
      return Left(Failure.createNewFailure(error: e));
    }
  }

  @override
  FutureResult<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      return const Right(null);
    } catch (e) {
      return Left(Failure.createNewFailure(error: e));
    }
  }

  @override
  FutureResult<void> updateUser({
    required String currentPassword,
    String? fullName,
    String? email,
    String? newPassword,
    String? bio,
    File? profilePic,
  }) async {
    try {
      if (fullName == null ||
          email == null &&
              newPassword == null &&
              bio == null &&
              profilePic == null) {
        return const Left(
          ParsingFailure('All fields are  empty please put some data'),
        );
      }
      await _remoteDataSource.updateUser(
        email: email,
        bio: bio,
        fullName: fullName,
        password: newPassword,
        profilePic: profilePic,
        currentPassword: currentPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure.createNewFailure(error: e));
    }
  }

  @override
  FutureResult<LocalUser> getUserData() async {
    try {
      final result = await _remoteDataSource.getUserData();

      return Right(result);
    } catch (e) {
      return Left(Failure.createNewFailure(error: e));
    }
  }
}
