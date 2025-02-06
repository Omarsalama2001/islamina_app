import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/data/cache/app_settings_cache.dart';
import 'package:islamina_app/pages/azkar_settings_page.dart';
import 'package:islamina_app/pages/prayer_settings_page.dart';
import 'package:islamina_app/pages/silent_page.dart';
import 'package:islamina_app/routes/app_pages.dart';
import 'package:islamina_app/utils/utils.dart';
import 'package:islamina_app/widgets/language_dialog_widget.dart';


class AppSettingsPage extends GetView {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        title: Text(
          context.translate('appSettings'),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              context.translate('public'),
              style: titleTextStyle!.copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          // ListTile(
          //   leading: const Icon(Icons.brightness_6_rounded),
          //   onTap: () => Get.dialog(const ChangeLanguageDialog()),
          //   title: Text(
          //     'لغة التطبيق',
          //     style: titleTextStyle,
          //   ),
          //   subtitle: Text(
          //     'العربية',
          //     style: subtitleTextStyle,
          //   ),
          //   dense: true,
          // ),
          ListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            onTap: () => Get.dialog(ChangeThemeDialog()),
            title: Text(
              context.translate('appTheme'),
              style: titleTextStyle,
            ),
            subtitle: Text(
              BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? Utils.themeModeToArabicText(AppSettingsCache.getThemeMode()) : AppSettingsCache.getThemeMode().name,
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              context.translate('appLange'),
              style: titleTextStyle,
            ),
            subtitle: LangageDialogWidget(),
          ),
          // LangageDialogWidget(),
          ListTile(
            leading: const Icon(Icons.app_settings_alt_rounded),
            onTap: () => Get.toNamed(Routes.QURAN_DISPLAY_SETTINGS),
            title: Text(
              context.translate('quran'),
              style: titleTextStyle,
            ),
            subtitle: Text(
              context.translate('quranSettings'),
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(FluentIcons.clock_12_regular),
            onTap: () => Get.to(() => const PrayerSettingsPage()),
            title: Text(
              context.translate('prayerTimes'),
              style: titleTextStyle,
            ),
            subtitle: Text(
              context.translate('prayerSettingsDescription'),
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
                 ListTile(
            leading: const Icon(FluentIcons.speaker_off_16_regular),
            onTap: () => Get.to(() => const SilentPage()),
            title: Text(
              context.translate('silent_settings'),
              style: titleTextStyle,
            ),
            subtitle: Text(
              context.translate('silent_settings_description'),
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(FlutterIslamicIcons.tasbih3),
            onTap: () => Get.to(() => AzkarSettingsPage()),
            title: Text(
              context.translate('azkar'),
              style: titleTextStyle,
            ),
            subtitle: Text(
              context.translate('azkarSettingsDescription'),
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
        ],
      ),
    );
  }
}

class ChangeThemeDialog extends StatelessWidget {
  ChangeThemeDialog({super.key});
  final theme = AppSettingsCache.getThemeMode().obs;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.translate('theme')),
      content: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              value: ThemeMode.light,
              groupValue: theme.value,
              title: Text(
                BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? Utils.themeModeToArabicText(ThemeMode.light) : ThemeMode.light.name,
              ),
              onChanged: (value) {
                theme.value = ThemeMode.light;
              },
            ),
            RadioListTile(
              value: ThemeMode.dark,
              groupValue: theme.value,
              title: Text(
                BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? Utils.themeModeToArabicText(ThemeMode.dark) : ThemeMode.dark.name,
              ),
              onChanged: (value) {
                theme.value = ThemeMode.dark;
              },
            ),
            RadioListTile(
              value: ThemeMode.system,
              groupValue: theme.value,
              title: Text(
                BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? Utils.themeModeToArabicText(ThemeMode.system) : ThemeMode.system.name,
              ),
              onChanged: (value) {
                theme.value = ThemeMode.system;
              },
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child:  Text(context.translate('cancel')),
        ),
        TextButton(
          onPressed: () {
            Get.back();

            AppSettingsCache.setThemeMode(themeMode: theme.value);
          },
          child:  Text(context.translate('confirmation')),
        ),
      ],
    );
  }
}

class ChangeLanguageDialog extends StatelessWidget {
  const ChangeLanguageDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اللغة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            value: 'ar',
            groupValue: AppSettingsCache.getLanguage(),
            title: const Text(
              'العربية',
            ),
            onChanged: (_) => AppSettingsCache.setLanguage(lang: 'ar'),
          ),
          RadioListTile(
            value: 'en',
            groupValue: AppSettingsCache.getLanguage(),
            title: const Text(
              'الإنجليزية',
            ),
            onChanged: (_) => AppSettingsCache.setLanguage(lang: 'en'),
          ),
        ],
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () => Get.back(),
      //     child: const Text('إلغاء'),
      //   ),
      //   TextButton(
      //     onPressed: () {
      //       Get.back();

      //       AppSettingsCache.setThemeMode(themeMode: theme.value);
      //     },
      //     child: const Text('تأكيد'),
      //   ),
      // ],
    );
  }
}
