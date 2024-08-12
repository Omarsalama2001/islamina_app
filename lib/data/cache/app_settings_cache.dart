import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamina_app/constants/cache_keys.dart';

import '../../services/shared_preferences_service.dart';

class AppSettingsCache {
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;

  static void setThemeMode({required ThemeMode themeMode}) {
    Get.changeThemeMode(themeMode);
    prefs.setString(themeKey, themeMode.name);
  }

  static void setPrayOfMohammed({required RepeatInterval repeatInterval}) {
    prefs.setString(prayForMohammedKey, repeatInterval.name);
  }

  static ThemeMode getThemeMode() {
    var theme = prefs.getString(themeKey);
    if (theme == null) {
      theme = "system";
      setThemeMode(themeMode: ThemeMode.system);
    }
    return EnumToString.fromString(ThemeMode.values, theme)!;
  }

  static RepeatInterval getPrayForMohammed() {
    var value = prefs.getString(prayForMohammedKey);
    if (value == null) {
      value = "daily";
      setPrayOfMohammed(repeatInterval: RepeatInterval.daily);
    }
    return EnumToString.fromString(RepeatInterval.values, value)!;
  }

  static void setLanguage({required String lang}) {
    Get.updateLocale(Locale(lang));
    prefs.setString(languageKey, lang);
    Get.close(0);
  }

  static String getLanguage() {
    var language = prefs.getString(languageKey);
    if (language == null) {
      language = 'ar';
      setLanguage(lang: 'ar');
    }
    return language;
  }

  static void setSelectedAudioIndex(int index) {
    GetStorage storage = GetStorage();
    storage.write(selectedAudioKey, index);
  }

  static int getSelectedAudioIndex() {
    GetStorage storage = GetStorage();
    return storage.read<int>(selectedAudioKey) ?? 0;
    // int index = prefs.getInt(selectedAudioKey) ?? 0;
    // print('index:$index');
    // return index;
  }
}
