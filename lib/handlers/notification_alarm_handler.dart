import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/data/models/azkar_notification_model.dart';
import 'package:islamina_app/utils/utils.dart';

import '../data/cache/azkar_settings_cache.dart';
import '../data/repository/prayer_time_repository.dart';
import '../services/notification_service.dart';
import '../services/shared_preferences_service.dart';

class NotificationAlarmHandler extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Android Alarm Manager
    await AndroidAlarmManager.initialize();

    // Cancel existing alarms and schedule the next prayer alarm
    cancelAllAndNextPrayerSchedule();

    // Schedule Azkar alarms
    scheduleAzkarAlarm();
  }

  // Cancel all alarms and schedule the next prayer alarm
  Future<void> cancelAllAndNextPrayerSchedule() async {
    // Cancel the existing prayer alarm ID (1, 10, 11)
    await AndroidAlarmManager.cancel(1);
    await AndroidAlarmManager.cancel(10);
    await AndroidAlarmManager.cancel(11);

    scheduleBeforePrayerAlarm(
      alarmTime:
          Get.find<PrayerTimeRepository>().getNextPrayer().fulldate.subtract(
                const Duration(minutes: 15),
              ),
    );
    // Schedule the alarm for the next prayer
    schedulePrayerAlarm(
        alarmTime: Get.find<PrayerTimeRepository>().getNextPrayer().fulldate);
    scheduleIqamahPrayerAlarm(
      alarmTime: Get.find<PrayerTimeRepository>().getNextPrayer().fulldate.add(
            const Duration(minutes: 15),
          ),
    );
  }

  // Cancel all Azkar alarms
  Future<void> cancelAllAzkarAlarms() async {
    await AndroidAlarmManager.cancel(3);
  }

  // Schedule Azkar alarms
  Future<void> scheduleAzkarAlarm() async {
    await cancelAllAzkarAlarms();

    // Check if Azkar notifications are enabled
    if (AzkarSettingsCache.getShowNotification()) {
      // Schedule morning, night, and sleep Azkar alarms
      scheduleMorningAzkarAlarm(
        alarmDate: Utils.scheduleDateTime(AzkarSettingsCache.getMorningTime()),
      );
      scheduleNightAzkarAlarm(
        alarmDate: Utils.scheduleDateTime(AzkarSettingsCache.getNightTime()),
      );
      scheduleSleepAzkarAlarm(
        alarmDate: Utils.scheduleDateTime(AzkarSettingsCache.getSleepTime()),
      );
      scheduleDohaPrayerAlarm(
        alarmDate: Utils.scheduleDateTime(
          AzkarSettingsCache.getDohaPrayerTime(),
        ),
      );
    }
  }

  // Schedule a one-shot alarm for a specific prayer time
  static Future<void> schedulePrayerAlarm({required DateTime alarmTime}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      1, // Alarm ID for prayer
      startPrayerAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }

  // Schedule a one-shot alarm for a specific iqamah prayer time
  static Future<void> scheduleIqamahPrayerAlarm(
      {required DateTime alarmTime}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      10, // Alarm ID for prayer
      startIqamahPrayerAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }

  // Schedule a one-shot alarm for a specific before prayer time
  static Future<void> scheduleBeforePrayerAlarm(
      {required DateTime alarmTime}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      11, // Alarm ID for prayer
      startBeforePrayerAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }

  // Schedule a one-shot alarm for morning Azkar
  static Future<void> scheduleMorningAzkarAlarm(
      {required DateTime alarmDate}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmDate,
      3, // Alarm ID for morning Azkar
      startMorningAzkarAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
    );
  }

  // Schedule a one-shot alarm for night Azkar
  static Future<void> scheduleNightAzkarAlarm(
      {required DateTime alarmDate}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmDate,
      4, // Alarm ID for night Azkar
      startNightAzkarAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
    );
  }

  // Schedule a one-shot alarm for sleep Azkar
  static Future<void> scheduleSleepAzkarAlarm(
      {required DateTime alarmDate}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmDate,
      5, // Alarm ID for sleep Azkar
      startSleepAzkarAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
    );
  }

  // Schedule a one-shot alarm for doha Prayer
  static Future<void> scheduleDohaPrayerAlarm(
      {required DateTime alarmDate}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmDate,
      7, // Alarm ID for doha Prayer
      startDohaPrayerAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
    );
  }

  // Entry point for the prayer alarm callback
  @pragma('vm:entry-point')
  static Future<void> startPrayerAlarm() async {
    // Initialize notification service
    Get.put(NotificationService());
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        await service.prefs.reload();
        return service;
      },
    );

    // Initialize PrayerTimeRepository
    final prayerTimeRepository = PrayerTimeRepository();
    await prayerTimeRepository.initPrayerTimes();

    // Check if location coordinates are available
    if (prayerTimeRepository.coordinates == null) {
      return;
    }

    // Show prayer notification if enabled
    var currentPrayer = prayerTimeRepository.getCurrentPrayer();
    if (PrayerTimeCache.getPrayerNotificationMode(prayer: currentPrayer.type)
        .isTrue) {
      await prayerTimeRepository.showPrayerNotification();
    }

    // Get the next prayer time
    final nextPrayer = prayerTimeRepository.getNextPrayer();

    // Reschedule the alarm for the next prayer
    schedulePrayerAlarm(alarmTime: nextPrayer.fulldate);

    // Log that the alarm has fired
    log('Prayer Alarm Fired!!');
  }

  // Entry point for the iqamah prayer alarm callback
  @pragma('vm:entry-point')
  static Future<void> startIqamahPrayerAlarm() async {
    // Initialize notification service
    Get.put(NotificationService());
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        await service.prefs.reload();
        return service;
      },
    );

    // Initialize PrayerTimeRepository
    final prayerTimeRepository = PrayerTimeRepository();
    await prayerTimeRepository.initPrayerTimes();

    // Check if location coordinates are available
    if (prayerTimeRepository.coordinates == null) {
      return;
    }

    // Show prayer notification if enabled
    var currentPrayer = prayerTimeRepository.getCurrentPrayer();
    if (PrayerTimeCache.getPrayerNotificationMode(prayer: currentPrayer.type)
            .isTrue &&
        PrayerTimeCache.getIqamahPrayerNotificationSound()) {
      await prayerTimeRepository.showIqamahPrayerNotification();
    }

    // Get the next prayer time
    final nextPrayer = prayerTimeRepository.getNextPrayer();

    // Reschedule the alarm for the next prayer
    scheduleIqamahPrayerAlarm(
      alarmTime: nextPrayer.fulldate.add(
        const Duration(minutes: 15),
      ),
    );

    // Log that the alarm has fired
    log('Prayer Alarm Fired!!');
  }

  // Entry point for the iqamah prayer alarm callback
  @pragma('vm:entry-point')
  static Future<void> startBeforePrayerAlarm() async {
    // Initialize notification service
    Get.put(NotificationService());
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        await service.prefs.reload();
        return service;
      },
    );

    // Initialize PrayerTimeRepository
    final prayerTimeRepository = PrayerTimeRepository();
    await prayerTimeRepository.initPrayerTimes();

    // Check if location coordinates are available
    if (prayerTimeRepository.coordinates == null) {
      return;
    }

    // Show prayer notification if enabled
    var currentPrayer = prayerTimeRepository.getCurrentPrayer();
    if (PrayerTimeCache.getPrayerNotificationMode(prayer: currentPrayer.type)
            .isTrue &&
        PrayerTimeCache.getBeforePrayerNotificationSound()) {
      await prayerTimeRepository.showBeforePrayerNotification();
    }

    // Get the next prayer time
    final nextPrayer = prayerTimeRepository.getNextPrayer();

    // Reschedule the alarm for the next prayer
    scheduleBeforePrayerAlarm(
      alarmTime: nextPrayer.fulldate.subtract(
        const Duration(minutes: 15),
      ),
    );

    // Log that the alarm has fired
    log('Prayer Alarm Fired!!');
  }

  // Entry point for the morning Azkar alarm callback
  @pragma('vm:entry-point')
  static Future<void> startMorningAzkarAlarm() async {
    // Initialize SharedPreferencesService
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        service.prefs.reload();
        return service;
      },
    );
    await buildAzkarAlarmData(
      channleId: 'morning',
      title: 'اذكار الصباح',
      description: 'موعد قراءة اذكار الصباح',
      azkarTime: AzkarSettingsCache.getMorningTime(),
      payload: 'morning_payload',
      // sound: 'morning.mp3'.split('.').first,
      sound: 'morning',
    );
  }

  // Entry point for the night Azkar alarm callback
  @pragma('vm:entry-point')
  static Future<void> startNightAzkarAlarm() async {
    // Initialize SharedPreferencesService
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        service.prefs.reload();
        return service;
      },
    );
    await buildAzkarAlarmData(
      channleId: 'night',
      title: 'اذكار المساء',
      description: 'موعد قراءة اذكار المساء',
      azkarTime: AzkarSettingsCache.getNightTime(),
      payload: 'night_payload',
      // sound: 'morning.mp3'.split('.').first,
      sound: 'evning',
    );
  }

  // Entry point for the sleep Azkar alarm callback
  @pragma('vm:entry-point')
  static Future<void> startSleepAzkarAlarm() async {
    // Initialize SharedPreferencesService
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        service.prefs.reload();
        return service;
      },
    );
    await buildAzkarAlarmData(
      channleId: 'sleep',
      title: 'اذكار النوم',
      description: 'موعد قراءة اذكار النوم',
      azkarTime: AzkarSettingsCache.getSleepTime(),
      payload: 'sleep_payload',
      // sound: 'morning.mp3'.split('.').first,
      sound: 'sleeping',
    );
  }

  // Entry point for the doha prayer alarm callback
  @pragma('vm:entry-point')
  static Future<void> startDohaPrayerAlarm() async {
    // Initialize SharedPreferencesService
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        service.prefs.reload();
        return service;
      },
    );
    await buildAzkarAlarmData(
      channleId: 'doha',
      title: 'صلاة الضحى',
      description: 'حان الآن وقت صلاة الضحى',
      azkarTime: AzkarSettingsCache.getDohaPrayerTime(),
      payload: 'sleep_payload',
    );
  }

  // Entry point for the prayer alarm callback
  // Build and show Azkar notification data
  @pragma('vm:entry-point')
  static Future<void> buildAzkarAlarmData({
    required String channleId,
    required String title,
    required String description,
    required TimeOfDay azkarTime,
    required String payload,
    String? sound,
  }) async {
    if (AzkarSettingsCache.getShowNotification()) {
      var notificationService = Get.put(NotificationService());
      var notificationData = AzkarNotificationModel(
        title: title,
        description: description,
        time: azkarTime,
        payload: payload,
      );
      notificationService.showAzkarNotifications(
        channleId: channleId,
        azkar: notificationData,
        sound: sound,
      );

      // Reschedule the alarm for the next prayer
      scheduleMorningAzkarAlarm(
        alarmDate: Utils.scheduleDateTime(azkarTime),
      );
    }
    // Log that the alarm has fired
    log('Azkar Alarm Fired!!');
  }
}
