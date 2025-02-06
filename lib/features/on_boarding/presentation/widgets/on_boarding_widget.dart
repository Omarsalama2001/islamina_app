import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:islamina_app/core/extensions/media_query_extension.dart';

import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/app_colors.dart';
import 'package:islamina_app/features/auth/presentation/pages/login_page.dart';
import 'package:islamina_app/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:islamina_app/features/on_boarding/presentation/widgets/custom_skip_button_widget.dart';
import 'package:islamina_app/features/on_boarding/presentation/widgets/main_button_widget.dart';
import 'package:islamina_app/features/on_boarding/presentation/widgets/on_boarding_pageview_widet.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingWidget extends StatelessWidget {
  OnBoardingWidget({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: OnBoardingPageViewWidget(pageController: pageController)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    effect: ExpandingDotsEffect(activeDotColor: Get.theme.primaryColor, radius: 5.sp, strokeWidth: 1.5.sp, spacing: 10.sp),
                    controller: pageController,
                    count: 2,
                  ),
                  BlocBuilder<OnBoardingCubit, OnBoardingState>(
                    builder: (context, state) {
                      int pageNumber = 0;
                      if (state is OnBoardingPageChangedState) {
                        pageNumber = state.pageNumber;
                      }
                      return MainButtonWidget(
                        hight: context.getHight(divide: 0.06),
                        width: context.getWidth(divide: 0.4),
                        text: pageNumber != 1 ? context.translate("next") : context.translate("getStarted"),
                        onPressed: () {
                          if (pageNumber != 1) {
                            pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.linearToEaseOut);
                          } else {
                            BlocProvider.of<OnBoardingCubit>(context).setOnboardingEnded();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
