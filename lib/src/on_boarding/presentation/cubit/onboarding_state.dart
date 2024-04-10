part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingCachingFirstTime extends OnboardingState {}

final class OnboardingCached extends OnboardingState {}

final class OnboardingCheckingIfUserFirstTimeState extends OnboardingState {}

final class OnboardingErrorState extends OnboardingState {
  const OnboardingErrorState({required this.message});
  final String message;

  @override
  List<String> get props => [message];
}

final class OnboardingStatusState extends OnboardingState {
  const OnboardingStatusState({required this.isFirstTime});
  final bool isFirstTime;

  @override
  List<bool> get props => [isFirstTime];
}
