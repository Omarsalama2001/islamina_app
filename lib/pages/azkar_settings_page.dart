import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/handlers/notification_alarm_handler.dart';
import 'package:islamina_app/services/notification_service.dart';
import 'package:islamina_app/services/services.dart';
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
          context.translate('AzkarSettingsTitle'),
          style: theme.primaryTextTheme.titleMedium,
        ),
      ),
      body: GetBuilder<AzkarSettingsController>(builder: (controller) {
        return ListView(
          children: [
            ListTile(
              title: Text(
                context.translate('presentation'),
                style: titleTextStyle!.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    context.translate('fontSize'),
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
                ListTile(
                  title: Text(
                    context.translate('preview'),
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
                context.translate('notifications'),
                style: titleTextStyle.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            // SwitchListTile(
            //   thumbIcon: WidgetStateProperty.resolveWith((states) {
            //     if (states.contains(WidgetState.selected)) {
            //       return Icon(
            //         Icons.notifications_active_outlined,
            //         color: theme.primaryColorDark,
            //       );
            //     } else {
            //       return const Icon(Icons.notifications_off_outlined);
            //     }
            //   }),
            //   dense: true,
            //   title: Text(
            //     'إظهار تنبيه عند الخروج',
            //     style: titleTextStyle,
            //   ),
            //   subtitle: Text(
            //     'تنبيه عند عدم الإنتهاء من قراءة الأذكار',
            //     style: subtitleTextStyle,
            //   ),
            //   value: controller.azkarSettings.showExitConfirmDialog,
            //   onChanged: controller.updateShowExitConfirmDialog,
            // ),
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
                context.translate('showNotifications'),
                style: titleTextStyle,
              ),
              subtitle: Text(
                context.translate('showNotificationsForRemindTheReaders'),
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showNotification,
              onChanged: controller.updateShowNotification,
            ),
            ListTile(
              onTap: () => controller.selectTime(context, controller.azkarSettings.morningTime, (newTime) => controller.updateMorningTime(newTime)),
              title: Text(
                context.translate('morningTime'),
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedMorningTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => controller.selectTime(context, controller.azkarSettings.nightTime, (newTime) => controller.updateNightTime(newTime)),
              title: Text(
                context.translate('eveningTime'),
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedNightTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => controller.selectTime(context, controller.azkarSettings.sleepTime, (newTime) => controller.updateSleepTime(newTime)),
              title: Text(
                context.translate('sleepTime'),
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
                context.translate('dohaPrayerTime'),
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
                            value: controller.azkarSettings.showNotificationPrayOfMohammed,
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
                          context.translate('prayForMohammed'),
                          style: titleTextStyle,
                        ),
                        subtitle: Text(
                          controller.getPrayForMohammed,
                          style: subtitleTextStyle,
                        ),
                        value: controller.azkarSettings.showNotificationPrayOfMohammed,
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
                context.translate("reminder"),
                style: titleTextStyle,
              ),
              subtitle: Text(
                context.translate('caveSurahReminder'),
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
                context.translate("reminder"),
                style: titleTextStyle,
              ),
              subtitle: Text(
                context.translate("fastingReminder"),
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showNotificationForForFastingMonAndThu,
              onChanged: controller.updateShowNotificationForFastingMonAndThu,
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
                context.translate("reminder"),
                style: titleTextStyle,
              ),
              subtitle: Text(
                context.translate("mid_night"),
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showNotificationForMidnight,
              onChanged: controller.updateShowNotificationForMidnight,
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
                context.translate("reminder"),
                style: titleTextStyle,
              ),
              subtitle: Text(
                context.translate("last_third"),
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showNotificationForThird,
              onChanged: controller.updateShowNotificationForthird,
            ),
          ],
        );
      }
      ),
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
            title: Text(context.translate('repetition')),
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
                      getCurrentLanguage() == 'ar' ? Utils.prayOfMohammedToArabicText(RepeatInterval.weekly) : RepeatInterval.weekly.name,
                    ),
                    onChanged: (value) async {
                      controller.pray.value = RepeatInterval.weekly;
                      await Get.find<NotificationService>().cancelNotifications(25);
                      await Get.find<NotificationAlarmHandler>().cancelAllMohamedAlarms();

                      Get.find<NotificationService>().scheduleMohmedWeeklyNotification();
                      controller.getPrayForMohammed = Utils.prayOfMohammedToArabicText(controller.pray.value);
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
                      getCurrentLanguage() == 'ar' ? Utils.prayOfMohammedToArabicText(RepeatInterval.daily) : RepeatInterval.daily.name,
                    ),
                    onChanged: (value) async {
                      controller.pray.value = RepeatInterval.daily;
                      await Get.find<NotificationService>().cancelNotifications(6);
                      await Get.find<NotificationAlarmHandler>().cancelAllMohamedAlarms();
                      NotificationAlarmHandler.scheduleMohammedAzkarAlarm(alarmDate: Utils.scheduleDateTime(const TimeOfDay(hour: 20, minute: 30)));
                      controller.getPrayForMohammed = Utils.prayOfMohammedToArabicText(controller.pray.value);
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
