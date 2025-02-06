import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/pages/prayer_time_page.dart';
import '../controllers/home_controller.dart';
import 'main_page.dart';
import 'more_activities_page.dart';
import 'quran_main_dashborad_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: [
          MainPage(),
          QuranMainDashboradPage(),
          PrayerTimePage(),
          MoreActivitiesPage(),
        ][controller.selectedDestination.value],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (value) {
            controller.onDestinationChanged(value);
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: controller.selectedDestination.value,
          destinations: [
            NavigationDestination(
              icon: const Icon(FluentIcons.home_24_regular),
              selectedIcon: const Icon(FluentIcons.home_24_filled),
              label: Get.context!.translate('home'),
            ),
            NavigationDestination(
              icon: Icon(FluentIcons.book_24_regular),
              selectedIcon: Icon(FluentIcons.book_24_filled),
              label: Get.context!.translate('quran'),
            ),
            NavigationDestination(
              icon: Icon(FluentIcons.clock_24_regular),
              selectedIcon: Icon(FluentIcons.clock_24_filled),
              label: Get.context!.translate('prayerTimes'),
            ),
            NavigationDestination(
              icon: Icon(FluentIcons.more_circle_24_regular),
              selectedIcon: Icon(FluentIcons.more_circle_24_filled),
              label: Get.context!.translate('more'),
            ),
          ],
        ),
      );
    });
  }
}
