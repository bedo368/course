// ignore_for_file: inference_failure_on_instance_creation, strict_raw_type, inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'package:course_app/core/errors/cache_exeption.dart';
import 'package:course_app/src/on_boarding/datasources/on_boarding_local_data_source.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHive extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<dynamic> {}

void main() {
  late HiveInterface hive;
  late OnBoardingLocalDataSource dataSource;
  late Box<dynamic> box;
  setUp(() {
    hive = MockHive();
    dataSource = OnBoardingLocalDataSourceImpl(hive);
    box = MockHiveBox();
  });
  group('test onboarding datasource impl : cache first time ', () {
    test('test if success ', () async {
      when(() => hive.openBox(any()))
          .thenAnswer((_) async => Future.value(box));

      when(
        () => box.put(firstTime, any()),
      ).thenAnswer((invocation) async => Future.value());

      // act

      await dataSource.cacheFirstTiem();
      // assert

      verify(
        () => box.put(firstTime, false),
      );
    });

    test('test if fail ', () async {
      when(() => hive.openBox(any()))
          .thenAnswer((_) async => Future.value(box));

      when(
        () => box.put(firstTime, any()),
      ).thenThrow(CacheException.createNewException());

      // act
      final method = dataSource.cacheFirstTiem;

      // assert
      expect(method, throwsA(isA<CacheException>()));
    });
  });

  group('check if user first time : ', () {
    test('user first time  is true', () async {
      when(() => hive.openBox(any()))
          .thenAnswer((_) async => Future.value(box));

      when(
        () => box.get(
          any(),
        ),
      ).thenAnswer((_) => null);

      // act
      final method = await dataSource.checkIfUserFirstTime();

      // assert
      expect(method, true);
    });

    test('user first time  is false ', () async {
      when(() => hive.openBox(any()))
          .thenAnswer((_) async => Future.value(box));

      when(
        () => box.get(
          any(),
        ),
      ).thenAnswer((_) => false);

      // act
      final method = await dataSource.checkIfUserFirstTime();

      // assert
      expect(method, false);
    });

    test('fail  ', () async {
      when(() => hive.openBox(any()))
          .thenAnswer((_) async => Future.value(box));

      when(
        () => box.get(
          any(),
        ),
      ).thenThrow(CacheException.createNewException());

      // act
      final method = dataSource.checkIfUserFirstTime;

      // assert
      expect(method, throwsA(isA<CacheException>()));
    });
  });
}
