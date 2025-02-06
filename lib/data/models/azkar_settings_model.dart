import 'package:flutter/material.dart';
import 'package:islamina_app/services/services.dart';

class AzkarSettingsModel {
  late double fontSize;
  late bool showExitConfirmDialog;
  late bool showNotification;
  late bool showNotificationPrayOfMohammed;
  late bool showNotificationForReminderJomaa;
  late bool showNotificationForForFastingMonAndThu;
  late bool showNotificationForMidnight;
  late bool showNotificationForThird;
  late TimeOfDay morningTime;
  late TimeOfDay nightTime;
  late TimeOfDay sleepTime;
  late TimeOfDay dohaPrayerTime;

  String get formattedMorningTime {
    return getCurrentLanguage() == 'ar' ? formatTimeToArabicString(morningTime) : formatTimeToEnglishString(morningTime);
  }

  String get formattedNightTime {
    return getCurrentLanguage() == 'ar' ? formatTimeToArabicString(nightTime) : formatTimeToEnglishString(nightTime);
  }

  String get formattedSleepTime {
    return getCurrentLanguage() == 'ar' ? formatTimeToArabicString(sleepTime) : formatTimeToEnglishString(sleepTime);
  }

  String get formattedDohaPrayerTime {
    return getCurrentLanguage() == 'ar' ? formatTimeToArabicString(dohaPrayerTime) : formatTimeToEnglishString(dohaPrayerTime);
  }

  // Function to format TimeOfDay into Arabic string with AM and PM
  String formatTimeToArabicString(TimeOfDay time) {
    final int hour = time.hourOfPeriod;
    final String period = time.period == DayPeriod.am ? 'صباحًا' : 'مساءً';
    final String minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute $period';
  }

  String formatTimeToEnglishString(TimeOfDay time) {
    final int hour = time.hourOfPeriod;
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final String minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute $period';
  }
}
