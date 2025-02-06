import 'package:get/get.dart';
import 'package:islamina_app/services/notification_service.dart';

import '../controllers/home_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/more_activities_controller.dart';
import '../controllers/prayer_time_controller.dart';
import '../controllers/quran_main_dashborad_controller.dart';
import '../data/repository/prayer_time_repository.dart';
import '../handlers/notification_alarm_handler.dart';

class BoardingBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(HomeController());
    Get.put(NotificationService());
    Get.put(NotificationAlarmHandler());
    
    Get.lazyPut(
      () => PrayerTimeRepository(),
    );

    Get.lazyPut(
      () => PrayerTimeController(),
    );
  }
}
