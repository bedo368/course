// ignore_for_file: inference_failure_on_function_invocation

import 'package:course_app/core/errors/cache_exeption.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class OnBoardingLocalDataSource {
  OnBoardingLocalDataSource();
  Future<void> cacheFirstTiem();
  Future<bool> checkIfUserFirstTime();
}

const String firstTime = 'firstTime';
const hiveOnboardingBox = 'onboarding';

class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource {
  OnBoardingLocalDataSourceImpl(this._hive);
  final HiveInterface _hive;

  @override
  Future<void> cacheFirstTiem() async {
    try {
      final box = await _hive.openBox(hiveOnboardingBox);
      await box.put(firstTime, false);
    } catch (e) {
      throw CacheException.createNewException();
    }
  }

  @override
  Future<bool> checkIfUserFirstTime() async {
    try {
      final box = await _hive.openBox(hiveOnboardingBox);
      final firsttime = box.get(firstTime);

      if (firsttime == null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw CacheException.createNewException();
    }
  }
}
