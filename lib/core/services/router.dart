part of 'router_import.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final hive = sl<HiveInterface>();
      final onBoardingbox = hive.openBox<dynamic>(hiveOnboardingBox);

      return _pageBuilder(
        (context) {
          final user = sl<FirebaseAuth>().currentUser;
          if (user != null) {
            final userModel = UserModel(
              fullName: user.displayName ?? '',
              email: user.email ?? '',
              uid: user.uid,
              point: 0,
            );
            context.userProvider.initUser(userModel);
          }

          return FutureBuilder(
            future: onBoardingbox,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final firstTime = snapshot.data?.get('firstTime');
                if (firstTime == null) snapshot.data?.put('firstTime', true);
                if (firstTime == true || firstTime == null) {
                  return BlocProvider(
                    create: (_) => sl<OnboardingCubit>(),
                    child: const OnBoardingScreen(),
                  );
                } else {
                  if (user == null) {
                    return BlocProvider(
                      create: (context) => sl<AuthBloc>(),
                      child: const SignInScreen(),
                    );
                  } else {
                    return const DashBoardScreen();
                  }
                }
              }

              return Scaffold(
                body: GradientBackGround(
                  image: MediaRes.imageOnBoardingBackground,
                  child: Container(),
                ),
              );
            },
          );
        },
        settings: settings,
      );

    case SignInScreen.route:
      return _pageBuilder(
        (p0) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpScreen.route:
      return _pageBuilder(
        (p0) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case DashBoardScreen.reoute:
      return _pageBuilder((p0) => const DashBoardScreen(), settings: settings);
    case '/forgot-password':
      return _pageBuilder(
        (p0) => const firebaseui.ForgotPasswordScreen(),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
