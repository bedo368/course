import 'package:course_app/core/usecase/usecase.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/domain/repo/auth_repo.dart';

class ForgetPasswordUseCases
    extends UseCaseswithParams<void, ForgetPasswordParams> {
  ForgetPasswordUseCases(this._repo);
  final AuthRepo _repo;
  @override
  FutureResult<void> call(ForgetPasswordParams parmas) =>
      _repo.forgetPassword(parmas.email);
}

class ForgetPasswordParams {
  const ForgetPasswordParams({required this.email});
  final String email;
}
