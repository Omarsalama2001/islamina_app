import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:islamina_app/core/extensions/media_query_extension.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:islamina_app/features/on_boarding/presentation/widgets/OnBoardingPageViewItemWidgetNotification.dart';
import 'package:islamina_app/features/on_boarding/presentation/widgets/on_boarding_pageview_item_widget.dart';

// ignore: must_be_immutable
class OnBoardingPageViewWidget extends StatelessWidget {
  const OnBoardingPageViewWidget({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getHight(divide: 0.55),
      width: double.infinity,
      child: PageView(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (value) {
          BlocProvider.of<OnBoardingCubit>(context).changeOnBoardingPage(value);
        },
        children: [
         
      OnBoardingPageViewItemWidgetLanguage(image: 'assets/images/onboarding.png', title: "Raw Material", subtitle: context.translate("Do you want to buy raw materials ?")),
      Onboardingpageviewitemwidgetnotification()
       ],
      ),
    );
  }
}
