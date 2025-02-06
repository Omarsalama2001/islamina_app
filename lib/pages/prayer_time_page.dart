import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/handlers/notification_alarm_handler.dart';
import 'package:islamina_app/pages/prayer_settings_page.dart';
import 'package:islamina_app/utils/utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/prayer_time_controller.dart';
import '../widgets/current_prayer_details_widget.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_message_button_widget.dart';

class PrayerTimePage extends GetView<PrayerTimeController> {
  const PrayerTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build the UI
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('prayerTimes')),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
        actions: [
          IconButton(
            onPressed: controller.updateLocation,
            icon: const Icon(FluentIcons.my_location_16_regular),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const PrayerSettingsPage());
            },
            icon: const Icon(FluentIcons.settings_16_regular),
          ),
        ],
      ),
      body: GetBuilder<PrayerTimeController>(builder: (controller) {
        // Check if the location is granted and coordinates are not null
        return controller.repository.coordinates != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildUserLocation(),
                    const Gap(15),
                    CurrentPrayerDetailsWidget(
                      onTimerFinishedCallback: () {
                        Get.forceAppUpdate();
                      },
                    ),
                    const Gap(15),
                    _buildPrayerListView(),
                  ],
                ),
              )
            // If coordinates are null, ask the user to grant location permission
            : Center(
                child: MessageWithButtonWidget(
                  title: 'الرجاء السماح بصلاحيات الموقع مرة واحدة على الاقل للحصول على بيانات اوقات الصلاة',
                  buttonText: 'إعطاء صلاحية',
                  onTap: () async {
                    await controller.repository.getCoordinatesFromLocation();

                    await controller.repository.initPrayerTimes();
                    if (controller.repository.coordinates != null) {
                      // Start a new alarm after the location has been updated
                      Get.find<NotificationAlarmHandler>().onInit();
                    }
                    controller.update();
                  },
                ),
              );
      }),
    );
  }

  // Widget to build the user location display
  Widget _buildUserLocation() {
    return CustomContainer(
      useMaterial: true,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
            ),
            Expanded(
              child: FutureBuilder(
                future: controller.repository.getLocationTextDecoded(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    );
                  } else {
                    return Text(
                      controller.repository.getLocationTextCoded(),
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget to build the prayer time list view
  Widget _buildPrayerListView() {
    final theme = Theme.of(Get.context!);
    var prayerTime = controller.repository.getPrayers();

    // List prayerTimes = controller.repository.getPrayerTimesByDate(
    //   DateTime.now(),
    // );

    return CustomContainer(
      child: Column(
        children: [
          Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Utils.getCurrentDate(),
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    Utils.getCurrentDateHijri(),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: prayerTime.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final prayer = prayerTime[index];
              // final textStyle = theme.textTheme.labelLarge;
              final textStyle = theme.textTheme.titleMedium;

              return ColoredBox(
                color: Get.find<PrayerTimeRepository>().getNextPrayer().name == prayer.name ? theme.primaryColor.withOpacity(0.3) : Colors.transparent,
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: index == prayerTime.length - 1 ? const Radius.circular(9.0) : Radius.zero,
                      ),
                    ),
                    dense: false,
                    leading: switch (index) {
                      0 => Image.asset(
                          'assets/images/fajr.png',
                          width: 25,
                          color: context.textTheme.titleSmall?.color ?? Colors.black,
                        ),
                      1 => Image.asset(
                          'assets/images/fajr.png',
                          width: 25,
                          color: context.textTheme.titleSmall?.color ?? Colors.black,
                        ),
                      2 => Image.asset(
                          'assets/images/dhuhr.png',
                          width: 25,
                          color: Colors.orange,
                        ),
                      3 => Image.asset(
                          'assets/images/asr.png',
                          width: 25,
                          color: Colors.orange,
                        ),
                      4 => Image.asset(
                          'assets/images/maghrib.png',
                          width: 25,
                          color: context.textTheme.titleSmall?.color ?? Colors.black,
                        ),
                      5 => Image.asset(
                          'assets/images/isha.png',
                          width: 25,
                          color: context.textTheme.titleSmall?.color ?? Colors.black,
                        ),
                      int() => Image.asset(
                          'assets/images/asr.png',
                          width: 25,
                          color: context.textTheme.titleSmall?.color ?? Colors.black,
                        ),
                    },
                    title: Text(
                      BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? prayer.name : prayer.englishName,
                      style: textStyle,
                    ),
                    trailing: buildTileTrailing(index, prayer)),
              );
            },
          )
        ],
      ),
    );
  }

  buildTileTrailing(int index, prayer) {
    final theme = Theme.of(Get.context!);
    final textStyle = theme.textTheme.titleMedium;
    var prayerTime = controller.repository.getPrayers();

    List prayerTimes = controller.repository.getPrayerTimesByDate(
      DateTime.now(),
    );
    // print("Initial Value: ${controller.prayerChangeTimes[index]}");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 10.w,
          child: NumberPicker(
           decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          selectedTextStyle: GoogleFonts.aBeeZee(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Get. theme.primaryColor),
            minValue: -30,
            maxValue: 30,
            value: controller.repository.changeTimes![index],
            itemCount: 1,
            step: 1,
            onChanged: (value) {
              controller.changePrayerTime(index, value);
              prayerTimes = controller.repository.getPrayerTimesByDate(
                DateTime.now(),
              );
              controller.repository.initPrayerTimes();
              Get.find<NotificationAlarmHandler>().cancelAllAndNextPrayerSchedule(0);
              // controller.update();
            },
          ),
        ),
        const Gap(25),
        Text(
          prayerTimes[index],
          style: textStyle,
          textAlign: TextAlign.start,
        ),
        // Text(
        //   ArabicNumbers().convert(prayer.time),
        //   style: textStyle,
        //   textAlign: TextAlign.start,
        // ),
        // const Gap(15),
        // Text(
        //   prayer.amPmAr,
        //   textAlign: TextAlign.start,
        //   style: textStyle,
        //   textDirection: TextDirection.ltr,
        // ),
        const Gap(15),
        Icon(
          prayer.isNotificationEnabled.value ? Icons.notifications_active_outlined : Icons.notifications_off_outlined,
          color: prayer.isNotificationEnabled.value ? theme.primaryColor : theme.hintColor,
          size: 20,
        ),
      ],
    );
  }
}
