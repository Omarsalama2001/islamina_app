import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/cache_keys.dart';
import '../../services/shared_preferences_service.dart';

class AzkarSettingsCache {
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;

  // Setters
  static void setFontSize(double fontSize) {
    prefs.setDouble(azkarFontSizeKey, fontSize);
  }

  static void setShowExitConfirmDialog(bool showExitConfirmDialog) {
    prefs.setBool(exitConfirmDialogKey, showExitConfirmDialog);
  }

  static void setShowNotification(bool showNotification) {
    prefs.setBool(showNotificationKey, showNotification);
  }

  static void setShowRepeatedPrayForMohammed(bool showNotification) {
    prefs.setBool(repeatedKey, showNotification);
  }

  static void setShowNotificationForReminderJomaa(bool showNotification) {
    prefs.setBool(reminderJomaaKey, showNotification);
  }

  static void setShowNotificationForFastingMonAndThu(bool showNotification) {
    prefs.setBool(fastingMonAndThuKey, showNotification);
  }
  static void setShowNotificationForMidnight(bool showNotification) {
    prefs.setBool('midNight', showNotification);
  }
  

  static bool getShowNotificationForMidnight() {
   return prefs.getBool('midNight') ?? false;
  }
   static void setShowNotificationForThird(bool showNotification) {
    prefs.setBool('third', showNotification);
  }
  static bool getShowNotificationForThird() {
   return prefs.getBool('third') ?? false;
  }


  static void setMorningTime(TimeOfDay morningTime) {
    prefs.setString(morningTimeKey, _timeOfDayToString(morningTime));
  }

  static void setNightTime(TimeOfDay nightTime) {
    prefs.setString(nightTimeKey, _timeOfDayToString(nightTime));
  }

  static void setSleepTime(TimeOfDay sleepTime) {
    prefs.setString(sleepTimeKey, _timeOfDayToString(sleepTime));
  }

  static void setDohaPrayerTime(TimeOfDay dohaPrayerTime) {
    prefs.setString(dohaPrayerTimeKey, _timeOfDayToString(dohaPrayerTime));
  }

  // Getters
  static double getFontSize() {
    return prefs.getDouble(azkarFontSizeKey) ?? 16;
  }

  static bool getShowExitConfirmDialog() {
    return prefs.getBool(exitConfirmDialogKey) ?? true;
  }

  static bool getShowRepeatedPrayForMohammed() {
    return prefs.getBool(repeatedKey) ?? true;
  }

  static bool getShowNotificationForReminderJomaa() {
    return prefs.getBool(reminderJomaaKey) ?? true;
  }

  static bool getShowNotificationForFastingMonAndThu() {
    return prefs.getBool(fastingMonAndThuKey) ?? true;
  }

  static bool getShowNotification() {
    return prefs.getBool(showNotificationKey) ?? true;
  }

  static TimeOfDay getMorningTime() {
    final timeAsString = prefs.getString(morningTimeKey);
    return _stringToTimeOfDay(timeAsString) ??
        const TimeOfDay(hour: 8, minute: 0);
  }

  static TimeOfDay getNightTime() {
    final timeAsString = prefs.getString(nightTimeKey);
    return _stringToTimeOfDay(timeAsString) ??
        const TimeOfDay(hour: 17, minute: 0);
  }

  static TimeOfDay getSleepTime() {
    final timeAsString = prefs.getString(sleepTimeKey);
    return _stringToTimeOfDay(timeAsString) ??
        const TimeOfDay(hour: 21, minute: 0);
  }

  static TimeOfDay getDohaPrayerTime() {
    final timeAsString = prefs.getString(dohaPrayerTimeKey);
    return _stringToTimeOfDay(timeAsString) ??
        const TimeOfDay(hour: 9, minute: 0);
  }

  // Helper methods
  static String _timeOfDayToString(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour}:${timeOfDay.minute}';
  }

  static TimeOfDay? _stringToTimeOfDay(String? timeAsString) {
    if (timeAsString != null) {
      final List<String> parts = timeAsString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return null;
  }
}
