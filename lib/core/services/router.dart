import 'package:course_app/core/common/views/page_under_construction.dart';
import 'package:course_app/core/common/widgets/gradient_background.dart';
import 'package:course_app/core/extinsions/context_extintion.dart';
import 'package:course_app/core/res/media_res.dart';
import 'package:course_app/core/services/injection_container_imports.dart';
import 'package:course_app/src/auth/data/modules/user_model.dart';
import 'package:course_app/src/auth/presentition/bloc/auth_bloc.dart';
import 'package:course_app/src/auth/presentition/views/screens/sign_in_screen.dart';
import 'package:course_app/src/auth/presentition/views/screens/sign_up_screen.dart';
import 'package:course_app/src/dashboard/views/screen/dashboard.dart';
import 'package:course_app/src/on_boarding/datasources/on_boarding_local_data_source.dart';
import 'package:course_app/src/on_boarding/presentation/cubit/onboarding_cubit.dart';
import 'package:course_app/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case DashBoardScreen.reoute:
      return _pageBuilder((p0) => const DashBoardScreen(), settings: settings);

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
