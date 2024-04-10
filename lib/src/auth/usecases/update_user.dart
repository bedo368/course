import 'dart:io';

import 'package:course_app/core/res/media_res.dart';
import 'package:course_app/core/usecase/usecase.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/domain/repo/auth_repo.dart';

class UpdateUserUseCases extends UseCaseswithParams<void, UpdateUserParams> {
  UpdateUserUseCases(this._authRepo);
  final AuthRepo _authRepo;
  @override
  FutureResult<void> call(UpdateUserParams parmas) => _authRepo.updateUser(
        currentPassword: parmas.password,
        email: parmas.email,
        newPassword: parmas.newPassword,
        bio: parmas.bio,
        profilePic: parmas.profilePic,
      );
}

class UpdateUserParams {
  UpdateUserParams({
    required this.password,
    this.fullname,
    this.email,
    this.bio,
    this.newPassword,
    this.profilePic,
  });
  UpdateUserParams.empty()
      : this(
          password: '',
          email: '',
          profilePic: File(MediaRes.iconatoms),
          newPassword: '',
          bio: '',
          fullname: '',
        );

  String? fullname;
  String? email;
  String password;
  String? newPassword;
  String? bio;
  File? profilePic;
}
