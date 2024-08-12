import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/services/notification_service.dart';
import 'package:islamina_app/utils/utils.dart';

import '../constants/constants.dart';
import '../controllers/azkar_settings_controller.dart';
import '../widgets/custom_container.dart';

class AzkarSettingsPage extends GetView {
  AzkarSettingsPage({super.key});
  @override
  final controller = Get.put(AzkarSettingsController());
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إعدادات الأذكار',
          style: theme.primaryTextTheme.titleMedium,
        ),
      ),
      body: GetBuilder<AzkarSettingsController>(builder: (controller) {
        return ListView(
          children: [
            ListTile(
              title: Text(
                'العرض',
                style: titleTextStyle!.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ListTile(
                  title: Text(
                    'حجم الخط',
                  ),
                  dense: true,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: theme.colorScheme.primaryContainer,
                    inactiveTickMarkColor: theme.colorScheme.primary,
                    inactiveTrackColor: theme.colorScheme.primaryContainer,
                  ),
                  child: Slider(
                    value: controller.azkarSettings.fontSize,
                    min: 16,
                    max: 32,
                    // label: ArabicNumbers()
                    //     .convert('${controller.azkarSettings.fontSize}'),
                    label: '${controller.azkarSettings.fontSize}',
                    onChanged: controller.updateFontSize,
                    divisions: 4,
                  ),
                ),
                const ListTile(
                  title: Text(
                    'معاينة',
                  ),
                  dense: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        previewText,
                        style: TextStyle(
                          fontSize: controller.azkarSettings.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(15),
            const Divider(),
            ListTile(
              title: Text(
                'الإشعارات',
                style: titleTextStyle.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            SwitchListTile(
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
              dense: true,
              title: Text(
                'إظهار تنبيه عند الخروج',
                style: titleTextStyle,
              ),
              subtitle: Text(
                'تنبيه عند عدم الإنتهاء من قراءة الأذكار',
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showExitConfirmDialog,
              onChanged: controller.updateShowExitConfirmDialog,
            ),
            SwitchListTile(
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
              dense: true,
              title: Text(
                'اشعارات',
                style: titleTextStyle,
              ),
              subtitle: Text(
                'إظهار اشعارات للتذكير بقراءة الاذكار',
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showNotification,
              onChanged: controller.updateShowNotification,
            ),
            ListTile(
              onTap: () => controller.selectTime(
                  context,
                  controller.azkarSettings.morningTime,
                  (newTime) => controller.updateMorningTime(newTime)),
              title: Text(
                'وقت أذكار الصباح',
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedMorningTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => controller.selectTime(
                  context,
                  controller.azkarSettings.nightTime,
                  (newTime) => controller.updateNightTime(newTime)),
              title: Text(
                'وقت أذكار المساء',
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedNightTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => controller.selectTime(
                  context,
                  controller.azkarSettings.sleepTime,
                  (newTime) => controller.updateSleepTime(newTime)),
              title: Text(
                'وقت أذكار النوم',
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedSleepTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => controller.selectTime(
                context,
                controller.azkarSettings.dohaPrayerTime,
                (newTime) => controller.updateDohaPrayerTime(newTime),
              ),
              title: Text(
                'وقت صلاة الضحى',
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedDohaPrayerTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            GetBuilder<AzkarSettingsController>(
              init: AzkarSettingsController(),
              builder: (controller) {
                return Row(
                  children: [
                    const Gap(10),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(
                          PrayForMohammedDialog(
                            value: controller
                                .azkarSettings.showNotificationPrayOfMohammed,
                            onChange: (value) {
                              controller.updateRepeatPrayForMohammed(value);
                              Get.back();
                            },
                          ),
                        );
                      },
                      child: const Icon(Icons.mode_rounded),
                    ),
                    const Gap(5),
                    Expanded(
                      child: SwitchListTile(
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
                        dense: true,
                        title: Text(
                          'تذكير بالصلاة على النبي',
                          style: titleTextStyle,
                        ),
                        subtitle: Text(
                          controller.getPrayForMohammed,
                          style: subtitleTextStyle,
                        ),
                        value: controller
                            .azkarSettings.showNotificationPrayOfMohammed,
                        onChanged: (value) {
                          controller.updateRepeatPrayForMohammed(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            SwitchListTile(
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
              dense: true,
              title: Text(
                'تذكير',
                style: titleTextStyle,
              ),
              subtitle: Text(
                'لا تنسَ قراءة سورة الكهف!',
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showNotificationForReminderJomaa,
              onChanged: controller.updateShowNotificationForReminderJomaa,
            ),
            SwitchListTile(
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
              dense: true,
              title: Text(
                'تذكير',
                style: titleTextStyle,
              ),
              subtitle: Text(
                'صيام الإثنين والخميس',
                style: subtitleTextStyle,
              ),
              value: controller
                  .azkarSettings.showNotificationForForFastingMonAndThu,
              onChanged: controller.updateShowNotificationForFastingMonAndThu,
            ),
          ],
        );
      }),
    );
  }
}

class PrayForMohammedDialog extends StatelessWidget {
  final bool value;
  final Function(bool value) onChange;
  const PrayForMohammedDialog({
    super.key,
    required this.value,
    required this.onChange,
  });
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AzkarSettingsController>(
        init: AzkarSettingsController(),
        builder: (controller) {
          return AlertDialog(
            title: const Text('التكرار'),
            content: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SwitchListTile(
                  //   dense: true,
                  //   title: Text(
                  //     'الصلاة على النبي',
                  //     style: titleTextStyle,
                  //   ),
                  //   value: value,
                  //   onChanged: onChange,
                  // ),
                  RadioListTile(
                    value: RepeatInterval.weekly,
                    groupValue: controller.pray.value,
                    title: Text(
                      Utils.prayOfMohammedToArabicText(RepeatInterval.weekly),
                    ),
                    onChanged: (value) async {
                      controller.pray.value = RepeatInterval.weekly;
                      await Get.find<NotificationService>()
                          .cancelNotifications(6);

                      await Get.find<NotificationService>()
                          .showRepeatedNotification(controller.pray.value);
                      controller.getPrayForMohammed =
                          Utils.prayOfMohammedToArabicText(
                              controller.pray.value);
                      AppSettingsCache.setPrayOfMohammed(
                        repeatInterval: controller.pray.value,
                      );
                      controller.update();
                      Get.back();
                    },
                  ),
                  RadioListTile(
                    value: RepeatInterval.daily,
                    groupValue: controller.pray.value,
                    title: Text(
                      Utils.prayOfMohammedToArabicText(RepeatInterval.daily),
                    ),
                    onChanged: (value) async {
                      controller.pray.value = RepeatInterval.daily;
                      await Get.find<NotificationService>()
                          .cancelNotifications(6);

                      await Get.find<NotificationService>()
                          .showRepeatedNotification(controller.pray.value);
                      controller.getPrayForMohammed =
                          Utils.prayOfMohammedToArabicText(
                              controller.pray.value);
                      AppSettingsCache.setPrayOfMohammed(
                        repeatInterval: controller.pray.value,
                      );
                      controller.update();
                      Get.back();
                    },
                  ),
                  RadioListTile(
                    value: RepeatInterval.hourly,
                    groupValue: controller.pray.value,
                    title: Text(
                      Utils.prayOfMohammedToArabicText(RepeatInterval.hourly),
                    ),
                    onChanged: (value) async {
                      controller.pray.value = RepeatInterval.hourly;
                      await Get.find<NotificationService>()
                          .cancelNotifications(6);

                      await Get.find<NotificationService>()
                          .showRepeatedNotification(controller.pray.value);
                      controller.getPrayForMohammed =
                          Utils.prayOfMohammedToArabicText(
                              controller.pray.value);
                      AppSettingsCache.setPrayOfMohammed(
                        repeatInterval: controller.pray.value,
                      );
                      controller.update();
                      Get.back();
                    },
                  ),
                  RadioListTile(
                    value: RepeatInterval.everyMinute,
                    groupValue: controller.pray.value,
                    title: Text(
                      Utils.prayOfMohammedToArabicText(
                          RepeatInterval.everyMinute),
                    ),
                    onChanged: (value) async {
                      controller.pray.value = RepeatInterval.everyMinute;
                      await Get.find<NotificationService>()
                          .cancelNotifications(6);

                      await Get.find<NotificationService>()
                          .showRepeatedNotification(controller.pray.value);
                      controller.getPrayForMohammed =
                          Utils.prayOfMohammedToArabicText(
                              controller.pray.value);
                      AppSettingsCache.setPrayOfMohammed(
                        repeatInterval: controller.pray.value,
                      );
                      controller.update();
                      Get.back();
                    },
                  ),
                ],
              );
            }),
            // actions: [
            //   TextButton(
            //     onPressed: () => Get.back(),
            //     child: const Text('إلغاء'),
            //   ),
            //   TextButton(
            //     onPressed: () {
            //       Get.back();
            //       AppSettingsCache.setPrayOfMohammed(
            //           repeatInterval: controller.pray.value);
            //     },
            //     child: const Text('تأكيد'),
            //   ),
            // ],
          );
        });
  }
}
