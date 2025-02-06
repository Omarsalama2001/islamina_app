import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:islamina_app/constants/enum.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/data/cache/azkar_settings_cache.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/data/models/azkar_notification_model.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/routes/app_pages.dart';
import 'package:islamina_app/services/services.dart';
import 'package:islamina_app/utils/dialogs/dialogs.dart';
import 'package:islamina_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/models/prayer_time_model.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // late PrayerTimeController _prayerTimeController;

  @override
  void onInit() async {
    super.onInit();
    cancelAllNotifications();
    Get.put(PrayerTimeRepository());
    // _prayerTimeController = Get.put(PrayerTimeController());
    await initializeNotifications();
    // await isFirstRepeatedNotification();
    scheduleWeeklyNotification();
    scheduleWeeklySecondJomaaAdhanNotification();
    try {
      scheduleWeeklyFastingNotification();
      scheduleWeeklyThursdayFastingNotification();
    } catch (e) {
    }
    // scheduleMohmedWeeklyNotification();
    final dohaAlarmTime = Utils.scheduleDateTime(const TimeOfDay(hour: 9, minute: 0));
    final DateTime midNightDateTime = calculateMidNightNotificationTime();
    final midNightAlarmTime = Utils.scheduleDateTime(TimeOfDay(hour: midNightDateTime.hour, minute: midNightDateTime.minute));
    final DateTime lastThirdDateTime = calculateLastThirdOfNightNotificationTime();
    final lastThirdAlarmTime = Utils.scheduleDateTime(TimeOfDay(hour: lastThirdDateTime.hour, minute: lastThirdDateTime.minute));
    if (AzkarSettingsCache.getShowNotificationForThird()) {
      scheduleDailyNotification(lastThirdAlarmTime, 'الثلث الأخير من الليل ${calculateLastThirdOfNight()}', 'حان ألان موعد الثلث الأخير من الليل', 42, 'third');
    }
    if (AzkarSettingsCache.getShowNotificationForMidnight()) {
      scheduleDailyNotification(midNightAlarmTime, 'منتصف الليل ${calculateMidNight()}', 'حان ألان موعد منتصف الليل', 32, 'midnight');
    }
    scheduleDailyNotification(dohaAlarmTime, 'صلاة الضحي 9:00 ص', 'حان ألان موعد صلاة الضحي', 33, 'doha');
  }

  Future<void> initializeNotifications() async {
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_stat_icon_04');
    DarwinInitializationSettings iOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );
  }

  onTap(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      if (notificationResponse.payload == 'morning_payload') {
        Get.toNamed(Routes.AZKAR_DETAILS, arguments: {
          'pageTitle': 'أذكار الصباح',
          'categoryId': 0,
          'type': AzkarPageType.azkar,
        });
      }
      if (notificationResponse.payload == 'night_payload') {
        Get.toNamed(Routes.AZKAR_DETAILS, arguments: {
          'pageTitle': 'أذكار المساء',
          'categoryId': 1,
          'type': AzkarPageType.azkar,
        });
      }
      if (notificationResponse.payload == 'sleep_payload') {
        Get.toNamed(Routes.AZKAR_DETAILS, arguments: {
          'pageTitle': 'أذكار النوم',
          'categoryId': 5,
          'type': AzkarPageType.azkar,
        });
      }
    }
  }

  Future<void> checkAndRequestNotificationPermission() async {
    if (!(await Permission.notification.isGranted)) {
      if (await showAskUserForNotificationsPermission()) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
      }
    }
  }

  Future<void> showAzkarNotifications({
    required AzkarNotificationModel azkar,
    required String channleId,
    required String? sound,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      // 'azkar_channel_id',
      channleId,
      'Azkar Notifications',
      importance: Importance.max,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound(sound),
      sound: RawResourceAndroidNotificationSound(sound),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      2,
      azkar.title,
      azkar.description,
      platformChannelSpecifics,
      payload: azkar.payload,
    );
  }

  Future<void> showPrayerNotification(PrayerTimeModel prayer) async {
    if (prayer.type != Prayer.sunrise) {
      AndroidNotificationDetails androidPlatformChannelSpecifics = getPrayerNotificationDetails();
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        // iOS: iOS,
      );
      flutterLocalNotificationsPlugin.cancelAll();
      await flutterLocalNotificationsPlugin.show(
        0,
        // '${prayer.name} ${ArabicNumbers().convert(prayer.time)}${prayer.amPmAr}',
        '${prayer.name} ${prayer.time}${prayer.amPmAr}',
        'حان الآن موعد آذان ${prayer.name}',
        platformChannelSpecifics,
        payload: prayer.name,
      );
    }
  }

  getPrayerNotificationDetails() {
    Get.put(PrayerTimeController());
    try {
      bool isTakbertan = PrayerTimeCache.getAdanWithtakbeerten();
      int selectedAudioIndex = AppSettingsCache.getSelectedAudioIndex();

      String path = Get.find<PrayerTimeController>().athanAudios[selectedAudioIndex]['notification_sound'];
      AndroidNotificationDetails androidPlatformChannelSpecifics;
      if (isTakbertan) {
        androidPlatformChannelSpecifics = const AndroidNotificationDetails('prayer__takbertan_channel_id', 'Prayer_takbertan_Notifications', importance: Importance.max, priority: Priority.high, sound: RawResourceAndroidNotificationSound('takbertan'));
      } else {
        androidPlatformChannelSpecifics = AndroidNotificationDetails('prayer_${path}_channel_id', 'Prayer_${path}_Notifications', importance: Importance.max, priority: Priority.high, sound: RawResourceAndroidNotificationSound(path));
      }
      return androidPlatformChannelSpecifics;
    } catch (e) {

    }
  }

  Future<void> showSunriseNotification(PrayerTimeModel prayer) async {
    if (prayer.type == Prayer.sunrise) {
      AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'sunrise_channel_id',
        'Sunrise Notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(
          'brid',
        ),
      );
      // DarwinNotificationDetails iOS = DarwinNotificationDetails(
      //   sound: 'madena.mp3'.split('.').first,
      // );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        // iOS: iOS,
      );
      await flutterLocalNotificationsPlugin.show(
        3,
        // '${prayer.name} ${ArabicNumbers().convert(prayer.time)}${prayer.amPmAr}',
        '${prayer.name} ${prayer.time}${prayer.amPmAr}',
        'حان الآن وقت ${prayer.name}',
        platformChannelSpecifics,
        payload: prayer.name,
      );
    }
  }

  Future<void> showIqamahPrayerNotification(PrayerTimeModel prayer) async {
    if (prayer.type != Prayer.sunrise) {
      AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'iqamah_channel_id',
        'Iqamah Notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(
          // _prayerTimeController.audioPathSelected.split('.').first,
          'iqamah',
        ),
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        // iOS: iOS,
      );
      await flutterLocalNotificationsPlugin.show(
        11,
        // '${prayer.name} ${prayer.time}${prayer.amPmAr}',
        'تذكير',
        'حان الآن وقت إقامة صلاة ${prayer.name}',
        platformChannelSpecifics,
        payload: prayer.name,
      );
    }
  }

  Future<void> showBeforePrayerNotification(PrayerTimeModel prayer) async {
    final nextPrayer = prayer;
    bool isFajr = prayer.type == Prayer.fajr;
    if (prayer.type != Prayer.sunrise) {
      AndroidNotificationDetails androidPlatformChannelSpecifics = isFajr
          ? const AndroidNotificationDetails('before_fajer_channel_id', 'Before_Fajer_Notifications', importance: Importance.max, priority: Priority.high, sound: RawResourceAndroidNotificationSound('fajerreminder')
              // sound: RawResourceAndroidNotificationSound('fajerreminder'),
              )
          : const AndroidNotificationDetails('before_channel_id', 'Before_Notifications', importance: Importance.max, priority: Priority.high, sound: RawResourceAndroidNotificationSound('isteghphar')
              // sound: RawResourceAndroidNotificationSound('fajerreminder'),
              );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        // iOS: iOS,
      );
      await flutterLocalNotificationsPlugin.show(
        12,
        // '${prayer.name} ${prayer.time}${prayer.amPmAr}',
        'تذكير',
        // 'تبقى على أذان ${prayer.name} 15 دقيقة',
        'باقي علي أذان ${nextPrayer.name} ربع ساعة',
        platformChannelSpecifics,
        payload: prayer.name,
      );
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> showRepeatedNotification(RepeatInterval repeatInterval) async {
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'repeated_notification',
      'Pray for mohammed',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        'sound4',
      ),
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      6,
      'تذكير',
      'صل على النبي',
      repeatInterval,
      details,
      payload: "Payload Data",
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> isFirstRepeatedNotification() async {
    bool? first = GetStorage().read<bool>('isFirstRepeatedNotification') ?? true;
    if (first) {
      await showRepeatedNotification(RepeatInterval.daily);
      await GetStorage().write('isFirstRepeatedNotification', false);
    }
  }

  Future<void> scheduleDailyNotification(DateTime selectedTime, title, body, id, channel) async {
    if (selectedTime.isBefore(DateTime.now())) {
      selectedTime = selectedTime.add(const Duration(days: 1));
    }
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(selectedTime, tz.local);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            '${channel}_channel_id',
            '${channel} Notification',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

//!
  void scheduleWeeklySecondJomaaAdhanNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      77,
      _nextInstanceOfSecondJomaaAdhanNotification().toString(),
      'الأذان الثاني لصلاة الظهر',
      await _nextInstanceOfSecondJomaaAdhanNotification(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'JommaSecondAlarm',
          'Weekly Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfSecondJomaaAdhanNotification() async {
    final repo = Get.find<PrayerTimeRepository>();
    final nextfriday = await nextInstanceOfFriday();

    final PrayerTimes prayerTimes = PrayerTimes(repo.coordinates!, DateComponents(nextfriday.year, nextfriday.month, nextfriday.day), repo.parameters);

    var duhr = prayerTimes.dhuhr;
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final secondAlarmForJomaaData = PrayerTimeCache.getSecondAhdanTimeForJommaPrayer();

    if (secondAlarmForJomaaData['afterOrBeforeJommaPrayer'] == 0) {
      duhr = duhr.subtract(Duration(minutes: secondAlarmForJomaaData['timeChange']!));
    } else {
      duhr = duhr.add(Duration(minutes: secondAlarmForJomaaData['timeChange']!));
    }
    print(duhr.toString());
    print(tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      duhr.year,
      duhr.month,
      duhr.day,
      duhr.hour,
      duhr.minute,
    ));

    return tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      duhr.year,
      duhr.month,
      duhr.day,
      duhr.hour,
      duhr.minute,
    );
  }

//!
  // Weekly Notification
  // Weekly Notification
  void scheduleWeeklyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      8,
      'تذكير بقراءة سورة الكهف',
      'لا تنسَ قراءة سورة الكهف اليوم',
      await _nextInstanceOfFridayMorning(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_notification_channel_id',
          'Weekly Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfFridayMorning() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.TZDateTime scheduledDate = await nextInstanceOfFriday();
    print(tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      9,
      30,
    ));

    return tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      9,
      30,
    );
  }

  Future<tz.TZDateTime> nextInstanceOfFriday() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
    tz.TZDateTime scheduledDate = now;

    while (scheduledDate.weekday != DateTime.friday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  void scheduleMohmedWeeklyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      25,
      'تذكير',
      'صل على النبي',
      await _nextInstanceOfMohamedweekly(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          sound: RawResourceAndroidNotificationSound(
            'sound4',
          ),
          'repeated_notification',
          'Pray for mohammed',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfMohamedweekly() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.TZDateTime scheduledDate = await _nextInstanceOfMohamedweek();
    print(tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      20,
      30,
    ));
    return tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      20,
      30,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfMohamedweek() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
    tz.TZDateTime scheduledDate = now;

    while (scheduledDate.weekday != DateTime.thursday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
  // Fasting Monday

  void scheduleWeeklyFastingNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      9,
      'تذكير بصيام يوم الاثنين',
      'لا تنسَ صيام يوم الاثنين غداً',
      await _nextInstanceOfSundayEvening(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          sound: RawResourceAndroidNotificationSound(
            'isteghphar',
          ),
          'weekly_fasting_notification_channel_id',
          'Weekly Fasting Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfSundayEvening() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.TZDateTime scheduledDate = await _nextInstanceOfSunday();
    print(tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      19,
      30,
    ));
    return tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      19,
      30,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfSunday() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
    tz.TZDateTime scheduledDate = now;

    while (scheduledDate.weekday != DateTime.sunday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Fasting Thursday
  void scheduleWeeklyThursdayFastingNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      10,
      'تذكير بصيام يوم الخميس',
      'لا تنسَ صيام يوم الخميس غداً',
      await _nextInstanceOfWednesdayEvening(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          sound: RawResourceAndroidNotificationSound(
            'isteghphar',
          ),
          'weekly_thursday_fasting_notification_channel_id',
          'Weekly Thursday Fasting Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfWednesdayEvening() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.TZDateTime scheduledDate = await _nextInstanceOfWednesday();
    return tz.TZDateTime(
      tz.getLocation(currentTimeZone),
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      19,
      30,
    );
  }

  Future<tz.TZDateTime> _nextInstanceOfWednesday() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
    tz.TZDateTime scheduledDate = now;

    while (scheduledDate.weekday != DateTime.wednesday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}

class Time {
  final int hour;
  final int minute;

  Time({required this.hour, required this.minute});
}
