import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:islamina_app/bindings/azkar_categories_binding.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/data/cache/prayer_time_cache.dart';

class SilentPage extends StatelessWidget {
  const SilentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.translate('silent_settings')),
          titleTextStyle: context.theme.primaryTextTheme.titleMedium,
        ),
        body: GetBuilder<PrayerTimeController>(
          init: PrayerTimeController(),
          builder: (controller) {
            return SwitchListTile(
              thumbIcon: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Icon(
                    Icons.notifications_active_outlined,
                    color: context.theme.primaryColorDark,
                  );
                } else {
                  return const Icon(Icons.notifications_off_outlined);
                }
              }),
              value: controller.isSilentDuringPrayer,
              title: Text(
                context.translate('silent_during_prayer'),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
              ),
              onChanged: (value) async {
                controller.isSilentDuringPrayer = value;
                await controller.toggleSilentDuringPrayer(value);
                PrayerTimeCache.saveSilentDuringPrayer(value);
                controller.update();
              },
            );
          },
        ));
  }
}
