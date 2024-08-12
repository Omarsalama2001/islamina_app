import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/firebase_options.dart';
import 'package:islamina_app/generated/l10n.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'constants/themes.dart';
import 'routes/app_pages.dart';
import 'services/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  // initializeWorkManager();
  // await Workmanager().registerPeriodicTask(
  //   "1",
  //   "weeklyNotificationTask",
  //   frequency: const Duration(days: 7),
  //   initialDelay: nextThursdayEvening(),
  // );
  // Get.put(NotificationService());
  // await NotificationService().initializeNotifications();
  await GetStorage.init('bookmarks');
  await GetStorage.init('daily_content');
  await GetStorage.init();
  // await NotificationService().initializeNotifications();
  // init SharedPreferencesService for app preference
  await Get.putAsync(() async {
    var service = SharedPreferencesService();
    await service.init();
    return service;
  });
  runApp(
    ResponsiveSizer(
      builder: (context1, orientation, screenType) {
        return GetMaterialApp(
          onDispose: () async {
            // ignore: deprecated_member_use
            await AudioService.stop();
          },
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          // Set the default locale
          locale: const Locale('ar'),
          // locale: Locale(AppSettingsCache.getLanguage()),
          // locale: const Locale('en'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: AppSettingsCache.getThemeMode(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}

class TestSound extends StatelessWidget {
  const TestSound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              // onPressed: showPrayerNotification,
              onPressed: () {
                showPrayerNotification(id: 30, sound: 'sound4');
              },
              child: const Text('sound4'),
            ),
            ElevatedButton(
              // onPressed: showPrayerNotification,
              onPressed: () {
                showPrayerNotification(id: 31, sound: 'sleeping');
              },
              child: const Text('sleeping'),
            ),
            ElevatedButton(
              // onPressed: showPrayerNotification,
              onPressed: () {
                showPrayerNotification(id: 32, sound: 'morning');
              },
              child: const Text('morning'),
            ),
            ElevatedButton(
              // onPressed: showPrayerNotification,
              onPressed: () {
                showPrayerNotification(id: 33, sound: 'evning');
              },
              child: const Text('evning'),
            ),
            ElevatedButton(
              // onPressed: showPrayerNotification,
              onPressed: () {
                showPrayerNotification(id: 34, sound: 'iqamah');
              },
              child: const Text('iqamah'),
            ),
            ElevatedButton(
              // onPressed: showPrayerNotification,
              onPressed: () {
                showPrayerNotification(id: 35, sound: 'mohammed');
              },
              child: const Text('mohammed'),
            ),
            ElevatedButton(
              // onPressed: showPrayerNotification,
              onPressed: () {
                showPrayerNotification(id: 36, sound: 'brid');
              },
              child: const Text('brid'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPrayerNotification({
    required int id,
    required String sound,
  }) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'id $id',
      'repeated notification $id',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        // 'sound2.wav'.split('.').first,
        // 'mohammed.mp3'.split('.').first,
        // 'isteghphar.mp3'.split('.').first,
        // 'sound2.mp3'.split('.').first,
        // 'sound3',
        // 'morning',
        // 'takbertan',
        // 'sound.wav'.split('.').first,
        // 'sound4',
        sound,
      ),
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      'تذكير',
      'صل على النبي',
      details,
      payload: "Payload Data",
    );
  }
}
