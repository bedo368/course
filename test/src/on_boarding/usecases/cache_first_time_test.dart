// ignore_for_file: inference_failure_on_instance_creation

import 'package:course_app/core/errors/failure.dart';
import 'package:course_app/src/on_boarding/domain/repo/onboarding_repo.dart';
import 'package:course_app/src/on_boarding/usecases/cache_first_time.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boaring_repo_mock.dart';


void main() {
  late OnBoardingRepo repo;
  late CacheFirstTime usecase;
  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTime(repo);
  });

  group('test CacheFirstTime useCasee ', () {
    test('test success state ', () async {
      // arrange
      when(() => repo.cacheFirstTimer())
          .thenAnswer((invocation) async => const Right(null));

      // act
      final result = await usecase();
      expect(result, const Right(null));
    });

    test('test fail state ', () async {
      // arrange
      when(() => repo.cacheFirstTimer()).thenAnswer(
        (invocation) async => Left(
          Failure.createNewFailure(error: ''),
        ),
      );

      // act
      final result = await usecase();
      expect(
        result,
        Left(
          Failure.createNewFailure(error: ''),
        ),
      );
    });
  });
}
