import 'package:flutter/material.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';

class QuranTabBar extends StatelessWidget {
  const QuranTabBar(
      {super.key, required this.onTap, required this.tabController});
  final TabController tabController;
  final Function(int)? onTap;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      onTap: onTap,
      splashBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      tabs:  [
        Tab(
          text:context.translate('noOfTheSurah') ,
        ),
        Tab(
          text: context.translate('noOfTheJuz') ,
        ),
        Tab(
          text: context.translate('noOfTheHizb') ,
        ),
      ],
    );
  }
}
