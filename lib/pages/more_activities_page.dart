import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:islamina_app/constants/all_activites.dart';
import 'package:islamina_app/pages/app_settings_page.dart';

import '../../../widgets/custom_button_big_icon.dart';
import '../controllers/more_activities_controller.dart';

class MoreActivitiesPage extends GetView<MoreActivitiesController> {
  const MoreActivitiesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text($strings.moreActivities),
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const AppSettingsPage());
              },
              icon: const Icon(FluentIcons.settings_16_regular))
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 75.h > 100.w ? 80.w / 3 : 80.w / 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        padding: const EdgeInsets.all(8.0),
        itemCount: Activites.activities.length,
        itemBuilder: (context, index) {
          return CustomButtonBigIcon(
            text: Activites.activities[index]['text'],
            iconData: Activites.activities[index]['icon'],
            onTap: Activites.activities[index]['onTap'],
          );
        },
      ),
    );
  }
}
