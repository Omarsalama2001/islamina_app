import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islamina_app/HomeWidgetData.dart';

import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/data/models/azkar_notification_model.dart';
import 'package:islamina_app/utils/utils.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

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
    cancelAllAndNextPrayerSchedule(0);
    cancelAllMohamedAlarms();
    scheduleMohammedAzkarAlarm(alarmDate: Utils.scheduleDateTime(const TimeOfDay(hour: 20, minute: 30)));
    AndroidAlarmManager.cancel(22);
    scheduleWidgetMidNightShift(alarmTime: Utils.scheduleDateTime(const TimeOfDay(hour: 0, minute: 0)));

    // Schedule Azkar alarms
    scheduleAzkarAlarm();
  }

  // Cancel all alarms and schedule the next prayer alarm
  Future<void> cancelAllAndNextPrayerSchedule(int timeChagne) async {
    // // Check if location coordinates are available
    // if (prayerTimeRepository.coordinates == null) {
    //   return;
    // }
    // Cancel the existing prayer alarm ID (1, 10, 11)
    await AndroidAlarmManager.cancel(1);
    await AndroidAlarmManager.cancel(10);
    await AndroidAlarmManager.cancel(11);
    await AndroidAlarmManager.cancel(23);

    final now = DateTime.now();
    final nextPrayer = Get.find<PrayerTimeRepository>().getNextPrayer();
    // final currentPrayer = Get.find<PrayerTimeRepository>().prayerTimes!.timeForPrayer(Prayer.dhuhr);
    // تحديد الوقت قبل الصلاة بـ 15 دقيقة
    final beforePrayerTime = nextPrayer.fulldate.subtract(const Duration(minutes: 15));
    scheduleBeforePrayerAlarm(alarmTime: beforePrayerTime);
 
    schedulePrayerAlarm(alarmTime: Get.find<PrayerTimeRepository>().getNextPrayer().fulldate);
    final secondAlarmForJomaaData = PrayerTimeCache.getSecondAhdanTimeForJommaPrayer();
    print(nextPrayer.fulldate.subtract(Duration(minutes: secondAlarmForJomaaData['timeChange'])));
    final repo = Get.find<PrayerTimeRepository>();

    final PrayerTimes prayerTimes = PrayerTimes(repo.coordinates!, DateComponents(now.year, now.month, now.day), repo.parameters);
    var duhr = prayerTimes.dhuhr;

    if (secondAlarmForJomaaData['afterOrBeforeJommaPrayer'] == 0) {
      scheduleSecondJomaaPrayerAlarm(alarmTime: duhr.subtract(Duration(minutes: secondAlarmForJomaaData['timeChange'])));
    } else {
      scheduleSecondJomaaPrayerAlarm(alarmTime: duhr.add(Duration(minutes: secondAlarmForJomaaData['timeChange'])));
    }

    scheduleIqamahPrayerAlarm(
      alarmTime: Get.find<PrayerTimeRepository>().getNextPrayer().fulldate.add(
            const Duration(minutes: 15),
          ),
    );
  }

  // Cancel all Azkar alarms
  Future<void> cancelAllAzkarAlarms() async {
    await AndroidAlarmManager.cancel(3);
    await AndroidAlarmManager.cancel(4);
    await AndroidAlarmManager.cancel(5);
    await AndroidAlarmManager.cancel(7);
  }

  Future<void> cancelAllMohamedAlarms() async {
    await AndroidAlarmManager.cancel(15);
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

  static Future<void> scheduleSecondJomaaPrayerAlarm({required DateTime alarmTime}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      23, // Alarm ID for prayer
      startSecondJomaaPrayerAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<void> scheduleWidgetMidNightShift({required DateTime alarmTime}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      22, // Alarm ID for prayer
      startShiftPrayerAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<void> startShiftPrayerAlarm() async {
    await Get.putAsync(
      () async {
        var service = SharedPreferencesService();
        await service.init();
        await service.prefs.reload();
        return service;
      },
    );
    final prayerTimeRepository = Get.find<PrayerTimeRepository>();
    await prayerTimeRepository.initPrayerTimes();
    scheduleWidgetMidNightShift(alarmTime: Utils.scheduleDateTime(const TimeOfDay(hour: 0, minute: 0)));
  }

  // Schedule a one-shot alarm for a specific iqamah prayer time
  static Future<void> scheduleIqamahPrayerAlarm({required DateTime alarmTime}) async {
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
  static Future<void> scheduleBeforePrayerAlarm({required DateTime alarmTime}) async {
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
  static Future<void> scheduleMorningAzkarAlarm({required DateTime alarmDate}) async {
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
  static Future<void> scheduleNightAzkarAlarm({required DateTime alarmDate}) async {
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
  static Future<void> scheduleSleepAzkarAlarm({required DateTime alarmDate}) async {
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

  static Future<void> scheduleMohammedAzkarAlarm({required DateTime alarmDate}) async {
    await AndroidAlarmManager.oneShotAt(
      alarmDate,
      15, // Alarm ID for sleep Azkar
      startMohamedAzkarAlarm,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
    );
  }

  // Schedule a one-shot alarm for doha Prayer
  static Future<void> scheduleDohaPrayerAlarm({required DateTime alarmDate}) async {
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
  // 1-before or after the original salah (based on this step we will save the subtracted or added time to the prayer time)
  // 2-set the time to 1-60 minutes before or after the original salah.
  // 3-schedule the prayer alarm

  // Entry point for the prayer alarm callback
  @pragma('vm:entry-point')
  static Future<void> startPrayerAlarm() async {
    // when starting check the silent mode status

    bool? isGranted = await PermissionHandler.permissionsGranted;
    if (isGranted! && PrayerTimeCache.getSilentDuringPrayer()) {
      await SoundMode.setSoundMode(RingerModeStatus.silent);
    }

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
    Get.put(PrayerTimeRepository());
    final prayerTimeRepository = Get.find<PrayerTimeRepository>();
    await prayerTimeRepository.initPrayerTimes();

    // Check if location coordinates are available
    if (prayerTimeRepository.coordinates == null) {
      return;
    }
    // Get the next prayer time
    final nextPrayer = prayerTimeRepository.getNextPrayer();
    print(nextPrayer.fulldate.subtract(const Duration(minutes: 15)));

    // Show prayer notification if enabled
    var currentPrayer = prayerTimeRepository.getCurrentPrayer();

    if (PrayerTimeCache.getPrayerNotificationMode(prayer: currentPrayer.type).isTrue) {
      await prayerTimeRepository.showPrayerNotification();
    }
    try {
      updatePrayerTimesWidget(prayerTimeRepository.getPrayers(), nextPrayer, currentPrayer, Utils.getCurrentDateHijri(), Utils.getCurrentDateHijri());
      updatePrayerTimesWidget2(prayerTimeRepository.getPrayers(), nextPrayer, currentPrayer);
    } catch (e) {
    }

    // Reschedule the alarm for the next prayer
    schedulePrayerAlarm(alarmTime: nextPrayer.fulldate);

    // Log that the alarm has fired
    log('Prayer Alarm Fired 000000!!');
  }

  @pragma('vm:entry-point')
  static Future<void> startSecondJomaaPrayerAlarm() async {
    // when starting check the silent mode status

    // bool? isGranted = await PermissionHandler.permissionsGranted;
    // if (isGranted! && PrayerTimeCache.getSilentDuringPrayer()) {
    //   await SoundMode.setSoundMode(RingerModeStatus.silent);
    // }

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
    Get.put(PrayerTimeRepository());
    final prayerTimeRepository = Get.find<PrayerTimeRepository>();
    await prayerTimeRepository.initPrayerTimes();

    // Check if location coordinates are available
    if (prayerTimeRepository.coordinates == null) {
      return;
    }
    // Get the next prayer time

    final now = DateTime.now();
    final bool isTodayFriday = (now.weekday == DateTime.friday);
    final repo = Get.find<PrayerTimeRepository>();
    final secondAlarmForJomaaData = PrayerTimeCache.getSecondAhdanTimeForJommaPrayer();
    PrayerTimes prayerTimes = PrayerTimes(repo.coordinates!, DateComponents(now.year, now.month, now.day), repo.parameters);
    var duhr = prayerTimes.dhuhr;

    final realNotificationTime = secondAlarmForJomaaData['afterOrBeforeJommaPrayer'] == 0 ? duhr.subtract(Duration(minutes: secondAlarmForJomaaData['timeChange'])) : duhr.add(Duration(minutes: secondAlarmForJomaaData['timeChange']));

    if (PrayerTimeCache.getPrayerNotificationMode(prayer: Prayer.dhuhr).isTrue && PrayerTimeCache.getSecondAdhanForJommaPrayer() && isTodayFriday && (now.difference(realNotificationTime).inSeconds == 0)) {
      await prayerTimeRepository.showSecondJomaaPrayerNotification();
    }

    // Reschedule the alarm for the next prayer

    prayerTimes = PrayerTimes(repo.coordinates!, DateComponents(now.year, now.month, now.day + 1), repo.parameters);
    duhr = prayerTimes.dhuhr;
    if (secondAlarmForJomaaData['afterOrBeforeJommaPrayer'] == 0) {
      scheduleSecondJomaaPrayerAlarm(alarmTime: duhr.subtract(Duration(minutes: secondAlarmForJomaaData['timeChange'])));
    } else {
      scheduleSecondJomaaPrayerAlarm(alarmTime: duhr.add(Duration(minutes: secondAlarmForJomaaData['timeChange'])));
    }

    // Log that the alarm has fired
    log('Prayer Alarm Fired 000000!!');
  }

  // Entry point for the iqamah prayer alarm callback
  @pragma('vm:entry-point')
  static Future<void> startIqamahPrayerAlarm() async {
    bool? isGranted = await PermissionHandler.permissionsGranted;
    if (isGranted! && PrayerTimeCache.getSilentDuringPrayer()) {
          final int alarmId = 64;
      await AndroidAlarmManager.oneShot(
        const Duration(minutes: 5),
        alarmId,
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
        alarmClock: true,
        rescheduleOnReboot: true,
        () async {
          try {
            await SoundMode.setSoundMode(RingerModeStatus.normal);
          } on PlatformException {
          }
        },
      );
    }

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
    final prayerTimeRepository = Get.find<PrayerTimeRepository>();
    await prayerTimeRepository.initPrayerTimes();

    // Check if location coordinates are available
    if (prayerTimeRepository.coordinates == null) {
      return;
    }

    // Show prayer notification if enabled
    var currentPrayer = prayerTimeRepository.getCurrentPrayer();
    if (PrayerTimeCache.getPrayerNotificationMode(prayer: currentPrayer.type).isTrue && PrayerTimeCache.getIqamahPrayerNotificationSound()) {
      await prayerTimeRepository.showIqamahPrayerNotification();
    }

    // Get the next prayer time
    final nextPrayer = prayerTimeRepository.getNextPrayer();

    // Reschedule the alarm for the next prayer
    scheduleIqamahPrayerAlarm(
      alarmTime: nextPrayer.fulldate.add(const Duration(minutes: 15)),
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
    final prayerTimeRepository = Get.find<PrayerTimeRepository>();
    await prayerTimeRepository.initPrayerTimes();

    // Check if location coordinates are available
    if (prayerTimeRepository.coordinates == null) {
      return;
    }
    // Show prayer notification if enabled
    final now = DateTime.now();
    var currentPrayer = prayerTimeRepository.getNextPrayer(); //fajr
    print((now.difference(currentPrayer.fulldate.subtract(const Duration(minutes: 15))).inSeconds== 0));
    if (PrayerTimeCache.getPrayerNotificationMode(prayer: currentPrayer.type).isTrue && PrayerTimeCache.getBeforePrayerNotificationSound() && (now.difference(currentPrayer.fulldate.subtract(const Duration(minutes: 15))).inMinutes == 0)) {
      await prayerTimeRepository.showBeforePrayerNotification();
    }

    var nextPrayer = prayerTimeRepository.getPrayers().firstWhere((prayer) => prayer.type == prayerTimeRepository.getAfterNextPrayer(currentPrayer.type));

    if (nextPrayer.type == Prayer.fajr && nextPrayer.fulldate.isAfter(DateTime.now())) {
      nextPrayer = nextPrayer.copyWith(fulldate: nextPrayer.fulldate.add(const Duration(days: 1)));
    }
    print('nextPrayer: ${nextPrayer.fulldate.subtract(const Duration(minutes: 15))}');

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

  @pragma('vm:entry-point')
  static Future<void> startMohamedAzkarAlarm() async {
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
      channleId: 'mohamedDaily',
      title: 'تذكير',
      description: 'صلي علي محمد',
      azkarTime: const TimeOfDay(hour: 20, minute: 30),
      payload: 'mohamed_payload',
      // sound: 'morning.mp3'.split('.').first,
      sound: 'sound4',
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
      payload: 'doha_payload',
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
      if (payload == 'morning_payload')
        scheduleMorningAzkarAlarm(
          alarmDate: Utils.scheduleDateTime(azkarTime),
        );

      if (payload == 'night_payload')
        scheduleNightAzkarAlarm(
          alarmDate: Utils.scheduleDateTime(azkarTime),
        );

      if (payload == 'sleep_payload')
        scheduleSleepAzkarAlarm(
          alarmDate: Utils.scheduleDateTime(azkarTime),
        );

      if (payload == 'doha_payload')
        scheduleDohaPrayerAlarm(
          alarmDate: Utils.scheduleDateTime(azkarTime),
        );

      if (payload == 'mohamed_payload') scheduleMohammedAzkarAlarm(alarmDate: Utils.scheduleDateTime(const TimeOfDay(hour: 20, minute: 30)));
    }
    // Log that the alarm has fired
    log('Azkar Alarm Fired!!');
  }
}
