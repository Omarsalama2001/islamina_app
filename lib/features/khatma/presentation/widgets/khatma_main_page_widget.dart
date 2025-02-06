import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/media_query_extension.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/all_khatma_widget.dart';

import 'package:islamina_app/features/khatma/presentation/widgets/done_khatma_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class KhatmaMainPageWidget extends StatelessWidget {
  KhatmaMainPageWidget({super.key});

  final PageController pageController = PageController();

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonsTabBar(backgroundColor: context.theme.primaryColor, duration: 0, contentCenter: true, width: context.getWidth(divide: 0.4), labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.white), elevation: 5.sp, contentPadding: EdgeInsets.all(10.sp), unselectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.black), tabs:  [
                Tab(
                  text: context.translate("createdKhatma"),
                ),
                Tab(
                  text:  context.translate("finishedKhatma"),
                ),
              ]),
            ),
            const Expanded(
                child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[AllKhatmaWidget(), DoneKhatmaWidget()],
            ))
          ]),
        ),
      ),
    );
  }
}
