import 'package:course_app/core/usecase/usecase.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/on_boarding/domain/repo/onboarding_repo.dart';

class CheckIfUserIsFirstTime extends UseCaseswithOutParams<bool> {
  CheckIfUserIsFirstTime(this._repo);
  final OnBoardingRepo _repo;
  @override
  FutureResult<bool> call() async => _repo.checkIfUserIsFirstTime();
}
