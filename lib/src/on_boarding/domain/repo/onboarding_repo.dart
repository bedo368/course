import 'package:course_app/core/utils/typedef.dart';

abstract class OnBoardingRepo {
  const OnBoardingRepo();
  FutureResult<void> cacheFirstTimer();

  FutureResult<bool> checkIfUserIsFirstTime();
  
}
