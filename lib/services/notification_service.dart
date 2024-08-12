import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:islamina_app/data/models/azkar_notification_model.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/utils/dialogs/dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/models/prayer_time_model.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // late PrayerTimeController _prayerTimeController;

  @override
  void onInit() async {
    super.onInit();
    // _prayerTimeController = Get.put(PrayerTimeController());
    await initializeNotifications();
    await isFirstRepeatedNotification();
    scheduleWeeklyNotification();
    scheduleWeeklyFastingNotification();
  }

  Future<void> initializeNotifications() async {
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');
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
    );
  }

  void checkAndRequestNotificationPermission() async {
    if (!(await Permission.notification.isGranted)) {
      if (await showAskUserForNotificationsPermission()) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .requestNotificationsPermission();
      }
    }
  }

  Future<void> showAzkarNotifications({
    required AzkarNotificationModel azkar,
    required String channleId,
    required String? sound,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
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
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'prayer_channel_id',
        'Prayer Notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(
          // _prayerTimeController.audioPathSelected.split('.').first,
          'sound.wav'.split('.').first,
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
        0,
        // '${prayer.name} ${ArabicNumbers().convert(prayer.time)}${prayer.amPmAr}',
        '${prayer.name} ${prayer.time}${prayer.amPmAr}',
        'حان الآن موعد آذان ${prayer.name}',
        platformChannelSpecifics,
        payload: prayer.name,
      );
    }
  }

  Future<void> showSunriseNotification(PrayerTimeModel prayer) async {
    if (prayer.type == Prayer.sunrise) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          const AndroidNotificationDetails(
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
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          const AndroidNotificationDetails(
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
    final nextPrayer = Get.find<PrayerTimeRepository>().getNextPrayer();
    bool isFajr = prayer.type == Prayer.fajr;
    if (prayer.type != Prayer.sunrise) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'before_channel_id',
        'Before Notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: isFajr
            ? const RawResourceAndroidNotificationSound('fajerreminder')
            : null,
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
    );
  }

  Future<void> isFirstRepeatedNotification() async {
    bool? first =
        GetStorage().read<bool>('isFirstRepeatedNotification') ?? true;
    if (first) {
      await showRepeatedNotification(RepeatInterval.daily);
      await GetStorage().write('isFirstRepeatedNotification', false);
    }
  }

  // Weekly Notification
  void scheduleWeeklyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      8,
      'تذكير بقراءة سورة الكهف',
      'لا تنسَ قراءة سورة الكهف اليوم',
      _nextInstanceOfFridayMorning(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_notification_channel_id',
          'Weekly Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfFridayMorning() {
    tz.TZDateTime scheduledDate = _nextInstanceOfFriday();
    return scheduledDate.add(Duration(hours: 10 - scheduledDate.hour));
  }

  tz.TZDateTime _nextInstanceOfFriday() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now;

    while (scheduledDate.weekday != DateTime.friday) {
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
      _nextInstanceOfSundayEvening(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_fasting_notification_channel_id',
          'Weekly Fasting Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfSundayEvening() {
    tz.TZDateTime scheduledDate = _nextInstanceOfSunday();
    return scheduledDate.add(Duration(hours: 20 - scheduledDate.hour));
  }

  tz.TZDateTime _nextInstanceOfSunday() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
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
      _nextInstanceOfWednesdayEvening(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_thursday_fasting_notification_channel_id',
          'Weekly Thursday Fasting Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfWednesdayEvening() {
    tz.TZDateTime scheduledDate = _nextInstanceOfWednesday();
    return scheduledDate.add(Duration(hours: 20 - scheduledDate.hour));
  }

  tz.TZDateTime _nextInstanceOfWednesday() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now;

    while (scheduledDate.weekday != DateTime.wednesday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
