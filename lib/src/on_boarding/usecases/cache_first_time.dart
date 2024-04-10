import 'package:course_app/core/usecase/usecase.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/on_boarding/domain/repo/onboarding_repo.dart';

class CacheFirstTime extends UseCaseswithOutParams<void> {

  
  CacheFirstTime(this._repo);
  final OnBoardingRepo _repo;
  @override
  FutureResult<void> call() async => _repo.cacheFirstTimer();
}
