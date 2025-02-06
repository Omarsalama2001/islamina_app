import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/cache_keys.dart';
import '../../services/shared_preferences_service.dart';

class PrayerTimeCache {
  static final SharedPreferences prefs = SharedPreferencesService.instance.prefs;

  static Future<void> saveChangeValues(List<int> intList) async {
    final encodedList = intList.map((int value) => value.toString()).toList();
    await prefs.setStringList('changeValues', encodedList);
  }

  static Future<List<int>> getChangeValues() async {
    try {
      final encodedList = prefs.getStringList('changeValues');
      if (encodedList != null) {
        return encodedList.map((String value) => int.parse(value)).toList();
      } else {
        return [0, 0, 0, 0, 0, 0]; // Return an empty list if the key doesn't exist
      }
    } catch (e) {
      throw Exception();
    }
  }

  /// Save the selected Madhab to cache.
  static void saveMadhabToCache(Madhab madhab) {
    prefs.setString(madhabKey, madhab.name);
  }

  /// Get the selected Madhab from cache, or save the default and return it.
  static Madhab getMadhabFromCache() {
    var madhab = prefs.getString(madhabKey);
    if (madhab == null) {
      madhab = Madhab.shafi.name;
      saveMadhabToCache(Madhab.shafi);
      return Madhab.shafi;
    }
    return EnumToString.fromString(Madhab.values, madhab)!;
  }
  static void saveSilentDuringPrayer(bool showNotification) async {
    await prefs.setBool("silentDuringPrayerKey", showNotification);
  }
  static bool getSilentDuringPrayer() {
    var silentDuringPrayer = prefs.getBool("silentDuringPrayerKey");
    if (silentDuringPrayer == null) {
      silentDuringPrayer = false;
      saveSilentDuringPrayer(silentDuringPrayer);
    }
    return silentDuringPrayer;
  }


  /// Save the selected calculation method to cache.
  static void saveCalculationMethodToCache(CalculationMethod calculationMethod) {
    prefs.setString(calculationMethodKey, calculationMethod.name);
  }

  /// Get the selected calculation method from cache, or save the default and return it.
  static CalculationMethod getCalculationMethodFromCache() {
    var calculationMethod = prefs.getString(calculationMethodKey);
    if (calculationMethod == null) {
      saveCalculationMethodToCache(CalculationMethod.karachi);
      return CalculationMethod.karachi;
    }
    return EnumToString.fromString(
      CalculationMethod.values,
      calculationMethod,
    )!;
  }

  /// Save the current coordinates to cache.
  static void saveCoordinatesToCache(Coordinates coordinates) {
    prefs.setString(coordinatesKey, jsonEncode(toJson(coordinates)));
  }

  /// Get the coordinates from cache or fetch from location if not available.
  static Coordinates? getCoordinatesFromCache() {
    var coordinates = prefs.getString(coordinatesKey);
    if (coordinates == null) {
      return null;
    }
    return fromJson(jsonDecode(coordinates));
  }

 static void saveSecondAdhanForJommaPrayer(bool showNotification) async {
    await prefs.setBool("secondAdhanForJommaPrayerKey", showNotification);
  }

 static  bool getSecondAdhanForJommaPrayer() {
    var secondAdhanForJommaPrayer = prefs.getBool("secondAdhanForJommaPrayerKey");
    if (secondAdhanForJommaPrayer == null) {
      secondAdhanForJommaPrayer = false;
      saveSecondAdhanForJommaPrayer(secondAdhanForJommaPrayer);
    }
    return secondAdhanForJommaPrayer;
  }
  
  static void setSecondAhdanTimeForJommaPrayer(int timeChange,int afterOrBeforeJommaPrayer) {
     Map<String, dynamic> data = {'timeChange': timeChange, 'afterOrBeforeJommaPrayer': afterOrBeforeJommaPrayer};
      
    prefs.setString("secondAdhanTimeForJommaPrayerKey",jsonEncode(data));
  }

   static Map<String, dynamic> getSecondAhdanTimeForJommaPrayer() {
    var secondAdhanTimeForJommaPrayer = prefs.getString("secondAdhanTimeForJommaPrayerKey");
    if (secondAdhanTimeForJommaPrayer == null) {
      return {'timeChange': 0, 'afterOrBeforeJommaPrayer': 0};

    }
    return jsonDecode(secondAdhanTimeForJommaPrayer);
   
  }

  static void savePrayerNotificationMode({required Prayer prayer, required bool notificationMode}) async {
    prefs.setBool(prayer.name, notificationMode);
  }

  static void saveBeforePrayerNotificationSound({required bool showNotification}) async {
    await prefs.setBool(beforePrayerNotificationSoundKey, showNotification);
  }

  static void saveIqamahPrayerNotificationSound({required bool showNotification}) async {
    await prefs.setBool(iqamahPrayerNotificationSoundKey, showNotification);
  }

  static void saveAdanWithtakbeerten({required bool takbeerten}) async {
    await prefs.setBool("adanWithtakbeertenKey", takbeerten);
  }

  static bool getAdanWithtakbeerten() {
    var takbeerten = prefs.getBool("adanWithtakbeertenKey");
    if (takbeerten == null) {
      takbeerten = false;
      saveAdanWithtakbeerten(takbeerten: takbeerten);
    }
    return takbeerten;
  }

  static RxBool getPrayerNotificationMode({
    required Prayer prayer,
  }) {
    var notifyMode = prefs.getBool(prayer.name);
    if (notifyMode == null) {
      notifyMode = true;
      savePrayerNotificationMode(prayer: prayer, notificationMode: notifyMode);
    }
    return notifyMode.obs;
  }


  static bool getBeforePrayerNotificationSound() {
    var showNotifySound = prefs.getBool(beforePrayerNotificationSoundKey);
    if (showNotifySound == null) {
      showNotifySound = false;
      saveBeforePrayerNotificationSound(showNotification: showNotifySound);
    }
    return showNotifySound;
  }

  static bool getIqamahPrayerNotificationSound() {
    var showNotifySound = prefs.getBool(iqamahPrayerNotificationSoundKey);
    if (showNotifySound == null) {
      showNotifySound = false;
      saveIqamahPrayerNotificationSound(showNotification: showNotifySound);
    }
    return showNotifySound;
  }

  static Map<String, dynamic> toJson(Coordinates coordinates) {
    return {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
  }

  static Coordinates fromJson(Map<String, dynamic> json) {
    return Coordinates(
      json['latitude']?.toDouble() ?? 0.0,
      json['longitude']?.toDouble() ?? 0.0,
    );
  }
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
