part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignInEvent extends AuthEvent {
  const AuthSignInEvent({required this.email, required this.password});
  final String email;
  final String password;
}

class AuthForgetPasswordEvent extends AuthEvent {
  const AuthForgetPasswordEvent({
    required this.email,
  });
  final String email;
}

class AuthGetUserDataEvent extends AuthEvent {}

class AuthSignUpEvent extends AuthEvent {
  const AuthSignUpEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });
  final String email;
  final String password;
  final String fullName;
}

class AuthUpdatUserEvent extends AuthEvent {
  const AuthUpdatUserEvent({
    required this.password,
    this.email,
    this.fullName,
    this.newPassword,
    this.bio,
    this.profilePic,
  });
  final String password;
  final String? newPassword;
  final String? email;
  final String? bio;
  final String? fullName;
  final File? profilePic;
}
