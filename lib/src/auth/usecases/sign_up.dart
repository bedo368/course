import 'package:course_app/core/usecase/usecase.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/domain/repo/auth_repo.dart';

class SignUpUseCase extends UseCaseswithParams<void, SignUpParams> {
  SignUpUseCase(this._repo);
  final AuthRepo _repo;
  @override
  FutureResult<void> call(SignUpParams parmas) => _repo.signUp(
        email: parmas.email,
        fullName: parmas.fullName,
        password: parmas.password,
      );
}

class SignUpParams {
  const SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });
  SignUpParams.empty() : this(password: '', email: '', fullName: '');
  final String fullName;
  final String email;
  final String password;
}
