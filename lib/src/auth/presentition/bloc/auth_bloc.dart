import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';
import 'package:course_app/src/auth/usecases/forget_password.dart';
import 'package:course_app/src/auth/usecases/get_user_data.dart';
import 'package:course_app/src/auth/usecases/sign_in.dart';
import 'package:course_app/src/auth/usecases/sign_up.dart';
import 'package:course_app/src/auth/usecases/update_user.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required UpdateUserUseCases updateUserUseCase,
    required ForgetPasswordUseCases forgetPasswordUseCases,
    required GetUserDataUseCase getUserDataUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _updateUserUseCase = updateUserUseCase,
        _forgetPasswordUseCases = forgetPasswordUseCases,
        _getUserDataUseCase = getUserDataUseCase,
        super(AuthInitial()) {
    on<AuthSignInEvent>(_signIn);
    on<AuthSignUpEvent>(_signup);
    on<AuthUpdatUserEvent>(_updateUser);
    on<AuthForgetPasswordEvent>(_forgetPassword);
    on<AuthGetUserDataEvent>(_getUserData);
  }
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final UpdateUserUseCases _updateUserUseCase;
  final ForgetPasswordUseCases _forgetPasswordUseCases;
  final GetUserDataUseCase _getUserDataUseCase;

  late LocalUser? user;

  Future<void> _signIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthSignInStart());
    emit(AuthLoading());

    final result = await _signInUseCase(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold((l) => emit(AuthError(l.message)), (r) {
      emit(AuthSignInDone(user: r));
    });
  }

  Future<void> _signup(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthSignUpStart());
    emit(AuthLoading());
    final result = await _signUpUseCase(
      SignUpParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold((l) => emit(AuthError(l.message)), (r) {
      emit(AuthSignUpDone());
    });
  }

  Future<void> _updateUser(
    AuthUpdatUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUpdateUserStart());
    emit(AuthLoading());

    final result = await _updateUserUseCase(
      UpdateUserParams(
        email: event.email,
        bio: event.bio,
        password: event.password,
        newPassword: event.newPassword,
        profilePic: event.profilePic,
      ),
    );

    result.fold((l) => emit(AuthError(l.message)), (r) {
      emit(AuthUpdateUserDone());
      add(AuthGetUserDataEvent());
    });
  }

  Future<void> _forgetPassword(
    AuthForgetPasswordEvent event,
    Emitter<dynamic> emit,
  ) async {
    emit(AuthLoading());
    final result =
        await _forgetPasswordUseCases(ForgetPasswordParams(email: event.email));
    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthForgetPasswordDone()),
    );
  }

  Future<void> _getUserData(
    AuthGetUserDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthGetUserDataStart());
    emit(AuthLoading());

    final result = await _getUserDataUseCase();
    result.fold((l) => emit(AuthError(l.message)), (r) {
      emit(AuthGetUserDataDone(r));
    });
  }
}
