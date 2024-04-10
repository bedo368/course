part of 'injection_container_imports.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _onBoardingError();
  await _authInit();
}

Future<void> _authInit() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        updateUserUseCase: sl(),
        forgetPasswordUseCases: sl(),
        getUserDataUseCase: sl(),
      ),
    )
    ..registerLazySingleton(() => SignUpUseCase(sl()))
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => UpdateUserUseCases(sl()))
    ..registerLazySingleton(() => ForgetPasswordUseCases(sl()))
    ..registerLazySingleton(() => GetUserDataUseCase(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceIpl(sl(), sl(), sl()),
    )
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance);
}

Future<void> _onBoardingError() async {
  sl
    ..registerFactory(() => OnboardingCubit(sl(), sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTime(sl()))
    ..registerLazySingleton(() => CacheFirstTime(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<HiveInterface>(() => Hive);
}
