import 'package:course_app/core/common/widgets/gradient_background.dart';
import 'package:course_app/core/res/media_res.dart';
import 'package:course_app/core/utils/app_utls.dart';
import 'package:course_app/src/auth/presentition/bloc/auth_bloc.dart';
import 'package:course_app/src/auth/presentition/views/screens/sign_in_screen.dart';
import 'package:course_app/src/auth/presentition/views/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const route = '/signup';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confermPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppUtils.showSnackBar(
                context: context, message: state.message, error: true,);
          } else if (state is AuthSignUpDone) {
            Navigator.pushReplacementNamed(context, SignInScreen.route);
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
                        'Sign up new account ... ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600,),
                      ),
                      Baseline(
                        baseline: 80,
                        baselineType: TextBaseline.alphabetic,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, SignInScreen.route);
                          },
                          child: const Text(
                            'Have account ? ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SignUpForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    confermPasswordController: confermPasswordController,
                    fullNameController: fullNameController,
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
