import 'package:bloc/bloc.dart';
import 'package:course_app/src/on_boarding/usecases/cache_first_time.dart';
import 'package:course_app/src/on_boarding/usecases/check_if_user_is_first_teme.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._cacheFirstTime, this._checkIfUserIsFirstTime)
      : super(OnboardingInitial());

  final CacheFirstTime _cacheFirstTime;
  final CheckIfUserIsFirstTime _checkIfUserIsFirstTime;

  Future<void> checkIfuserFirstTime() async {
    emit(OnboardingCheckingIfUserFirstTimeState());
    final isFirstTime = await _checkIfUserIsFirstTime();

    isFirstTime.fold((l) => emit(OnboardingErrorState(message: l.message)),
        (r) {
      emit(OnboardingStatusState(isFirstTime: r));
    });
  }

  Future<void> cacheFirstTime() async {
    emit(OnboardingCachingFirstTime());

    final cacheing = await _cacheFirstTime();

    cacheing.fold(
      (l) => emit(const OnboardingStatusState(isFirstTime: true)),
      (r) {
        emit(OnboardingCached());
      },
    );
  }
}
