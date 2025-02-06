import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:islamina_app/HomeWidgetData.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';

import '../utils/utils.dart';

class ArabicTimerWidget extends StatefulWidget {
  final DateTime targetDate;
  final Function()? onTimerFinished;
  final TextStyle? style;
  const ArabicTimerWidget({
    super.key,
    required this.targetDate,
    this.onTimerFinished,
    this.style,
  });

  @override
  // ignore: library_private_types_in_public_api
  ArabicTimerWidgetState createState() => ArabicTimerWidgetState();
}

class ArabicTimerWidgetState extends State<ArabicTimerWidget> {
  late Duration _remainingTime;
  late String formattedTime;
  final prayerRepository = Get.find<PrayerTimeRepository>();
  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() {
    _remainingTime = widget.targetDate.difference(DateTime.now());
    formattedTime = formatDuration(_remainingTime);

    // Set up a periodic timer to update the remaining time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingTime = widget.targetDate.difference(DateTime.now());
          formattedTime = formatDuration(_remainingTime);
                // updatePrayerTimesWidget(prayerRepository.getPrayers(),prayerRepository.getNextPrayer(),prayerRepository.getCurrentPrayer(),Utils.getCurrentDateHijri());

        });

        // Check if the timer has reached zero
        if (_remainingTime.isNegative) {
          timer.cancel();
          if (widget.onTimerFinished != null) {
            widget.onTimerFinished!();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AutoSizeText(
        formattedTime,
        style: widget.style ?? Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  String formatDuration(Duration duration) {
    // Extract hours, minutes, and seconds from the duration
    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);

    String kHours = hours.toString().padLeft(2, '0');
    String kMinutes = minutes.toString().padLeft(2, '0');
    String kSeconds = seconds.toString().padLeft(2, '0');

    return '$kSeconds : $kMinutes : $kHours';

    // Convert each component to Arabic text
    // String arabicHours = ArabicNumbers().convert(hours.toString());
    // String arabicMinutes = ArabicNumbers().convert(minutes.toString());
    // String arabicSeconds = ArabicNumbers().convert(seconds.toString());

    // // return 'تبقى $arabicHours ساعة و $arabicMinutes دقيقة و $arabicSeconds ثانية';

    // if (hours == 0 && minutes == 0) {
    //   return 'تبقى $arabicSeconds ثانية';
    // }

    // if (hours == 0 && minutes < 3) {
    //   return 'تبقى $arabicMinutes دقيقة و $arabicSeconds ثانية';
    // }

    // if (hours == 0) {
    //   return 'تبقى $arabicMinutes دقيقة';
    // }

    // // Join the components with "و" in between
    // return '$arabicHours ساعة و $arabicMinutes دقيقة';
  }
}
