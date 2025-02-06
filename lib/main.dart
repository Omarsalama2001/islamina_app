import 'package:audio_service/audio_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:islamina_app/HomeWidgetData.dart';
import 'package:islamina_app/bindings/boarding_binding.dart';
import 'package:islamina_app/bloc_observer.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/controllers/home_controller.dart';
import 'package:islamina_app/controllers/main_controller.dart';
import 'package:islamina_app/controllers/more_activities_controller.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/controllers/quran_main_dashborad_controller.dart';
import 'package:islamina_app/core/network/connection/bloc/connection_bloc.dart';
import 'package:islamina_app/core/utils/Localization/app_localization_setup.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/radio/presentation/blocs/cubit/raido_cubit.dart';
import 'package:islamina_app/firebase_options.dart';
import 'package:islamina_app/utils/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'constants/themes.dart';
import 'routes/app_pages.dart';
import 'services/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utils.locationStream();

  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  // AuthCubit.removeToken();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Bloc.observer = MyBlocObserver();

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
  // Get.put(PrayerTimeRepository(),);

  // Get.put(TafsirDetailsController());
  //  Get.put(PrayerTimeRepository());
  // Get.put(PrayerTimeRepository());
  // Get.put(PrayerTimeController());
  initializePrayerTimesWidget();
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit()..getCurrentLocale(),
      child: DevicePreview(
        enabled: false,
        builder: (context) => ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => KhatmaCubit(),
                ),
                BlocProvider(
                  create: (context) => RaidoCubit(),
                ),
                BlocProvider(
                  create: (context) => ConnectionBloc(),
                ),
              ],
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return GetMaterialApp(
                    key: ValueKey(BlocProvider.of<ThemeCubit>(context).locale),
                    locale: BlocProvider.of<ThemeCubit>(context).locale,
                    supportedLocales: AppLocalizationsSetup.supportedLocales,
                    localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
                    localeResolutionCallback: (deviceLocale, supportedLocales) {
                      return AppLocalizationsSetup.localeResolutionCallback(deviceLocale!, supportedLocales);
                    },
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
          },
        ),
      ),
    ),
  );
}

// class TestSound extends StatelessWidget {
//   const TestSound({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               // onPressed: showPrayerNotification,
//               onPressed: () {
//                 showPrayerNotification(id: 30, sound: 'sound4');
//               },
//               child: const Text('sound4'),
//             ),
//             ElevatedButton(
//               // onPressed: showPrayerNotification,
//               onPressed: () {
//                 showPrayerNotification(id: 31, sound: 'sleeping');
//               },
//               child: const Text('sleeping'),
//             ),
//             ElevatedButton(
//               // onPressed: showPrayerNotification,
//               onPressed: () {
//                 showPrayerNotification(id: 32, sound: 'morning');
//               },
//               child: const Text('morning'),
//             ),
//             ElevatedButton(
//               // onPressed: showPrayerNotification,
//               onPressed: () {
//                 showPrayerNotification(id: 33, sound: 'evning');
//               },
//               child: const Text('evning'),
//             ),
//             ElevatedButton(
//               // onPressed: showPrayerNotification,
//               onPressed: () {
//                 showPrayerNotification(id: 34, sound: 'iqamah');
//               },
//               child: const Text('iqamah'),
//             ),
//             ElevatedButton(
//               // onPressed: showPrayerNotification,
//               onPressed: () {
//                 showPrayerNotification(id: 35, sound: 'mohammed');
//               },
//               child: const Text('mohammed'),
//             ),
//             ElevatedButton(
//               // onPressed: showPrayerNotification,
//               onPressed: () {
//                 showPrayerNotification(id: 36, sound: 'brid');
//               },
//               child: const Text('brid'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> showPrayerNotification({
//     required int id,
//     required String sound,
//   }) async {
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     AndroidNotificationDetails android = AndroidNotificationDetails(
//       'id $id',
//       'repeated notification $id',
//       importance: Importance.max,
//       priority: Priority.high,
//       sound: RawResourceAndroidNotificationSound(
//         // 'sound2.wav'.split('.').first,
//         // 'mohammed.mp3'.split('.').first,
//         // 'isteghphar.mp3'.split('.').first,
//         // 'sound2.mp3'.split('.').first,
//         // 'sound3',
//         // 'morning',
//         // 'takbertan',
//         // 'sound.wav'.split('.').first,
//         // 'sound4',
//         sound,
//       ),
//     );
//     NotificationDetails details = NotificationDetails(
//       android: android,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       id,
//       'تذكير',
//       'صل على النبي',
//       details,
//       payload: "Payload Data",
//     );
//   }
// }
