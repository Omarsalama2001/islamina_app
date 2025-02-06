import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(
  ) : super(ThemeInitial());
  Locale locale = const Locale('en');

  late SharedPreferences sharedPreferences ;
  Future<void> getCurrentLocale() async {
    emit(ThemeLoadingState());
        sharedPreferences=  await SharedPreferences.getInstance();

    
    if (sharedPreferences.containsKey("locale")) {
      locale = Locale(sharedPreferences.getString('locale')!);
    } else {
      final String devicelocale = Platform.localeName;
      if (devicelocale.contains("ar")) {
        locale = const Locale('ar');
      } else {
        locale = const Locale("en");
      }
    }
     Get.updateLocale(locale);
    emit(LangChangedState(
      locale: locale
    ));
  }

  Future<void> changeLocale(Locale lc) async {
      if (state is! LangChangedState || (state as LangChangedState).locale != lc) {
        emit(ThemeLoadingState());
     AppSettingsCache.setLanguage(lang: lc.languageCode);
   
    locale = lc;

    await sharedPreferences.setString("locale", lc.languageCode);
    Get.updateLocale(lc);
    emit(LangChangedState(
      locale: lc
    ));
    }
   
  }
}
