import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/services/notification_service.dart';
import 'package:islamina_app/services/services.dart';
import 'package:islamina_app/utils/utils.dart';

import '../data/cache/azkar_settings_cache.dart';
import '../data/models/azkar_settings_model.dart';
import '../handlers/notification_alarm_handler.dart';
import 'azkar_details_controller.dart';

class AzkarSettingsController extends GetxController {
  late final AzkarSettingsModel azkarSettings;

  Rx<RepeatInterval> pray = AppSettingsCache.getPrayForMohammed().obs;
  String getPrayForMohammed = getCurrentLanguage() == 'ar' ? Utils.prayOfMohammedToArabicText(
    AppSettingsCache.getPrayForMohammed(),
  ): AppSettingsCache.getPrayForMohammed().name;
  // bool showRepeatedPrayForMohammed =
  //     AzkarSettingsCache.getShowRepeatedPrayForMohammed();

  @override
  void onInit() {
    super.onInit();
    initAzkarSettings();
  }

  void initAzkarSettings() {
    azkarSettings = AzkarSettingsModel();
    azkarSettings.fontSize = AzkarSettingsCache.getFontSize();
    azkarSettings.showExitConfirmDialog = AzkarSettingsCache.getShowExitConfirmDialog();
    azkarSettings.showNotification = AzkarSettingsCache.getShowNotification();
    azkarSettings.morningTime = AzkarSettingsCache.getMorningTime();
    azkarSettings.nightTime = AzkarSettingsCache.getNightTime();
    azkarSettings.sleepTime = AzkarSettingsCache.getSleepTime();
    azkarSettings.dohaPrayerTime = AzkarSettingsCache.getDohaPrayerTime();
    azkarSettings.showNotificationForReminderJomaa = AzkarSettingsCache.getShowNotificationForReminderJomaa();
    azkarSettings.showNotificationForForFastingMonAndThu = AzkarSettingsCache.getShowNotificationForFastingMonAndThu();
    azkarSettings.showNotificationPrayOfMohammed = AzkarSettingsCache.getShowRepeatedPrayForMohammed();
    azkarSettings.showNotificationForMidnight = AzkarSettingsCache.getShowNotificationForMidnight();
    azkarSettings.showNotificationForThird = AzkarSettingsCache.getShowNotificationForThird();
  }

  Future<void> selectTime(BuildContext context, TimeOfDay initialTime, Function(TimeOfDay) onTimeSelected) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      Get.find<NotificationAlarmHandler>().scheduleAzkarAlarm();
      onTimeSelected(pickedTime);
    }
  }

  // Update functions
  void updateFontSize(double newFontSize) {
    AzkarSettingsCache.setFontSize(newFontSize);
    azkarSettings.fontSize = newFontSize;
    update(); // Trigger a rebuild of the UI
    // if AzkarDetailsController is available update the widget
    try {
      Get.find<AzkarDetailsController>().update();
    } catch (e) {
      log(e.toString());
    }
  }

  void updateShowExitConfirmDialog(bool newValue) {
    AzkarSettingsCache.setShowExitConfirmDialog(newValue);
    azkarSettings.showExitConfirmDialog = newValue;
    update(); // Trigger a rebuild of the UI
  }

  void updateShowNotification(bool newValue) {
    AzkarSettingsCache.setShowNotification(newValue);
    // start the alarm timer for showing the notification
    if (newValue) {
      Get.find<NotificationAlarmHandler>().scheduleAzkarAlarm();
    }
    azkarSettings.showNotification = newValue;
    update(); // Trigger a rebuild of the UI
  }

  void updateShowNotificationForReminderJomaa(bool newValue) async {
    AzkarSettingsCache.setShowNotificationForReminderJomaa(newValue);
    if (newValue) {
      Get.find<NotificationService>().scheduleWeeklyNotification();
    } else {
      await Get.find<NotificationService>().cancelNotifications(8);
    }

    azkarSettings.showNotificationForReminderJomaa = newValue;
    update();
  }

  void updateShowNotificationForMidnight(bool newValue) async {
    AzkarSettingsCache.setShowNotificationForMidnight(newValue);
    if (newValue) {
      final DateTime midNightDateTime = calculateMidNightNotificationTime();
      final midNightAlarmTime = Utils.scheduleDateTime(TimeOfDay(hour: midNightDateTime.hour, minute: midNightDateTime.minute));
      Get.find<NotificationService>().scheduleDailyNotification(midNightAlarmTime, 'منتصف الليل ${calculateMidNight()}', 'حان ألان موعد منتصف الليل', 32, 'midnight');
    } else {
      await Get.find<NotificationService>().cancelNotifications(32);
    }

    azkarSettings.showNotificationForMidnight = newValue;
    update();
  }

  void updateShowNotificationForthird(bool newValue) async {
    AzkarSettingsCache.setShowNotificationForThird(newValue);
    if (newValue) {
      final DateTime lastThirdDateTime = calculateLastThirdOfNightNotificationTime();
      final lastThirdAlarmTime = Utils.scheduleDateTime(TimeOfDay(hour: lastThirdDateTime.hour, minute: lastThirdDateTime.minute));
      Get.find<NotificationService>().scheduleDailyNotification(lastThirdAlarmTime, 'الثلث الأخير من الليل ${calculateLastThirdOfNight()}', 'حان ألان موعد الثلث الأخير من الليل', 42, 'third');
    } else {
      await Get.find<NotificationService>().cancelNotifications(42);
    }

    azkarSettings.showNotificationForThird = newValue;
    update();
  }

  void updateShowNotificationForFastingMonAndThu(bool newValue) async {
    AzkarSettingsCache.setShowNotificationForFastingMonAndThu(newValue);
    if (newValue) {
      Get.find<NotificationService>().scheduleWeeklyThursdayFastingNotification();
      Get.find<NotificationService>().scheduleWeeklyFastingNotification();
    } else {
      await Get.find<NotificationService>().cancelNotifications(9);
      await Get.find<NotificationService>().cancelNotifications(10);
    }

    azkarSettings.showNotificationForForFastingMonAndThu = newValue;
    update();
  }

  void updateRepeatPrayForMohammed(bool newValue) async {
    AzkarSettingsCache.setShowRepeatedPrayForMohammed(newValue);
    // start the alarm timer for showing the notification
    if (newValue) {
      await Get.find<NotificationService>().cancelNotifications(25);
      await Get.find<NotificationAlarmHandler>().cancelAllMohamedAlarms();
      AppSettingsCache.getPrayForMohammed() == RepeatInterval.daily ? NotificationAlarmHandler.scheduleMohammedAzkarAlarm(alarmDate: Utils.scheduleDateTime(const TimeOfDay(hour: 20, minute: 30))) : Get.find<NotificationService>().scheduleMohmedWeeklyNotification();
    } else {
      await Get.find<NotificationService>().cancelNotifications(6);
      await Get.find<NotificationAlarmHandler>().cancelAllMohamedAlarms();
    }
    azkarSettings.showNotificationPrayOfMohammed = newValue;
    update();
  }

  void updateMorningTime(TimeOfDay newMorningTime) {
    AzkarSettingsCache.setMorningTime(newMorningTime);
    azkarSettings.morningTime = newMorningTime;
    update(); // Trigger a rebuild of the UI
  }

  void updateNightTime(TimeOfDay newNightTime) {
    AzkarSettingsCache.setNightTime(newNightTime);
    azkarSettings.nightTime = newNightTime;
    update(); // Trigger a rebuild of the UI
  }

  void updateSleepTime(TimeOfDay newSleepTime) {
    AzkarSettingsCache.setSleepTime(newSleepTime);
    azkarSettings.sleepTime = newSleepTime;
    update(); // Trigger a rebuild of the UI
  }

  void updateDohaPrayerTime(TimeOfDay newDohaPrayerTime) {
    AzkarSettingsCache.setDohaPrayerTime(newDohaPrayerTime);
    azkarSettings.dohaPrayerTime = newDohaPrayerTime;
    update(); // Trigger a rebuild of the UI
  }
}
