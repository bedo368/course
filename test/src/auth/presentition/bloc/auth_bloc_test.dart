import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:course_app/core/errors/api_exeption.dart';
import 'package:course_app/core/errors/failure.dart';
import 'package:course_app/core/res/media_res.dart';
import 'package:course_app/src/auth/data/modules/user_model.dart';
import 'package:course_app/src/auth/presentition/bloc/auth_bloc.dart';
import 'package:course_app/src/auth/usecases/forget_password.dart';
import 'package:course_app/src/auth/usecases/get_user_data.dart';
import 'package:course_app/src/auth/usecases/sign_in.dart';
import 'package:course_app/src/auth/usecases/sign_up.dart';
import 'package:course_app/src/auth/usecases/update_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockUpateUserUseCase extends Mock implements UpdateUserUseCases {}

class MockForgetPasswordUseCases extends Mock
    implements ForgetPasswordUseCases {}

class MockGerUserDataUseCase extends Mock implements GetUserDataUseCase {}

void main() {
  late SignUpUseCase mockSignUpUse;
  late SignInUseCase mockSignInUse;
  late UpdateUserUseCases updateUserUseCases;
  late ForgetPasswordUseCases forgetPasswordUseCase;
  late GetUserDataUseCase getUserUseCase;
  late AuthBloc authBloc;

  registerFallbackValue(SignInParams.empty());
  registerFallbackValue(UpdateUserParams.empty());
  registerFallbackValue(SignUpParams.empty());
  setUp(
    () {
      mockSignUpUse = MockSignUpUseCase();
      mockSignInUse = MockSignInUseCase();
      updateUserUseCases = MockUpateUserUseCase();
      forgetPasswordUseCase = MockForgetPasswordUseCases();
      getUserUseCase = MockGerUserDataUseCase();
      authBloc = AuthBloc(
        signInUseCase: mockSignInUse,
        signUpUseCase: mockSignUpUse,
        updateUserUseCase: updateUserUseCases,
        forgetPasswordUseCases: forgetPasswordUseCase,
        getUserDataUseCase: getUserUseCase,
      );
    },
  );
  tearDown(() {
    authBloc.close();
  });
  group('sign in ', () {
    blocTest<AuthBloc, AuthState>(
      'test sign in success ',
      build: () {
        when(
          () => mockSignInUse(any()),
        ).thenAnswer((invocation) async => Right(UserModel.empty()));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignInEvent(email: 'email', password: 'password'),
      ),
      expect: () => <AuthState>[
        AuthSignInStart(),
        AuthLoading(),
        AuthSignInDone(user: UserModel.empty()),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'test sign in fail ',
      build: () {
        when(
          () => mockSignInUse(any()),
        ).thenAnswer(
          (invocation) async => Left(
            Failure.createNewFailure(
              error: const ServerExpiton(
                message: 'message',
                statusCode: 'statusCode',
              ),
            ),
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignInEvent(email: 'email', password: 'password'),
      ),
      expect: () => <AuthState>[
        AuthSignInStart(),
        AuthLoading(),
        const AuthError('message'),
      ],
    );
  });

  group('sign up ', () {
    blocTest<AuthBloc, AuthState>(
      'test sign up success ',
      build: () {
        when(
          () => mockSignUpUse(any()),
        ).thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUpEvent(
          email: 'email',
          password: 'password',
          fullName: 'fullName',
        ),
      ),
      expect: () =>
          <AuthState>[AuthSignUpStart(), AuthLoading(), AuthSignUpDone()],
    );

    blocTest<AuthBloc, AuthState>(
      'test sign up success ',
      build: () {
        when(
          () => mockSignUpUse(any()),
        ).thenAnswer(
          (invocation) async => Left(
            Failure.createNewFailure(
              error: const ServerExpiton(
                message: 'message',
                statusCode: 'statusCode',
              ),
            ),
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUpEvent(
          email: 'email',
          password: 'password',
          fullName: 'fullName',
        ),
      ),
      expect: () => <AuthState>[
        AuthSignUpStart(),
        AuthLoading(),
        const AuthError('message'),
      ],
    );
  });

  group('get user data ', () {
    blocTest<AuthBloc, AuthState>(
      'test when success ',
      build: () {
        when(
          () => getUserUseCase(),
        ).thenAnswer((invocation) async => Right(UserModel.empty()));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthGetUserDataEvent()),
      expect: () => <AuthState>[
        AuthGetUserDataStart(),
        AuthLoading(),
        AuthGetUserDataDone(UserModel.empty()),
      ],
    );
  });

  group('update user  data ', () {
    blocTest<AuthBloc, AuthState>(
      'test when success ',
      build: () {
        when(
          () => updateUserUseCases(any()),
        ).thenAnswer((invocation) async => const Right(null));
        when(
          () => getUserUseCase(),
        ).thenAnswer((invocation) async => Right(UserModel.empty()));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        AuthUpdatUserEvent(
          password: '',
          bio: '',
          email: '',
          profilePic: File(MediaRes.iconatoms),
          newPassword: '',
          fullName: '',
        ),
      ),
      expect: () => <AuthState>[
        AuthUpdateUserStart(),
        AuthLoading(),
        AuthUpdateUserDone(),
        AuthGetUserDataStart(),
        AuthLoading(),
        AuthGetUserDataDone(UserModel.empty()),
      ],
    );
  });
}
