import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';

import '../../constants/constants.dart';
import '../../handlers/notification_alarm_handler.dart';

class MadhabSelectionDialog extends StatefulWidget {
  const MadhabSelectionDialog({super.key});

  @override
  MadhabSelectionDialogState createState() => MadhabSelectionDialogState();
}

class MadhabSelectionDialogState extends State<MadhabSelectionDialog> {
  Madhab? selectedMadhab = PrayerTimeCache.getMadhabFromCache();
  var repository = Get.find<PrayerTimeRepository>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.translate('calculateAsrTime')),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var madhabData in madhabList)
            RadioListTile<Madhab>(
              title: Text(madhabData['title']),
              subtitle: Text(madhabData['description']),
              value: Madhab.values[madhabData['madhab']],
              groupValue: selectedMadhab,
              onChanged: (Madhab? value) {
                setState(() {
                  selectedMadhab = value;
                });
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text(context.translate('cancel')),
        ),
        TextButton(
          onPressed: () async {
            if (selectedMadhab != null) {
              PrayerTimeCache.saveMadhabToCache(selectedMadhab!);
              await repository.initPrayerTimes();
              // cancel all alarms and re schedule new alarm for next prayer
              Get.find<NotificationAlarmHandler>().cancelAllAndNextPrayerSchedule(0);
              Get.forceAppUpdate();
              Get.back();
            }
          },
          child: Text(context.translate('confirmation')),
        ),
      ],
    );
  }
}
