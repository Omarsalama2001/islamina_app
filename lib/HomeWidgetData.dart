import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_widget/home_widget.dart';
import 'package:islamina_app/data/models/prayer_time_model.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/utils/utils.dart';

Future<void> updatePrayerTimesWidget2(List<PrayerTimeModel> prayerTimes,PrayerTimeModel nextPrayer, PrayerTimeModel currentPrayer) async {
  
  // Get.put(PrayerTimeRepository(),permanent: true);
 
  //save homeScreenWidget date


  await HomeWidget.saveWidgetData<String>('todayDate', Utils.getCurrentDateHijri(
    
  ));
  await HomeWidget.saveWidgetData<String>('meladyDate', Utils.getCurrentDate());
  await HomeWidget.saveWidgetData<String>('nextPrayer', nextPrayer.name);
  await HomeWidget.saveWidgetData<String>('nextPrayerTime', nextPrayer.time);
  await HomeWidget.saveWidgetData<int>('nextPrayerCountdown2', nextPrayer.timeLeft!.inSeconds);
  await HomeWidget.saveWidgetData<int>('currentPrayerFullTime', currentPrayer.fulldate.millisecondsSinceEpoch);
  await HomeWidget.saveWidgetData<int>('nextPrayerFullTime', nextPrayer.fulldate.millisecondsSinceEpoch);

  // Save the countdown string
  await HomeWidget.saveWidgetData<String>('nextPrayerCountdown', nextPrayer.timeLeft!.toString());
  await HomeWidget.saveWidgetData<String>('currentPrayer', currentPrayer.name);
  String nextPrayerString = nextPrayer.name;
  await HomeWidget.saveWidgetData<String>('nextPrayer', nextPrayerString);
  //! save the second and thired prayer names and times
  Prayer afterNextPrayer = Get.find<PrayerTimeRepository>().getAfterNextPrayer(nextPrayer.type);
  final secondPrayer =  Get.find<PrayerTimeRepository>().getPrayers().firstWhere((prayer) => prayer.type == afterNextPrayer);
  Prayer afterNextNextPrayer = Get.find<PrayerTimeRepository>().getAfterAfterNextPrayer(nextPrayer.type);
  final thirdprayer =  Get.find<PrayerTimeRepository>().getPrayers().firstWhere((prayer) => prayer.type == afterNextNextPrayer);
  // final thirdprayer = prayerTimes.firstWhere((prayer) => prayer.fulldate.isAfter(secondPrayer.fulldate));

  // print(thirdprayer.name);
  await HomeWidget.saveWidgetData<String>('secondPrayerName', secondPrayer.name);
  await HomeWidget.saveWidgetData<String>('secondPrayerTime', secondPrayer.time);
  await HomeWidget.saveWidgetData<String>('thirdPrayerName', thirdprayer.name);
  await HomeWidget.saveWidgetData<String>('thirdPrayerTime', thirdprayer.time);
//!
  await HomeWidget.updateWidget(
    androidName: 'PrayerTimesWidget2Provider',
    name: 'PrayerTimesWidget2Provider',
  );
}

Future<void> updatePrayerTimesWidget(List<PrayerTimeModel> prayerTimes, PrayerTimeModel nextPrayer, PrayerTimeModel currentPrayer, String date, String meladyDate) async {
  //save homeScreenWidget date
  await HomeWidget.saveWidgetData<String>('todayDate1', Utils.getCurrentDateHijri());
  await HomeWidget.saveWidgetData<String>('meladyDate1', Utils.getCurrentDate());

  // Save the prayer times as a comma-separated string
  await HomeWidget.saveWidgetData<String>('fajrTime', prayerTimes[0].time);
  await HomeWidget.saveWidgetData<String>('shroukTime', prayerTimes[1].time);

  await HomeWidget.saveWidgetData<String>('duhrTime', prayerTimes[2].time);

  await HomeWidget.saveWidgetData<String>('asrTime', prayerTimes[3].time);
  await HomeWidget.saveWidgetData<String>('maghribTime', prayerTimes[4].time);
  await HomeWidget.saveWidgetData<String>('ishaTime', prayerTimes[5].time);

  // Request the widget to update
  HomeWidget.updateWidget(
    androidName: 'PrayerTimesWidgetProvider',
    name: 'PrayerTimesWidgetProvider',
  );
}

initializePrayerTimesWidget() async {
  await HomeWidget.setAppGroupId('com.islamina.islamina_app');
}

String formatDuration(Duration duration) {
  // Extract hours, minutes, and seconds from the duration
  int hours = duration.inHours;
  int minutes = (duration.inMinutes % 60);
  int seconds = (duration.inSeconds % 60);

  String kHours = hours.toString().padLeft(2, '0');
  String kMinutes = minutes.toString().padLeft(2, '0');
  String kSeconds = seconds.toString().padLeft(2, '0');

  return '$kHours : $kMinutes : $kSeconds ';
}
