part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthSignUpStart extends AuthState {}

final class AuthSignUpDone extends AuthState {}

final class AuthSignInStart extends AuthState {}

final class AuthSignInDone extends AuthState {
  const AuthSignInDone({required this.user});
  final LocalUser user;
}

final class AuthUpdateUserStart extends AuthState {}

final class AuthUpdateUserDone extends AuthState {}

final class AuthForgetPasswordDone extends AuthState {}

final class AuthGetUserDataDone extends AuthState {
  const AuthGetUserDataDone(this.user);
  final LocalUser user;
}

final class AuthGetUserDataStart extends AuthState {}

final class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;

  @override
  List<String> get props => [message];
}

final class AuthLoading extends AuthState {}
