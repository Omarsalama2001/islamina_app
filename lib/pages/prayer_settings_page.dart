import 'package:adhan/adhan.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';
import 'package:islamina_app/data/repository/prayer_time_repository.dart';
import 'package:islamina_app/handlers/notification_alarm_handler.dart';
import 'package:islamina_app/pages/calc_method_selector_page.dart';
import 'package:islamina_app/services/notification_service.dart';
import 'package:islamina_app/utils/dialogs/select_madhab_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../constants/constants.dart';
import '../controllers/prayer_time_controller.dart';

class PrayerSettingsPage extends GetView {
  const PrayerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PrayerTimeController>();

    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    // Build the UI
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('prayerTimesSettings')),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              context.translate('calculationMethod'),
              style: theme.textTheme.titleSmall!.copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          ListTile(
            onTap: () {
              Get.to(() => const CalculationMethodSelectorPage());
            },
            dense: true,
            title: Text(
              context.translate('calculateMethod'),
              style: titleTextStyle,
            ),
            subtitle: Text(context.translate(calculationMethodList[PrayerTimeCache.getCalculationMethodFromCache().index]['title']), style: subtitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.dialog(const MadhabSelectionDialog());
            },
            dense: true,
            title: Text(
              context.translate('calculateAsrTime'),
              style: titleTextStyle,
            ),
            subtitle: Text(context.translate(madhabList[PrayerTimeCache.getMadhabFromCache().index]['title']), style: subtitleTextStyle),
          ),
          const Divider(),
          ListTile(
            title: Text(
              context.translate('adhan_sound'),
              style: theme.textTheme.titleSmall!.copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          GetBuilder<PrayerTimeController>(
            init: PrayerTimeController(),
            builder: (controller) {
              return SwitchListTile(
                thumbIcon: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Icon(
                      Icons.notifications_active_outlined,
                      color: theme.primaryColorDark,
                    );
                  } else {
                    return const Icon(Icons.notifications_off_outlined);
                  }
                }),
                value: controller.showBeforePrayerSound,
                title: Text(
                  context.translate('qurater_after_sound'),
                  style: titleTextStyle,
                ),
                onChanged: (value) async {
                  controller.showBeforePrayerSound = value;
                  await controller.toggleShowBeforePrayerSound(value);
                  PrayerTimeCache.saveBeforePrayerNotificationSound(showNotification: value);
                  controller.update();
                },
              );
            },
          ),
          GetBuilder<PrayerTimeController>(
            init: PrayerTimeController(),
            builder: (controller) {
              return SwitchListTile(
                thumbIcon: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Icon(
                      Icons.notifications_active_outlined,
                      color: theme.primaryColorDark,
                    );
                  } else {
                    return const Icon(Icons.notifications_off_outlined);
                  }
                }),
                value: controller.showIqamahPrayerSound,
                title: Text(
                  context.translate('qurater_before_sound'),
                  style: titleTextStyle,
                ),
                onChanged: (value) async {
                  controller.showIqamahPrayerSound = value;
                  await controller.toggleShowIqamahPrayerSound(value);
                  PrayerTimeCache.saveIqamahPrayerNotificationSound(showNotification: value);
                  controller.update();
                },
              );
            },
          ),
          GetBuilder<PrayerTimeController>(
            init: PrayerTimeController(),
            builder: (controller) {
              return SwitchListTile(
                thumbIcon: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Icon(
                      Icons.notifications_active_outlined,
                      color: theme.primaryColorDark,
                    );
                  } else {
                    return const Icon(Icons.notifications_off_outlined);
                  }
                }),
                value: controller.isTakbertan,
                title: Text(
                  context.translate("two_takbirs"),
                  style: titleTextStyle,
                ),
                onChanged: (value) async {
                  controller.isTakbertan = value;

                  // PrayerTimeCache.savePrayerNotificationMode(prayer: prayer, notificationMode: value);
                  // controller.update();
                },
              );
            },
          ),
          GetBuilder<PrayerTimeController>(
            init: PrayerTimeController(),
            builder: (controller) {
              return SwitchListTile(
                thumbIcon: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Icon(
                      Icons.notifications_active_outlined,
                      color: theme.primaryColorDark,
                    );
                  } else {
                    return const Icon(Icons.notifications_off_outlined);
                  }
                }),
                value: controller.secondAdhnForJommaPrayer,
                subtitle: Text(
                  PrayerTimeCache.getSecondAhdanTimeForJommaPrayer()['timeChange'].toString(),
                  style: subtitleTextStyle,
                ),
                title: InkWell(
                  onTap: () {
                    if (controller.secondAdhnForJommaPrayer) {
                      showModalBottomSheet(
                        showDragHandle: true,
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) {
                          return GetBuilder<PrayerTimeController>(
                              init: PrayerTimeController(),
                              builder: (controller) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                       context.translate("secondGomaaAthanTitle"),
                                        style: GoogleFonts.aBeeZee(fontSize: 20.sp, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      ToggleSwitch(
                                        animate: true,
                                        animationDuration: 15,
                                        customWidths: [70.w, 70.w],
                                        initialLabelIndex: controller.afterOrBeforeJommaPrayer,
                                        totalSwitches: 2,
                                        labels: [
                                         context.translate("before"),
                                           context.translate("after"),
                                        ],
                                        onToggle: (index) {
                                          controller.afterOrBeforeJommaPrayer = index!;
                                          controller.update();
                                        },
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Text(
                                       context.translate("numberOfMinutes"),
                                        style: GoogleFonts.aBeeZee(fontSize: 20.sp, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      NumberPicker(
                                          axis: Axis.horizontal,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          selectedTextStyle: GoogleFonts.aBeeZee(fontSize: 18.sp, fontWeight: FontWeight.bold, color: context.theme.primaryColor),
                                          // haptics: true,
                                          minValue: 0,
                                          maxValue: 60,
                                          step: 1,
                                          value: controller.secondAdhanTimeChange,
                                          onChanged: (value) {
                                            controller.secondAdhanTimeChange = value;
                                            controller.update();
                                          }),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: MainElevatedButton(
                                              text: context.translate("done"),
                                              onPressed: () {
                                                controller.saveSecondAhdanTimeForJommaPrayer(controller.secondAdhanTimeChange, controller.afterOrBeforeJommaPrayer);
                                                Get.find<PrayerTimeRepository>().initPrayerTimes();
                                                Get.find<NotificationAlarmHandler>().onInit();
                                                Get.find<NotificationService>().onInit();
                                                print(PrayerTimeCache.getSecondAhdanTimeForJommaPrayer()['timeChange']);
                                                Get.back();
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: MainElevatedButton(
                                            color: WidgetStatePropertyAll(Colors.grey.shade400),
                                            text: context.translate("cancel"),
                                            onPressed: () {
                                              controller.afterOrBeforeJommaPrayer = PrayerTimeCache.getSecondAhdanTimeForJommaPrayer()['afterOrBeforeJommaPrayer'];
                                              controller.secondAdhanTimeChange = PrayerTimeCache.getSecondAhdanTimeForJommaPrayer()['timeChange'];
                                              Get.back();
                                            },
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                      );
                    }
                  },
                  child: Text(
                    context.translate("secondGomaaAthan"),
                    style: titleTextStyle,
                  ),
                ),
                onChanged: (value) async {
                  controller.secondAdhnForJommaPrayer = value;
                  await controller.toggleSecondAdhnForJommaPrayer(value);
                  // PrayerTimeCache.savePrayerNotificationMode(prayer: prayer, notificationMode: value);
                  // controller.update();
                },
              );
            },
          ),
          GetBuilder<PrayerTimeController>(
            builder: (_) {
              return controller.isTakbertan
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: controller.athanAudios.length,
                      itemBuilder: (context, index) {
                        var item = controller.athanAudios[index];
                        return RadioListTile(
                          groupValue: index,
                          // value: 'الأقصى',
                          // value: item['name'],
                          // value: controller.athanAudios[controller.selectedAudioIndex]
                          // ['name'],
                          value: controller.selectedAudioIndex,
                          title: Text(
                            item['name'],
                            style: titleTextStyle,
                          ),
                          secondary: GestureDetector(
                            onTap: () {
                              if (!controller.athanAudios[index]['isStart']) {
                                controller.startAudio(item['src'], index);
                                controller.update();
                              } else {
                                controller.stopAudio(index);
                              }
                            },
                            child: item['isStart'] ? const Icon(FluentIcons.stop_24_regular) : const Icon(FluentIcons.play_24_regular),
                          ),
                          onChanged: (_) {
                            controller.selectedAudioIndex = index;
                            AppSettingsCache.setSelectedAudioIndex(index);
                            Get.find<NotificationAlarmHandler>().cancelAllAndNextPrayerSchedule(0);
                            controller.update();
                          },
                        );
                      },
                    );
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              context.translate('prayers_alert'),
              style: theme.textTheme.titleSmall!.copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: Prayer.values.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox();
              }
              var prayer = Prayer.values[index];
              var isNotificationEnabled = PrayerTimeCache.getPrayerNotificationMode(prayer: prayer);

              return Obx(() {
                return SwitchListTile(
                  thumbIcon: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Icon(
                        Icons.notifications_active_outlined,
                        color: theme.primaryColorDark,
                      );
                    } else {
                      return const Icon(Icons.notifications_off_outlined);
                    }
                  }),
                  value: isNotificationEnabled.value,
                  title: Text(
                    BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? controller.repository.getPrayerNameArabic(prayer: Prayer.values[index]) : controller.repository.getPrayers()[index - 1].englishName,
                    style: titleTextStyle,
                  ),
                  onChanged: (value) {
                    isNotificationEnabled.value = value;
                    PrayerTimeCache.savePrayerNotificationMode(prayer: prayer, notificationMode: value);
                    controller.update();
                  },
                );
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                context.translate('notePrayerSeettings'),
                style: subtitleTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
