import 'package:course_app/core/usecase/usecase.dart';
import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';
import 'package:course_app/src/auth/domain/repo/auth_repo.dart';

class GetUserDataUseCase extends UseCaseswithOutParams<LocalUser> {
  GetUserDataUseCase(this._repo);
  final AuthRepo _repo;
  @override
  FutureResult<LocalUser> call() => _repo.getUserData();
}
