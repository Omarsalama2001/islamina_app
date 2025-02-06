import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  // Check for internet connection
  static Future<bool> checkForInternetConnection() async {
    final isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      return true;
    } else {
      return false;
    }
  }

  static DateTime scheduleDateTime(TimeOfDay time) {
    final now = DateTime.now();
    DateTime scheduledDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDateTime.isBefore(now)) {
      // If the scheduled time is in the past, add one day
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    return scheduledDateTime;
  }

  static String themeModeToArabicText(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.dark:
        return 'داكن';
      case ThemeMode.light:
        return 'فاتح';
      default:
        return 'السمة الإفتراضية للجهاز';
    }
  }

  static String prayOfMohammedToArabicText(RepeatInterval repeatInterval) {
    switch (repeatInterval) {
      case RepeatInterval.weekly:
        return 'مرة كل أسبوع';
      case RepeatInterval.daily:
        return 'مرة كل يوم';
      default:
        return 'مرة كل يوم';
    }
  }

  static String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMM d, y'); // Explicit pattern with commas and spaces

    return formatter.format(now);
  }

  static String getCurrentDateHijri() {
    return HijriDate.now().toString();
    // return ArabicNumbers().convert(
    //   HijriDate.now().toString(),
    // );
  }

  static String getLocalizedHijriDate({String locale = 'en'}) {
    // Initialize the Hijri calendar
    HijriCalendar.setLocal(locale);
    var hijriDate = HijriCalendar.now();

    // Localize month and weekday names
    Map<String, List<String>> localizedMonths = {
      'en': ['Muharram', 'Safar', 'Rabi’ al-Awwal', 'Rabi’ al-Thani', 'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Sha’ban', 'Ramadan', 'Shawwal', 'Dhu al-Qi’dah', 'Dhu al-Hijjah'],
      'ar': ['محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر', 'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'],
    };

    Map<String, List<String>> localizedWeekdays = {
      'en': ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      'ar': ['السبت', 'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'],
    };

    // Fallback to English if locale is not supported
    var months = localizedMonths[locale] ?? localizedMonths['en']!;
    var weekdays = localizedWeekdays[locale] ?? localizedWeekdays['en']!;

    // Get localized values
    String weekday = weekdays[hijriDate.wkDay!];
    String month = months[hijriDate.hMonth - 1];

    // Format the localized date
    return '$weekday, ${hijriDate.hDay} $month ${hijriDate.hYear}';
  }

  static Future<bool> requestLocationPermission() async {
    var status = await Geolocator.requestPermission();
    Geolocator.getPositionStream();

    if (status == LocationPermission.whileInUse) {
      return true;
    } else if (status == LocationPermission.always) {
      return true;
    } else if (status == LocationPermission.denied) {
      // The permission was denied.
      return false;
    } else if (status == LocationPermission.deniedForever) {
      // The permission was permanently denied.
      openAppSettings();
      return false;
    }

    return false;
  }

  /// get location status: GPS enabled and the permission status with GeolocationStatus
  static Future<LocationStatus> checkLocationStatus() async {
    final status = await Geolocator.checkPermission();
    final enabled = await Geolocator.isLocationServiceEnabled();
    return LocationStatus(enabled, status);
  }

  // Method to check and handle location status
  static Future<LocationStatus> handleLocationStatus() async {
    // Check current location status
    final locationStatus = await Utils.checkLocationStatus();

    // If location is not enabled, open location settings and update status
    if (!locationStatus.enabled) {
      await Geolocator.openLocationSettings();
      final updatedStatus = await Utils.checkLocationStatus();
      return updatedStatus;
    }

    // If location is enabled but permission is denied, request permission and handle accordingly
    if (locationStatus.enabled && locationStatus.status == LocationPermission.denied) {
      await Geolocator.requestPermission();
      var updatedStatus = await Utils.checkLocationStatus();

      if (updatedStatus.status == LocationPermission.denied) {
        // If permission is still denied, open app settings
        await Geolocator.openAppSettings();
      }

      // Check location status again and update the stream
      updatedStatus = await Utils.checkLocationStatus();
      return updatedStatus;
    } else {
      // If location is enabled and permission is granted, update the stream
      return locationStatus;
    }
  }

  static String formatDurationToArabic(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    String hoursText = (hours > 0) ? '$hours ساعة' : '';
    String minutesText = (minutes > 0) ? '$minutes دقيقة' : '';

    if (hours > 0 && minutes > 0) {
      return '$hoursText و $minutesText';
    } else {
      return '$hoursText$minutesText';
    }
  }

  static Future<Position?> getCurrentLocation() async {
    bool hasPermission = await requestLocationPermission();

    if (hasPermission) {
      try {
        return await Geolocator.getCurrentPosition();
      } catch (e) {
        log(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  static locationStream() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100000, // Update only when the user moves 1 km or more
      ),
    ).listen((Position position) async {
      final currentLocationPosition = PrayerTimeCache.getCoordinatesFromCache();

      const double locationChangeThreshold = 100000; // in meters

// Check if the location has changed significantly
      if (currentLocationPosition?.latitude != null) {
        double distance = Geolocator.distanceBetween(
          currentLocationPosition!.latitude,
          currentLocationPosition.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance >= locationChangeThreshold) {
          // Location has changed significantly
          Get.find<PrayerTimeController>().updateLocation();
        }
      } else {
        // If currentLocationPosition is null, treat it as a new location
        Get.find<PrayerTimeController>().updateLocation();
      }
    });
  }

  // Delete a directory
  static Future<void> deleteDirectory({required filePath}) async {
    final dir = Directory(filePath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  // Copy text to clipboard
  static Future<void> copyToClipboard({required text}) async {
    await Clipboard.setData(
      ClipboardData(text: '$text\n$islaminaLink'),
    );
  }

  // Share text
  static Future<void> shareText({required text}) async {
    await Share.share('$text\n$islaminaLink');
  }

  // Get storage permission
  static Future<bool> getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    // Check the Android version for different permission request approaches
    if (android.version.sdkInt < 33) {
      // For Android versions below 33
      if (await Permission.storage.request().isGranted) {
        return true;
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
        if (await Permission.storage.status.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      // For Android versions 33 and above
      if (await Permission.photos.request().isGranted) {
        return true;
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
        if (await Permission.photos.status.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }
}
