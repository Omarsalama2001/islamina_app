import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/services/notification_service.dart';
import 'package:just_audio/just_audio.dart';

import '../data/repository/prayer_time_repository.dart';
import '../handlers/notification_alarm_handler.dart';
import '../utils/dialogs/update_location_dialog.dart';

class PrayerTimeController extends GetxController {
  // Observable variable to track the location update status
  var isUpdatingLocation = false.obs;

  // Instance of PrayerTimeRepository to access repository methods
  final PrayerTimeRepository repository = Get.find();

  // Method to update the user's location
  Future<void> updateLocation() async {
    // Set isUpdatingLocation to true to indicate location update in progress
    isUpdatingLocation.value = true;

    // Request location permission using Geolocator
    Geolocator.requestPermission();

    // Continue updating location until isUpdatingLocation is true
    while (isUpdatingLocation.value) {
      // Display a dialog to indicate location update is in progress
      Get.dialog(UpdateLocationDialog(isUpdatingLocation: isUpdatingLocation));

      // Get coordinates from the device's location
      await repository.getCoordinatesFromLocation();

      // Initialize prayer times based on the updated location
      await repository.initPrayerTimes();

      // cancel all alarms and re schedule new alarm for next prayer
      Get.find<NotificationAlarmHandler>().cancelAllAndNextPrayerSchedule();

      // Set isUpdatingLocation to false to indicate location update is complete
      isUpdatingLocation.value = false;

      // Close the update location dialog
      Get.back();

      // Trigger UI update
      update();
    }
  }

  int selectedAudioIndex = 0;

  late String audioPathSelected;

  List<Map<String, dynamic>> athanAudios = [
    {
      'src': 'assets/audio/hindi.mp3',
      'name': 'تطبيق اسلامنا',
      'isStart': false,
    },
    {
      'src': 'assets/audio/meccafajer.mp3',
      'name': 'مكة المكرمة',
      'isStart': false,
    },
    {
      'src': 'assets/audio/madena.mp3',
      'name': 'المدينة المنورة',
      'isStart': false,
    },
    {
      'src': 'assets/audio/aqsa.mp3',
      'name': 'الأقصى',
      'isStart': false,
    },
    {
      'src': 'assets/audio/azhar.mp3',
      'name': 'الأزهر',
      'isStart': false,
    },
  ];

  bool isStartAudio = false;
  final _player = AudioPlayer();
  void startAudio(String path, int index) {
    cancelAnotherAudio(index);
    _player.stop();
    isStartAudio = true;
    _player.setAsset(path);
    _player.play();
    athanAudios[index]['isStart'] = true;
    update();
  }

  void stopAudio(int index) {
    _player.stop();
    isStartAudio = false;
    athanAudios[index]['isStart'] = false;
    update();
  }

  void cancelAnotherAudio(int index) {
    for (int i = 0; i < athanAudios.length; i++) {
      if (i != index) {
        athanAudios[i]['isStart'] = false;
      } else {
        _player.stop();
        athanAudios[i]['isStart'] = false;
        isStartAudio = false;
      }
    }
  }

  void getAudioPathSelected() {
    String path = athanAudios[selectedAudioIndex]['src'];
    audioPathSelected = path.split('/').last;
    update();
  }

  bool isTakbertan = false;

  Future<void> toggleShowPrayerSound(bool value) async {
    await Get.find<NotificationAlarmHandler>()
        .cancelAllAndNextPrayerSchedule()
        .then((_) {
      if (value) {
        audioPathSelected = 'takbertan';
      } else {
        selectedAudioIndex = AppSettingsCache.getSelectedAudioIndex();
        getAudioPathSelected();
      }
    });
    update();
  }

  bool showBeforePrayerSound = false;
  Future<void> toggleShowBeforePrayerSound(bool value) async {
    if (value) {
      await NotificationAlarmHandler.scheduleBeforePrayerAlarm(
        alarmTime: Get.find<PrayerTimeRepository>()
            .getNextPrayer()
            .fulldate
            .subtract(const Duration(minutes: 15)),
      );
      showBeforePrayerSound = true;
    } else {
      await AndroidAlarmManager.cancel(11);
      await Get.find<NotificationService>().cancelNotifications(12);
      showBeforePrayerSound = false;
    }
    PrayerTimeCache.saveBeforePrayerNotificationSound(
        showNotification: showBeforePrayerSound);
    update();
  }

  bool showIqamahPrayerSound = false;
  Future<void> toggleShowIqamahPrayerSound(bool value) async {
    if (value) {
      await NotificationAlarmHandler.scheduleIqamahPrayerAlarm(
        alarmTime: Get.find<PrayerTimeRepository>()
            .getNextPrayer()
            .fulldate
            .add(const Duration(minutes: 15)),
      );
      showIqamahPrayerSound = true;
    } else {
      await AndroidAlarmManager.cancel(10);
      await Get.find<NotificationService>().cancelNotifications(11);
      showIqamahPrayerSound = false;
    }
    PrayerTimeCache.saveBeforePrayerNotificationSound(
        showNotification: showIqamahPrayerSound);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    selectedAudioIndex = AppSettingsCache.getSelectedAudioIndex();
    showBeforePrayerSound = PrayerTimeCache.getBeforePrayerNotificationSound();
    showIqamahPrayerSound = PrayerTimeCache.getIqamahPrayerNotificationSound();
    getAudioPathSelected();
  }

  @override
  void onClose() {
    _player.stop();
    super.onClose();
  }
}
