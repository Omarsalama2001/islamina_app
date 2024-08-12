import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/constants/all_activites.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/handlers/notification_alarm_handler.dart';
import 'package:islamina_app/main.dart';
import 'package:islamina_app/widgets/arabic_timer_widget.dart';
import 'package:islamina_app/widgets/custom_message_button_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/main_controller.dart';
import 'package:islamina_app/utils/utils.dart';

import '../widgets/daily_content_widget.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          // onTap: () => Get.to(const TestSound()),
          child: Text(
            appName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Text(
            'Islamina',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
          const Gap(10),
        ],
        // actions: [
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         Utils.getCurrentDate(),
        //         style: theme.primaryTextTheme.labelMedium,
        //       ),
        //       Text(
        //         Utils.getCurrentDateHijri(),
        //         style: theme.primaryTextTheme.labelMedium,
        //       ),
        //     ],
        //   ),
        //   const Gap(10),
        // ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //   padding: const EdgeInsetsDirectional.only(
            //       top: 10.0, end: 25, start: 25),
            //   child: FittedBox(
            //     child: bismillahTextWidget(),
            //   ),
            // ),
            // const Padding(
            //   padding: EdgeInsets.all(10.0),
            //   child: CurrentPrayerDetailsWidget(),
            // ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: PrayerTimeCardDetailsView(),
            ),
            Row(
              children: [
                ...List.generate(
                  4,
                  (index) {
                    var activity = Activites.shortcuts2[index];
                    return Expanded(
                      child: GestureDetector(
                        onTap: activity['onTap'],
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              activity['icon'],
                              width: 15.w,
                            ),
                            SizedBox(
                              // width: 64.w,
                              child: Text(
                                activity['text'],
                                style: Theme.of(context).textTheme.titleSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ).paddingSymmetric(horizontal: 10),
            const Gap(5),
            Row(
              children: [
                ...List.generate(
                  4,
                  (index) {
                    var activity = Activites.shortcuts2[index + 4];
                    return Expanded(
                      child: GestureDetector(
                        onTap: activity['onTap'],
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              activity['icon'],
                              width: 15.w,
                            ),
                            SizedBox(
                              // width: 64.w,
                              child: Text(
                                activity['text'],
                                style: Theme.of(context).textTheme.titleSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ).paddingSymmetric(horizontal: 10),
            const Gap(10),
            GetBuilder<MainController>(builder: (context) {
              return Column(
                children: [
                  DailyContentContainer(
                    description: controller.dailyContent?.dua ?? '',
                    title: 'دعاء اليوم',
                  ),
                  DailyContentContainer(
                    description:
                        '${controller.dailyContent?.generalInfo['content']}',
                    subtitle:
                        '${controller.dailyContent?.generalInfo['title']}',
                    title: 'معلومة',
                  ),
                  DailyContentContainer(
                    description: '${controller.dailyContent?.hadith['text']}',
                    subtitle: '${controller.dailyContent?.hadith['rwi']}',
                    title: 'حديث اليوم',
                  ),
                  DailyContentContainer(
                    description: '${controller.dailyContent?.verse['ayah']}',
                    subtitle: '${controller.dailyContent?.verse['surah']}',
                    title: 'آية اليوم',
                  ),
                  DailyContentContainer(
                    description: '${controller.dailyContent?.asmOfAllah.ttl}',
                    subtitle: '\n${controller.dailyContent?.asmOfAllah.dsc}',
                    descriptionTextStyle: theme.textTheme.displayLarge,
                    subtitleTextStyle: theme.textTheme.labelLarge,
                    title: 'اسماء الله الحسنى',
                  ),
                ],
              );
            }),
            const Gap(25),
          ],
        ),
      ),
    );
  }
}

class PrayerTimeCardDetailsView extends StatelessWidget {
  const PrayerTimeCardDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    PrayerTimeRepository repository = Get.find();

    var timeLeftKey = GlobalKey<ArabicTimerWidgetState>();

    return GetBuilder<PrayerTimeController>(
      init: PrayerTimeController(),
      builder: (controller) {
        return controller.repository.coordinates == null
            ? Center(
                child: MessageWithButtonWidget(
                  title:
                      'الرجاء السماح بصلاحيات الموقع مرة واحدة على الاقل للحصول على بيانات اوقات الصلاة',
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
              )
            : Container(
                width: Get.width,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: _prayerTimeBackgroundImage(repository),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(15, crossAxisExtent: Get.width),

                        // Get Location Text Decoded
                        const LocationTextWidget(),
                        // Gap(15, crossAxisExtent: Get.width),
                        const Gap(5),
                        Text(
                          '${repository.getNextPrayer().name} بعد',
                          style:
                              context.theme.textTheme.headlineSmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(10),
                        ArabicTimerWidget(
                          key: timeLeftKey,
                          targetDate: repository.getNextPrayer().fulldate,
                          style:
                              context.theme.textTheme.headlineSmall!.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                          onTimerFinished: () {
                            Get.forceAppUpdate();
                          },
                        ),
                        const Gap(20),
                        Column(
                          children: [
                            Text(
                              Utils.getCurrentDateHijri(),
                              style:
                                  context.theme.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              Utils.getCurrentDate(),
                              style:
                                  context.theme.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            color: context.theme.primaryColor.withOpacity(.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              var prayerTime = repository.getPrayers()[index];
                              return Column(
                                children: [
                                  Text(
                                    prayerTime.name,
                                    style: context.theme.textTheme.titleMedium!
                                        .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(5),
                                  switch (index) {
                                    0 => Image.asset(
                                        'assets/images/fajr.png',
                                        width: 25,
                                      ),
                                    1 => Image.asset(
                                        'assets/images/fajr.png',
                                        width: 25,
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
                                      ),
                                    5 => Image.asset(
                                        'assets/images/isha.png',
                                        width: 25,
                                      ),
                                    int() => Image.asset(
                                        'assets/images/asr.png',
                                        width: 25,
                                      ),
                                  },
                                  const Gap(5),
                                  Text(
                                    prayerTime.time,
                                    style: context.theme.textTheme.titleSmall!
                                        .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        // const Gap(15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Text(
                        //       'منتصف الليل : 11:00',
                        //       style:
                        //           context.theme.textTheme.titleMedium!.copyWith(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     Text(
                        //       'الثلث الأخير : 02:00',
                        //       style:
                        //           context.theme.textTheme.titleMedium!.copyWith(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const Gap(15),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  DecorationImage _prayerTimeBackgroundImage(PrayerTimeRepository repository) {
    return DecorationImage(
      image: repository.getCurrentPrayer().name == 'الفجر'
          ? const AssetImage(
              'assets/svg/praying_time/morning.png',
            )
          : repository.getNextPrayer().name == 'الظهر'
              ? const AssetImage(
                  'assets/svg/praying_time/noon.png',
                )
              : repository.getNextPrayer().name == 'العصر'
                  ? const AssetImage(
                      'assets/svg/praying_time/afternoon.png',
                    )
                  : repository.getNextPrayer().name == 'المغرب'
                      ? const AssetImage(
                          'assets/svg/praying_time/evening.png',
                        )
                      : const AssetImage(
                          'assets/svg/praying_time/night.png',
                        ),
      fit: BoxFit.cover,
    );
  }
}

class LocationTextWidget extends GetView<PrayerTimeController> {
  const LocationTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.repository.getLocationTextDecoded(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.split(',');
          String result = _sortLocationData(data);
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                FluentIcons.location_ripple_20_regular,
                color: Colors.orange,
                size: 29,
              ),
              const Gap(5),
              Text(
                // snapshot.data!,
                result,
                textAlign: TextAlign.start,
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        } else {
          final data = controller.repository.getLocationTextCoded().split(',');
          String result = _sortLocationData(data);
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                FluentIcons.location_ripple_20_regular,
                color: Colors.orange,
                size: 29,
              ),
              const Gap(5),
              Text(
                result,
                textDirection: TextDirection.ltr,
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  String _sortLocationData(List<String> data) {
    String result = '';
    for (var i = 0; i < data.length; i++) {
      if (data[i] == '' || data[i] == ' ' || data[i] == '' || data[i] == '  ') {
        continue;
      } else {
        if (i == data.length - 1) {
          result += data[i];
        } else {
          result += '${data[i]}\n';
        }
      }
    }
    return result;
  }
}
