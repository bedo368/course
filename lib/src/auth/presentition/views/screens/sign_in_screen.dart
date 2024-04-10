import 'package:course_app/core/common/widgets/gradient_background.dart';
import 'package:course_app/core/extinsions/context_extintion.dart';
import 'package:course_app/core/res/media_res.dart';
import 'package:course_app/core/utils/app_utls.dart';
import 'package:course_app/src/auth/presentition/bloc/auth_bloc.dart';
import 'package:course_app/src/auth/presentition/views/screens/sign_up_screen.dart';
import 'package:course_app/src/auth/presentition/views/widgets/sign_in_form.dart';
import 'package:course_app/src/dashboard/views/screen/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const route = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppUtils.showSnackBar(
                context: context, message: state.message, error: true,);
          } else if (state is AuthSignInDone) {
            context.userProvider.initUser(state.user);
            Navigator.pushReplacementNamed(context, DashBoardScreen.reoute);
          }
        },
        builder: (context, state) {
          return GradientBackGround(
            image: MediaRes.imageAuthGradientBackground,
            child: SafeArea(
                child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Easy to learn Fun to Explore ',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'sign in to your account ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Baseline(
                        baseline: 80,
                        baselineType: TextBaseline.alphabetic,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpScreen.route);
                          },
                          child: const Text(
                            'Regiter account? ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SignInForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    formKey: formKey,
                  ),
                ],
              ),
            ),),
          );
        },
      ),
    );
  }
}
