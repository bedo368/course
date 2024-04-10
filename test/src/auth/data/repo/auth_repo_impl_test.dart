import 'package:course_app/core/errors/api_exeption.dart';
import 'package:course_app/core/errors/failure.dart';
import 'package:course_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:course_app/src/auth/data/modules/user_model.dart';
import 'package:course_app/src/auth/data/repo/auth_repo_impl.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';
import 'package:course_app/src/auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSourse extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource dataSource;
  late AuthRepo authRepo;
  setUp(() {
    dataSource = MockRemoteDataSourse();
    authRepo = AuthRepoImpl(dataSource);
  });

  group('test sign up ', () {
    test('sign up sucess ', () async {
      // arragne
      when(
        () => dataSource.signUp(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((invocation) async => Future.value());

      // act
      final result = await authRepo.signUp(
        email: 'fdfsf',
        fullName: 'fdsf',
        password: 'fdsf',
      );

      expect(result, const Right<dynamic, void>(null));
    });

    test('sign up fail ', () async {
      // arrange
      when(
        () => dataSource.signUp(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Error());

      // act
      final result = await authRepo.signUp(
        email: 'fdfsf',
        fullName: 'fdsf',
        password: 'fdsf',
      );

      expect(
        result,
        Left<Failure, dynamic>(Failure.createNewFailure(error: Error())),
      );
    });
  });

  group('test sign in ', () {
    test('sign up sucess ', () async {
      // arragne
      when(
        () => dataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((invocation) async => UserModel.empty());

      // act
      final result = await authRepo.signIn(
        email: 'fdfsf',
        password: 'fdsf',
      );

      expect(result, Right<dynamic, UserModel>(UserModel.empty()));
    });

    test('sign up fail ', () async {
      // arrange
      when(
        () => dataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Error());

      // act
      final result = await authRepo.signIn(
        email: 'fdfsf',
        password: 'fdsf',
      );

      expect(
        result,
        Left<Failure, dynamic>(Failure.createNewFailure(error: Error())),
      );
    });
  });

  group('test update user  ', () {
    test('update sucess ', () async {
      // arragne
      when(
        () => dataSource.updateUser(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
          bio: any(named: 'bio'),
          profilePic: any(named: 'profilePic'),
          currentPassword: any(named: 'currentPassword'),
        ),
      ).thenAnswer((invocation) async => Future.value());

      // act
      final result = await authRepo.updateUser(
        email: '',
        fullName: '',
        newPassword: '',
        currentPassword: '',
      );

      expect(result, const Right<dynamic, void>(null));
    });

    test('update fail ', () async {
      // arrange
      when(
        () => dataSource.updateUser(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
          bio: any(named: 'bio'),
          profilePic: any(named: 'profilePic'),
          currentPassword: any(named: 'currentPassword'),
        ),
      ).thenThrow(Error());

      // act
      final result = await authRepo.signUp(
        email: 'fdfsf',
        fullName: 'fdsf',
        password: 'fdsf',
      );

      expect(
        result,
        Left<Failure, dynamic>(Failure.createNewFailure(error: Error())),
      );
    });
  });

  group('get user data ', () {
    test('get user Data success', () async {
      when(
        () => dataSource.getUserData(),
      ).thenAnswer((invocation) async => UserModel.empty());

      final result = await authRepo.getUserData();
      expect(result, Right<Failure, LocalUser>(UserModel.empty()));
    });
    test('get user Data fail', () async {
      when(
        () => dataSource.getUserData(),
      ).thenThrow(const ServerExpiton(message: 'worg', statusCode: 500));

      final result = await authRepo.getUserData();
      expect(
        result,
        Left<Failure, dynamic>(
          Failure.createNewFailure(
            error: const ServerExpiton(message: 'worg', statusCode: 500),
          ),
        ),
      );
    });
  });
}
