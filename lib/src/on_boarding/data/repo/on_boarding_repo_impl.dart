import 'package:course_app/core/errors/failure.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/on_boarding/datasources/on_boarding_local_data_source.dart';
import 'package:course_app/src/on_boarding/domain/repo/onboarding_repo.dart';
import 'package:dartz/dartz.dart';

class OnBoardingRepoImpl implements OnBoardingRepo {
  const OnBoardingRepoImpl(this._onBoardingdLocalataSource);
  final OnBoardingLocalDataSource _onBoardingdLocalataSource;
  @override
  FutureResult<void> cacheFirstTimer() async {
    try {
      await _onBoardingdLocalataSource.cacheFirstTiem();

      return const Right(null);
    } catch (e) {
      return Left(Failure.createNewFailure(error: e));
    }
  }

  @override
  FutureResult<bool> checkIfUserIsFirstTime() async {
    try {
      final isFirstTime =
          await _onBoardingdLocalataSource.checkIfUserFirstTime();

      return Right(isFirstTime);
    } catch (e) {
      return Left(Failure.createNewFailure(error: e));
    }
  }
}
