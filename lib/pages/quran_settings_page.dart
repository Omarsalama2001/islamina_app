import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/controllers/quran_reading_controller.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/data/cache/quran_reader_cache.dart';
import 'package:islamina_app/data/models/quran_verse_model.dart';
import 'package:islamina_app/pages/quran_reading_page.dart';
import 'package:islamina_app/routes/app_pages.dart';
import 'package:islamina_app/utils/dialogs/update_location_dialog.dart';
import 'package:islamina_app/utils/sheets/sheet_methods.dart';
import 'package:islamina_app/widgets/custom_container.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../controllers/quran_audio_player_controller.dart';
import '../controllers/quran_settings_controller.dart';

class QuranSettingsPage extends GetView<QuranSettingsController> {
  const QuranSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = BlocProvider.of<ThemeCubit>(context).locale;
    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    var defaultSubtitleTextStyle = theme.textTheme.labelMedium!.copyWith(color: theme.hintColor);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: theme.textTheme.titleMedium,
        title: Text(
          Get.context!.translate('quranSettings'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    Get.context!.translate('presentation'),
                    style: titleTextStyle!.copyWith(color: theme.primaryColor),
                  ),
                  dense: true,
                ),
                GetBuilder<QuranSettingsController>(
                  builder: (controller) {
                    return SwitchListTile(
                      dense: true,
                      title: Text(
                        Get.context!.translate('Coloring_marks'),
                        style: titleTextStyle,
                      ),
                      subtitle: Text(
                        Get.context!.translate('coloring_sub'),
                        style: subtitleTextStyle,
                      ),
                      value: controller.settingsModel.isMarkerColored,
                      onChanged: (value) => controller.onMarkerColorSwitched(value),
                    );
                  },
                ),
                GetBuilder<QuranSettingsController>(
                  builder: (controller) {
                    return SwitchListTile(
                      dense: true,
                      title: Text(
                        context.translate("Display_format"),
                        style: titleTextStyle,
                      ),
                      subtitle: Text(
                        context.translate("Display_format_sub"),
                        style: subtitleTextStyle,
                      ),
                      value: controller.settingsModel.isDisplayTwoPage,
                      onChanged: (value) => controller.onDisplayTwoPage(value),
                    );
                  },
                ),
                GetBuilder<QuranSettingsController>(
                  builder: (controller) {
                    return SwitchListTile(
                      dense: true,
                      title: Text(
                        context.translate('Dynamic_display'),
                        style: titleTextStyle,
                      ),
                      subtitle: Text(
                        context.translate("Dynamic_display_sub"),
                        style: subtitleTextStyle,
                      ),
                      value: controller.settingsModel.isAdaptiveView,
                      onChanged: (value) => controller.onDisplayOptionChanged(value),
                    );
                  },
                ),
                GetBuilder<QuranSettingsController>(builder: (controller) {
                  return IgnorePointer(
                      ignoring: !controller.settingsModel.isAdaptiveView,
                      child: Opacity(
                        opacity: !controller.settingsModel.isAdaptiveView ? 0.5 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              title: Text(context.translate('fontSize')),
                              dense: true,
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: theme.colorScheme.primaryContainer,
                                inactiveTickMarkColor: theme.colorScheme.primary,
                                inactiveTrackColor: theme.colorScheme.primaryContainer,
                              ),
                              child: GetBuilder<QuranSettingsController>(
                                builder: (controller) {
                                  return Slider(
                                    value: controller.settingsModel.displayFontSize,
                                    min: 25,
                                    max: 45,
                                    // label: ArabicNumbers().convert(
                                    //   '${controller.settingsModel.displayFontSize}',
                                    // ),
                                    label: '${controller.settingsModel.displayFontSize}',
                                    onChanged: (value) => controller.onDisplayFontSizeChanged(value),
                                    divisions: 4,
                                  );
                                },
                              ),
                            ),
                            ListTile(
                              title: Text(
                                context.translate('preview'),
                              ),
                              dense: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: CustomContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GetBuilder<QuranSettingsController>(
                                    builder: (controller) {
                                      return Text(
                                        previewVerse,
                                        style: TextStyle(
                                          fontFamily: 'QCF_P596',
                                          fontSize: controller.settingsModel.displayFontSize,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                }),
                const Gap(15),
                const Divider(),
                ListTile(
                  title: Text(
                    context.translate('operating'),
                    style: titleTextStyle.copyWith(color: theme.primaryColor),
                  ),
                  dense: true,
                ),
                ListTile(
                  onTap: () => selectReaderSheet().then((value) {
                    controller.update();
                    Get.find<QuranAudioPlayerBottomBarController>().selectedReader.value = QuranReaderCache.getSelectedReaderFromCache();
                  }),
                  title: Text(
                    context.translate('reader'),
                    style: titleTextStyle,
                  ),
                  subtitle: GetBuilder<QuranSettingsController>(
                    builder: (controller) {
                      return Text(locale.languageCode == 'ar' ? QuranReaderCache.getSelectedReaderFromCache().name : QuranReaderCache.getSelectedReaderFromCache().englishName, style: subtitleTextStyle);
                    },
                  ),
                  dense: true,
                ),
                GetBuilder<QuranSettingsController>(
                  builder: (controller) {
                    return SwitchListTile(
                      dense: true,
                      title: Text(
                        context.translate('Highlight_word'),
                        style: titleTextStyle,
                      ),
                      subtitle: Text(
                        context.translate('Highlight_word_sub'),
                        style: subtitleTextStyle,
                      ),
                      value: controller.settingsModel.wordByWordListen,
                      onChanged: (value) => controller.onWordByWordSwitched(value),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    context.translate('downloads'),
                    style: titleTextStyle.copyWith(color: theme.primaryColor),
                  ),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(
                    FluentIcons.reading_mode_mobile_20_regular,
                    color: theme.hintColor,
                  ),
                  onTap: () => Get.toNamed(Routes.RECITER_DOWNLOAD_MANAGER),
                  title: Text(
                    context.translate('sounds'),
                    style: titleTextStyle,
                  ),
                  subtitle: Text(
                    context.translate('sounds_sub'),
                    style: defaultSubtitleTextStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    FluentIcons.book_letter_20_regular,
                    color: theme.hintColor,
                  ),
                  onTap: () => Get.toNamed(Routes.TAFSIR_DOWNLOAD_MANAGER),
                  title: Text(
                    context.translate('tafsir'),
                    style: titleTextStyle,
                  ),
                  subtitle: Text(
                    context.translate('tafsir_sub'),
                    style: defaultSubtitleTextStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    FluentIcons.book_letter_20_regular,
                    color: theme.hintColor,
                  ),
                  onTap: () async {
                    controller.downloadPDF();

                    // // controller.loading.value = true; // Start loading state
                    // // try {
                    // //   final quranReadingController = Get.find<QuranReadingController>();

                    // //   List<Word> allWords = [];
                    // //   List<QuranExpandedPageView> quranPages = [];

                    // //   for (int i = 0; i < quranReadingController.quranForKhatma.length; i++) {
                    // //     allWords = quranReadingController.quranForKhatma[i]!
                    // //         .verses
                    // //         .expand((verse) => verse.words)
                    // //         .toList();

                    // //     quranPages.add(QuranExpandedPageView(
                    // //       page: quranReadingController.quranForKhatma[i]!,
                    // //       allWords: allWords,
                    // //     ));
                    // //   }

                    // //   // Navigate to the download page
                    // //   Navigator.push(
                    // //     context,
                    // //     MaterialPageRoute(
                    // //       builder: (context) => DownloadQuran(quranPages: quranPages),
                    // //     ),
                    // //   );
                    // } catch (e) {
                    //   // Handle any errors
                    //   print("Error: $e");
                    // } finally {
                    //   // controller.loading.value = false; // Stop loading state
                    // }
                  },
                  title: Text(
                    context.translate('quran_download'),
                    style: titleTextStyle,
                  ),
                  subtitle: Text(
                    context.translate('quran_download_sub'),
                    style: defaultSubtitleTextStyle,
                  ),
                ),
                const Gap(25),
              ],
            ),
            Obx(() {
              if (controller.loading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
