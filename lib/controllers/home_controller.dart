import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/controllers/quran_reading_controller.dart';
import 'package:islamina_app/services/notification_service.dart';
import 'package:islamina_app/services/shared_preferences_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  late AnimationController animationController;
  RxInt selectedDestination = 0.obs;

  void onDestinationChanged(int value) {
    selectedDestination.value = value;
  }

  @override
  void onReady() async {
    super.onReady();
    final SharedPreferences prefs = SharedPreferencesService.instance.prefs;
    updateLocation();
    print(prefs.containsKey('onboarding'));
    if (prefs.containsKey('onboarding')) {
      NotificationService().checkAndRequestNotificationPermission();
    }
  }

  updateLocation() {
    final controller = Get.find<PrayerTimeController>();
    controller.repository.coordinates == null ? controller.updateLocation() : null;
    controller.update();
  }

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String _currentVersion = 'Unknown';
  String _latestVersion = 'Unknown';

  @override
  void onInit() async {
    super.onInit();
    _checkForUpdates();
     final SharedPreferences prefs = SharedPreferencesService.instance.prefs;
    if (prefs.containsKey('onboarding')) {
      NotificationService().checkAndRequestNotificationPermission();
    }
    NotificationService().initializeNotifications();
  }

  Future<void> _checkForUpdates() async {
    await _fetchRemoteConfig();
    await _getCurrentVersion();
    if (_latestVersion != _currentVersion) {
      // _showUpdateDialog();
    }
  }

  Future<void> _fetchRemoteConfig() async {
    await _remoteConfig.fetchAndActivate();
    _latestVersion = _remoteConfig.getString('android_version');
  }

  Future<void> _getCurrentVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    _currentVersion = info.version;
  }

  void _showUpdateDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('تحديث جديد'),
        // content: Text('A new version ($_latestVersion) is available. Please update the app.'),
        content: Text('يتوفر إصدار جديد ($_latestVersion). يرجى تحديث التطبيق.'),
        actions: <Widget>[
          TextButton(
            child: const Text('تحديث'),
            onPressed: () {
              // Add your app store URL here
              // launch('https://your_app_store_url');
            },
          ),
        ],
      ),
    );
  }
}
