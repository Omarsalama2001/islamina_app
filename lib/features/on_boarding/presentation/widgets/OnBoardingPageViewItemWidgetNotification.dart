import 'package:adhan/adhan.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';

import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Onboardingpageviewitemwidgetnotification extends StatelessWidget {
  const Onboardingpageviewitemwidgetnotification({super.key});

  Widget build(BuildContext context) {

    var controller = Get.find<PrayerTimeController>();

    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    // Build the UI
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              Get.context!.translate("notification"),
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 20.sp),
            ),
          ),
        ),
        ListTile(
          title: Text(
            context.translate('adhan_sound'),
            style: theme.textTheme.titleSmall!.copyWith(color: theme.primaryColor),
          ),
          dense: true,
        ),
        GetBuilder<PrayerTimeController>(
          init: PrayerTimeController(),
          builder: (controller) {
            return SwitchListTile(
              thumbIcon: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Icon(
                    Icons.notifications_active_outlined,
                    color: theme.primaryColorDark,
                  );
                } else {
                  return const Icon(Icons.notifications_off_outlined);
                }
              }),
              value: controller.showBeforePrayerSound,
              title: Text(
                context.translate('qurater_before_sound'),
                style: titleTextStyle,
              ),
              onChanged: (value) async {
                controller.showBeforePrayerSound = value;
                await controller.toggleShowBeforePrayerSound(value);
                PrayerTimeCache.saveBeforePrayerNotificationSound(showNotification: value);
                controller.update();
              },
            );
          },
        ),
        GetBuilder<PrayerTimeController>(
          init: PrayerTimeController(),
          builder: (controller) {
            return SwitchListTile(
              thumbIcon: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Icon(
                    Icons.notifications_active_outlined,
                    color: theme.primaryColorDark,
                  );
                } else {
                  return const Icon(Icons.notifications_off_outlined);
                }
              }),
              value: controller.showIqamahPrayerSound,
              title: Text(
                context.translate('qurater_before_sound'),
                style: titleTextStyle,
              ),
              onChanged: (value) async {
                controller.showIqamahPrayerSound = value;
                await controller.toggleShowIqamahPrayerSound(value);
                PrayerTimeCache.saveIqamahPrayerNotificationSound(showNotification: value);
                controller.update();
              },
            );
          },
        ),
        GetBuilder<PrayerTimeController>(
          init: PrayerTimeController(),
          builder: (controller) {
            return SwitchListTile(
              thumbIcon: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Icon(
                    Icons.notifications_active_outlined,
                    color: theme.primaryColorDark,
                  );
                } else {
                  return const Icon(Icons.notifications_off_outlined);
                }
              }),
              value: controller.isTakbertan,
              title: Text(
                context.translate("two_takbirs"),
                style: titleTextStyle,
              ),
              onChanged: (value) async {
                controller.isTakbertan = value;
                await controller.toggleShowPrayerSound(value);
                // PrayerTimeCache.savePrayerNotificationMode(prayer: prayer, notificationMode: value);
                // controller.update();
              },
            );
          },
        ),
        const Divider(),
        ListTile(
          title: Text(
             context.translate('prayers_alert'),
            style: theme.textTheme.titleSmall!.copyWith(color: theme.primaryColor),
          ),
          dense: true,
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: Prayer.values.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const SizedBox();
            }
            var prayer = Prayer.values[index];
            var isNotificationEnabled = PrayerTimeCache.getPrayerNotificationMode(prayer: prayer);

            return Obx(() {
              return SwitchListTile(
                thumbIcon: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Icon(
                      Icons.notifications_active_outlined,
                      color: theme.primaryColorDark,
                    );
                  } else {
                    return const Icon(Icons.notifications_off_outlined);
                  }
                }),
                value: isNotificationEnabled.value,
                title: Text(
                BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? controller.repository.getPrayerNameArabic(prayer: Prayer.values[index]) :  controller.repository.getPrayers()[index-1].englishName,
                  style: titleTextStyle,
                ),
                onChanged: (value) {
                  isNotificationEnabled.value = value;
                  PrayerTimeCache.savePrayerNotificationMode(prayer: prayer, notificationMode: value);
                  controller.update();
                },
              );
            });
          },
        ),
      ],
    );
  }
}
