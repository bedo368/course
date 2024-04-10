import 'dart:io';

import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';

abstract class AuthRepo {
  const AuthRepo();

  FutureResult<LocalUser> signIn({
    required String email,
    required String password,
  });

  FutureResult<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  FutureResult<void> forgetPassword(String email);

  FutureResult<void> updateUser({
    required String currentPassword,
    String? fullName,
    String? email,
    String? newPassword,
    String? bio,
    File? profilePic,
  });

  FutureResult<LocalUser> getUserData();
}
