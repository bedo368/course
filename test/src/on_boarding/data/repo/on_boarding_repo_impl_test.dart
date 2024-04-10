import 'package:course_app/core/errors/cache_exeption.dart';
import 'package:course_app/core/errors/failure.dart';
import 'package:course_app/src/on_boarding/data/repo/on_boarding_repo_impl.dart';
import 'package:course_app/src/on_boarding/datasources/on_boarding_local_data_source.dart';
import 'package:course_app/src/on_boarding/domain/repo/onboarding_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource dataSource;
  late OnBoardingRepo repo;

  setUp(() {
    dataSource = MockOnBoardingDataSource();
    repo = OnBoardingRepoImpl(dataSource);
  });

  group('test onboarding repo impl cache first tiem :  ', () {
    test('on sucess state ', () async {
      // arrange
      when(
        () => dataSource.cacheFirstTiem(),
      ).thenAnswer((invocation) => Future.value());

      final result = await repo.cacheFirstTimer();

      expect(result, const Right<dynamic, void>(null));
    });
    test('on fail state ', () async {
      // arrange
      when(
        () => dataSource.cacheFirstTiem(),
      ).thenThrow(Failure.createNewFailure(error: ''));

      final result = await repo.cacheFirstTimer();

      expect(
        result,
        Left<Failure, dynamic>(Failure.createNewFailure(error: '')),
      );
    });
  });

  group('test repo impl check user first time ', () {
    test('on sucess state : and the user first time ', () async {
      // arrange
      when(
        () => dataSource.checkIfUserFirstTime(),
      ).thenAnswer((invocation) async => true);

      final result = await repo.checkIfUserIsFirstTime();

      expect(result, const Right<Failure, bool>(true));
    });

    test('on sucess state : and the user not first time ', () async {
      // arrange
      when(
        () => dataSource.checkIfUserFirstTime(),
      ).thenAnswer((invocation) async => false);

      final result = await repo.checkIfUserIsFirstTime();

      expect(result, const Right<Failure, bool>(false));
    });

    test('on fail  state :  ', () async {
      // arrange
      when(
        () => dataSource.checkIfUserFirstTime(),
      ).thenThrow(CacheException.createNewException());

      final result = await repo.checkIfUserIsFirstTime();

      expect(
        result,
        Left<Failure, bool>(
          Failure.createNewFailure(error: CacheException.createNewException()),
        ),
      );
    });
  });
}
