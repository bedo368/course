import 'package:course_app/core/common/widgets/gradient_background.dart';
import 'package:course_app/core/common/widgets/loading_views.dart';
import 'package:course_app/core/res/colors.dart';
import 'package:course_app/core/res/fonts.dart';
import 'package:course_app/core/res/media_res.dart';
import 'package:course_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:course_app/src/on_boarding/presentation/cubit/onboarding_cubit.dart';
import 'package:course_app/src/on_boarding/presentation/views/widgets/on_boarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  static const routeName = '/onboarding';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackGround(
        image: MediaRes.imageOnBoardingBackground,
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingStatusState && !state.isFirstTime) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state is OnboardingCached) {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
          builder: (_, state) {
            if (state is OnboardingCheckingIfUserFirstTimeState ||
                state is OnboardingCachingFirstTime) {
              return const LoadingViews();
            }
            return Stack(
              children: [
                PageView(
                  controller: controller,
                  children: const [
                    OnBoardingBody(pageContent: PageContent.first()),
                    OnBoardingBody(pageContent: PageContent.second()),
                    OnBoardingBody(pageContent: PageContent.thired()),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, .04),
                  child: SmoothPageIndicator(
                    effect: const WormEffect(
                      spacing: 15,
                      activeDotColor: Colours.primaryColor,
                      dotColor: Colors.white,
                    ),
                    controller: controller,
                    count: 3,
                    onDotClicked: (index) => controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, .8),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<OnboardingCubit>().cacheFirstTime();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 17,
                      ),
                      backgroundColor: context.theme.primaryColor,
                    ),
                    child: const Text(
                      'Get Started ',
                      style: TextStyle(
                        fontFamily: Fonts.aeonik,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
