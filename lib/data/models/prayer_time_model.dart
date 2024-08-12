import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

class PrayerTimeModel {
  final String name;
  final String time;
  final Prayer type;
  final bool isAm;
  final String amPmAr;
  final DateTime fulldate;
  final Duration? timeLeft;
  final RxBool isNotificationEnabled;
  PrayerTimeModel({
    required this.name,
    required this.time,
    required this.type,
    required this.fulldate,
    required this.isAm,
    required this.amPmAr,
    this.timeLeft,
    required this.isNotificationEnabled,
  });

  PrayerTimeModel copyWith({
    String? name,
    String? time,
    Prayer? type,
    bool? isAm,
    String? amPmAr,
    DateTime? fulldate,
    Duration? timeLeft,
    RxBool? isNotificationEnabled,
  }) {
    return PrayerTimeModel(
      name: name ?? this.name,
      time: time ?? this.time,
      type: type ?? this.type,
      fulldate: fulldate ?? this.fulldate,
      isAm: isAm ?? this.isAm,
      amPmAr: amPmAr ?? this.amPmAr,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }
}
