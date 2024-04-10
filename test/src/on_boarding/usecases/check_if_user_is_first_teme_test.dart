// ignore_for_file: inference_failure_on_instance_creation

import 'package:course_app/core/errors/failure.dart';
import 'package:course_app/src/on_boarding/domain/repo/onboarding_repo.dart';
import 'package:course_app/src/on_boarding/usecases/check_if_user_is_first_teme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boaring_repo_mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTime useCase;

  setUp(() {
    repo = MockOnBoardingRepo();
    useCase = CheckIfUserIsFirstTime(repo);
  });

  group('test checkIfUserFirstLog', () {
    test('should return true if user is first time', () async {
      // arrange
      when(repo.checkIfUserIsFirstTime)
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await useCase();
      expect(result, const Right(true));
    });

    test('should return false  if user is not first time', () async {
      // arrange
      when(repo.checkIfUserIsFirstTime)
          .thenAnswer((_) async => const Right(false));

      // act
      final result = await useCase();
      expect(result, const Right(false));
    });

    test(' check when failure ', () async {
      // arrange
      when(repo.checkIfUserIsFirstTime)
          .thenAnswer((_) async => Left(Failure.createNewFailure(error: '')));

      // act
      final result = await useCase();
      expect(result, Left(Failure.createNewFailure(error: '')));
    });
  });
}
