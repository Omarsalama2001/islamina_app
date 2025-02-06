import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/main_controller.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/core/constants/cache_keys.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/routes/app_pages.dart';
import 'package:islamina_app/services/services.dart';
import 'package:islamina_app/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () async {
  
     
      final SharedPreferences prefs = SharedPreferencesService.instance.prefs;
      await getAllQuranPages();
      final String? token = prefs.getString(TOKENID_KEY);
      final bool isBoardingDone = prefs.getBool('onboarding') ?? false;
        // Get.offAllNamed(Routes.TestQibla);
      if (token != null && isBoardingDone) {
        Get.offAllNamed(Routes.HOME);
      } else {
        if (isBoardingDone) {
          Get.offAllNamed(Routes.login);
        }else{
          Get.offAllNamed(Routes.TestQibla);
        }
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: const Color(0xff51AA86),
        child: Center(child: Image.asset('assets/images/islamina_logo-removeed.png')),
      ),
    );
  }
}
