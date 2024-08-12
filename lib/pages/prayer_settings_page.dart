import 'package:adhan/adhan.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/handlers/notification_alarm_handler.dart';
import 'package:islamina_app/pages/calc_method_selector_page.dart';
import 'package:islamina_app/utils/dialogs/select_madhab_dialog.dart';

import '../constants/constants.dart';
import '../controllers/prayer_time_controller.dart';

class PrayerSettingsPage extends GetView {
  const PrayerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PrayerTimeController>();

    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    // Build the UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات أوقات الصلاة'),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'طرق الحساب',
              style: theme.textTheme.titleSmall!.copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          ListTile(
            onTap: () {
              Get.to(() => const CalculationMethodSelectorPage());
            },
            dense: true,
            title: Text(
              'طريقة الحساب',
              style: titleTextStyle,
            ),
            subtitle: Text(
                calculationMethodList[PrayerTimeCache.getCalculationMethodFromCache().index]
                    ['title'],
                style: subtitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.dialog(const MadhabSelectionDialog());
            },
            dense: true,
            title: Text(
              'طريقة حساب العصر',
              style: titleTextStyle,
            ),
            subtitle: Text(madhabList[PrayerTimeCache.getMadhabFromCache().index]['title'],
                style: subtitleTextStyle),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'صوت الأذان',
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
                  'تذكير قبل الأذان بربع ساعة',
                  style: titleTextStyle,
                ),
                onChanged: (value) async {
                  controller.showBeforePrayerSound = value;
                  await controller.toggleShowBeforePrayerSound(value);
                  // PrayerTimeCache.savePrayerNotificationMode(prayer: prayer, notificationMode: value);
                  // controller.update();
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
                  'تذكير وقت إقامة الصلاة',
                  style: titleTextStyle,
                ),
                onChanged: (value) async {
                  controller.showIqamahPrayerSound = value;
                  await controller.toggleShowIqamahPrayerSound(value);
                  // PrayerTimeCache.savePrayerNotificationMode(prayer: prayer, notificationMode: value);
                  // controller.update();
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
                  'تفعيل صوت الأذان بتكبيرتين فقط',
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
          GetBuilder<PrayerTimeController>(
            builder: (_) {
              return controller.isTakbertan
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: controller.athanAudios.length,
                      itemBuilder: (context, index) {
                        var item = controller.athanAudios[index];
                        return RadioListTile(
                          groupValue: index,
                          // value: 'الأقصى',
                          // value: item['name'],
                          // value: controller.athanAudios[controller.selectedAudioIndex]
                          // ['name'],
                          value: controller.selectedAudioIndex,
                          title: Text(
                            item['name'],
                            style: titleTextStyle,
                          ),
                          secondary: GestureDetector(
                            onTap: () {
                              if (!controller.athanAudios[index]['isStart']) {
                                controller.startAudio(item['src'], index);
                                controller.update();
                              } else {
                                controller.stopAudio(index);
                              }
                            },
                            child: item['isStart']
                                ? const Icon(FluentIcons.stop_24_regular)
                                : const Icon(FluentIcons.play_24_regular),
                          ),
                          onChanged: (_) {
                            controller.selectedAudioIndex = index;
                            AppSettingsCache.setSelectedAudioIndex(index);
                            Get.find<NotificationAlarmHandler>().scheduleAzkarAlarm();
                            controller.update();
                          },
                        );
                      },
                    );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'تنبيه الصلوات',
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
                    controller.repository.getPrayerNameArabic(prayer: Prayer.values[index]),
                    style: titleTextStyle,
                  ),
                  onChanged: (value) {
                    isNotificationEnabled.value = value;
                    PrayerTimeCache.savePrayerNotificationMode(
                        prayer: prayer, notificationMode: value);
                    controller.update();
                  },
                );
              });
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              ' ملاحظة: سيتم تطبيق التغيرات بعد الإشعار القادم.',
              style: subtitleTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
