import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:islamina_app/bindings/tafsir_details_binding.dart';
import 'package:islamina_app/controllers/quran_audio_player_controller.dart';
import 'package:islamina_app/controllers/quran_audio_player_settings_controller.dart';
import 'package:islamina_app/controllers/quran_reading_controller.dart';
import 'package:islamina_app/controllers/tafsir_details_controller.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/data/cache/quran_reader_cache.dart';
import 'package:islamina_app/data/models/quran_bookmark.dart';
import 'package:islamina_app/data/models/quran_play_range_model.dart';
import 'package:islamina_app/data/models/quran_verse_model.dart';
import 'package:islamina_app/pages/tafisr_details_page.dart';
import 'package:islamina_app/utils/sheets/ayah_bottom_sheet.dart';
import 'package:islamina_app/utils/sheets/sheet_methods.dart';
import 'package:islamina_app/utils/utils.dart';
import 'package:quran/quran.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../data/cache/audio_settings_cache.dart';
import '../../../../../services/audio/audio_manager.dart';
import '../../../../../widgets/custom_progress_indicator.dart';
import '../routes/app_pages.dart';
import 'package:quran/quran.dart' as quran;

class QuranAudioPlayerBottomBar extends GetView<QuranAudioPlayerBottomBarController> {
  const QuranAudioPlayerBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    QuranReadingController quranReadingController = Get.find();
    return BottomAppBar(
      height: 75,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      elevation: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Obx(
              () => !controller.isControlsVisible.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controller.isAyahSelected.value
                            ? Row(
                                children: [
                                  // play
                                  IconButton(
                                    icon: const Icon(
                                      FluentIcons.play_circle_48_regular,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      QuranAudioPlayerBottomBarController controller = Get.find();

                                      QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;

                                      if (verse != null) {
                                        controller.onMainPlayPressed(
                                          playRangeModel: QuranPlayRangeModel(
                                            startSurah: verse.surahNumber,
                                            endsSurah: verse.surahNumber,
                                            startVerse: verse.verseNumber,
                                            endsVerse: getVerseCount(
                                              verse.surahNumber,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  // tafseer
                                  IconButton(
                                    icon: const Icon(
                                      FluentIcons.book_question_mark_24_regular,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                      if (verse != null) {
                                        try {
                                          // Try to get the TafsirDetailsController instance
                                          final controller = Get.find<TafsirDetailsController>();
                                          controller.surahNumber.value = verse.surahNumber;
                                          controller.verseNumber.value = verse.verseNumber;
                                          Get.to(() => const TafsirDetailsPage(), fullscreenDialog: true);
                                        } catch (e, stackTrace) {
                                          log(e.toString(), stackTrace: stackTrace);
                                        }
                                        // Navigate to TafsirDetailsPage
                                        Get.to(
                                          () => const TafsirDetailsPage(),
                                          arguments: {'surahNumber': verse.surahNumber, 'verseNumber': verse.verseNumber},
                                          binding: TafsirDetailsBinding(),
                                          fullscreenDialog: true,
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Get.put(AyahBottomSheetController()).isBookmarked.value ? const Icon(FluentIcons.bookmark_off_20_regular) : const Icon(FluentIcons.bookmark_add_20_regular),
                                    onPressed: () async {
                                      final ayahController = Get.put(AyahBottomSheetController());
                                      QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                      if (verse != null) {
                                        ayahController.bookmark = Bookmark(
                                          surah: verse.surahNumber,
                                          verse: verse.verseNumber,
                                        );
                                        ayahController.onBookmarkPressed();
                                      }
                                    },
                                    // onPressed: ayahController.onBookmarkPressed,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.translate),
                                    onPressed: () async {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          useSafeArea: true,
                                          context: context,
                                          builder: (context) => SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          IconButton(
                                                              icon: const Icon(Icons.copy),
                                                              onPressed: () async {
                                                                QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                                                if (verse != null) {
                                                                  final shareText = '${getSurahNameArabic(verse.surahNumber)} (الآية ${verse.verseNumber})\n ${getVerse(verse.surahNumber, verse.verseNumber)}\n ${getVerseTranslation(verse.surahNumber, verse.verseNumber, translation: quranReadingController.translation)}';
                                                                  Utils.copyToClipboard(text: shareText);
                                                                }
                                                              }),
                                                          IconButton(
                                                              icon: const Icon(Icons.share),
                                                              onPressed: () async {
                                                                QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                                                if (verse != null) {
                                                                  final shareText = '${getSurahNameArabic(verse.surahNumber)} (الآية ${verse.verseNumber})\n ${getVerse(verse.surahNumber, verse.verseNumber)} \n ${getVerseTranslation(verse.surahNumber, verse.verseNumber, translation: quranReadingController.translation)}';
                                                                  Utils.shareText(text: shareText);
                                                                }
                                                              }),
                                                          IconButton(
                                                            icon: const Icon(
                                                              FluentIcons.book_question_mark_24_regular,
                                                              size: 25,
                                                            ),
                                                            onPressed: () {
                                                              QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                                              if (verse != null) {
                                                                try {
                                                                  // Try to get the TafsirDetailsController instance
                                                                  final controller = Get.find<TafsirDetailsController>();
                                                                  controller.surahNumber.value = verse.surahNumber;
                                                                  controller.verseNumber.value = verse.verseNumber;
                                                                  Get.to(() => const TafsirDetailsPage(), fullscreenDialog: true);
                                                                } catch (e, stackTrace) {
                                                                  log(e.toString(), stackTrace: stackTrace);
                                                                }
                                                                // Navigate to TafsirDetailsPage
                                                                Get.to(
                                                                  () => const TafsirDetailsPage(),
                                                                  arguments: {'surahNumber': verse.surahNumber, 'verseNumber': verse.verseNumber},
                                                                  binding: TafsirDetailsBinding(),
                                                                  fullscreenDialog: true,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          GetBuilder(
                                                            init: AyahBottomSheetController(),
                                                            builder: (controller) => IconButton(
                                                              icon: Get.put(AyahBottomSheetController()).isBookmarked.value ? const Icon(FluentIcons.bookmark_off_20_regular) : const Icon(FluentIcons.bookmark_add_20_regular),
                                                              onPressed: () async {
                                                                final ayahController = Get.put(AyahBottomSheetController());
                                                                QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                                                if (verse != null) {
                                                                  ayahController.bookmark = Bookmark(
                                                                    surah: verse.surahNumber,
                                                                    verse: verse.verseNumber,
                                                                  );
                                                                  ayahController.onBookmarkPressed();
                                                                }
                                                              },
                                                              // onPressed: ayahController.onBookmarkPressed,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: quranReadingController.currentPageData!.verses.where((element) => element.isHighlighted.value == true).isNotEmpty
                                                          ? Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    '${quranReadingController.currentPageData!.verses.where((element) => element.isHighlighted.value == true).first.surahNumber}:${quranReadingController.currentPageData!.verses.where((element) => element.isHighlighted.value == true).first.verseNumber}',
                                                                  ),
                                                                ),
                                                                GetBuilder(
                                                                    init: quranReadingController,
                                                                    builder: (quranReadingController) => Text(
                                                                          quranReadingController.currentPageData!.verses.where((element) => element.isHighlighted.value == true).firstOrNull?.textUthmaniSimple ?? '',
                                                                          style: GoogleFonts.amiri(),
                                                                        )),
                                                                GetBuilder(
                                                                  init: quranReadingController,
                                                                  builder: (quranReadingController) => Text(
                                                                    quran.getVerseTranslation(quranReadingController.currentPageData!.verses.where((element) => element.isHighlighted.value == true).firstOrNull?.surahNumber ?? 1, quranReadingController.currentPageData!.verses.where((element) => element.isHighlighted.value == true).firstOrNull?.verseNumber ?? 1, translation: quranReadingController.translation),
                                                                    textAlign: TextAlign.start,
                                                                    textDirection: TextDirection.ltr,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Center(
                                                              child: Text(
                                                              'لم يتم أختيار أي أيه',
                                                              style: GoogleFonts.amiri(),
                                                            )),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: GetBuilder(
                                                        init: QuranReadingController(),
                                                        builder: (QuranReadingController quranReadingController) => DropdownButton(
                                                          alignment: Alignment.centerLeft,
                                                          dropdownColor: Colors.white,
                                                          padding: const EdgeInsets.only(left: 10),
                                                          underline: null,
                                                          icon: const Icon(Icons.language),
                                                          hint: Text(quranReadingController.selcetedTranslationLanguage),
                                                          items: const [
                                                            DropdownMenuItem(
                                                              value: 'English (Saheeh International)',
                                                              child: Text('English (Saheeh International)'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'English (Clear Quran)',
                                                              child: Text('English (Clear Quran)'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'French (Muhammad Hamidullah)',
                                                              child: Text('French (Muhammad Hamidullah)'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Turkish',
                                                              child: Text('Turkish'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Italian',
                                                              child: Text('Italian'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Dutch',
                                                              child: Text('Dutch'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Russian',
                                                              child: Text('Russian'),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 'Portuguese',
                                                              child: Text('Portuguese'),
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            quranReadingController.mapSelectedTranslationLanguage(value!);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      FluentIcons.copy_16_regular,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                      if (verse != null) {
                                        final shareText = '${getSurahNameArabic(verse.surahNumber)} (الآية ${verse.verseNumber})\n ${getVerse(verse.surahNumber, verse.verseNumber)}';
                                        Utils.copyToClipboard(text: shareText);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      FluentIcons.share_16_regular,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      QuranVerseModel? verse = quranReadingController.currentPageData?.verses.where((element) => element.isHighlighted.value == true).first;
                                      if (verse != null) {
                                        final shareText = '${getSurahNameArabic(verse.surahNumber)} (الآية ${verse.verseNumber})\n ${getVerse(verse.surahNumber, verse.verseNumber)}';
                                        Utils.shareText(text: shareText);
                                      }
                                    },
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  // FilledButton.icon(
                                  //   onPressed: controller.onMainPlayPressed,
                                  //   icon: controller.isControlsVisible.value
                                  //       ? CustomCircularProgressIndicator()
                                  //       : const Icon(
                                  //           FluentIcons.play_circle_48_regular,
                                  //           size: 26,
                                  //         ),
                                  //   label: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       Text(
                                  //         'تشغيل التلاوة',
                                  //         style: TextStyle(fontSize: 14.sp),
                                  //       ),
                                  //       Obx(
                                  //         () {
                                  //           return Text(
                                  //             controller
                                  //                 .selectedReader.value.name,
                                  //             style: TextStyle(fontSize: 12.sp),
                                  //           );
                                  //         },
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  IconButton(
                                    icon: const Icon(
                                      FluentIcons.play_circle_48_regular,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      QuranVerseModel? verse = quranReadingController.currentPageData?.verses.first;
                                      if (verse != null) {
                                        controller.onMainPlayPressed(
                                          playRangeModel: QuranPlayRangeModel(
                                            startSurah: verse.surahNumber,
                                            endsSurah: verse.surahNumber,
                                            startVerse: verse.verseNumber,
                                            endsVerse: getVerseCount(
                                              verse.surahNumber,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),

                                  FilledButton.icon(
                                    // onPressed: controller.onMainPlayPressed,
                                    onPressed: () => selectReaderSheet().then((value) {
                                      controller.update();
                                      Get.find<QuranAudioPlayerBottomBarController>().selectedReader.value = QuranReaderCache.getSelectedReaderFromCache();
                                    }),
                                    icon: const Icon(
                                      // FluentIcons.arrow_down_48_regular,
                                      Icons.keyboard_double_arrow_down_outlined,
                                      size: 26,
                                    ),
                                    label: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Text(
                                        //   'تشغيل التلاوة',
                                        //   style: TextStyle(fontSize: 14.sp),
                                        // ),
                                        Obx(
                                          () {
                                            return Text(
                                           BlocProvider.of<ThemeCubit>(context).locale.languageCode == 'ar' ? controller.selectedReader.value.name :   controller.selectedReader.value.englishName,
                                              style: TextStyle(fontSize: 14.sp),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: Get.find<QuranReadingController>()
                                        .backgroundColors
                                        .asMap()
                                        .entries
                                        .map((e) => GestureDetector(
                                              onTap: () {
                                                Get.find<QuranReadingController>().changeBackgroundColor(e.key);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.only(end: 5),
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  backgroundColor: e.value,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                        // Column(
                        //   children: [
                        //     GetBuilder(
                        //       init: QuranAudioSettingsController(),
                        //       builder: (controller) {
                        //         return Text(
                        //           controller.selectedRepeatChoice,
                        //           style: context.textTheme.bodyLarge,
                        //         );
                        //       },
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         updateRepeat(theme);
                        //       },
                        //       child: const Icon(
                        //         // FluentIcons.arrow_repeat_1_16_regular,
                        //         Icons.repeat_outlined,
                        //         size: 25,
                        //       ),
                        //     ),
                        //     // IconButton(
                        //     //   icon: const Row(
                        //     //     children: [
                        //     //       Icon(
                        //     //         // FluentIcons.arrow_repeat_1_16_regular,
                        //     //         Icons.repeat_outlined,
                        //     //         size: 29,
                        //     //       ),
                        //     //     ],
                        //     //   ),
                        //     //   onPressed: () {
                        //     //     final s =
                        //     //         Get.put(QuranAudioSettingsController());
                        //     //     Get.dialog(
                        //     //       AlertDialog(
                        //     //         content: Column(
                        //     //           mainAxisSize: MainAxisSize.min,
                        //     //           children: [
                        //     //             ...s.repeatChoice.entries.map(
                        //     //               (e) {
                        //     //                 return GestureDetector(
                        //     //                   onTap: () {
                        //     //                     s.selectedRepeat = e.value;
                        //     //                     s.onSaveAllPressed();
                        //     //                     Get.closeCurrentSnackbar();
                        //     //                     s.update();
                        //     //                   },
                        //     //                   child: Container(
                        //     //                     padding:
                        //     //                         const EdgeInsets.all(8.0),
                        //     //                     decoration: BoxDecoration(
                        //     //                       color: s.selectedRepeat ==
                        //     //                               e.value
                        //     //                           ? theme.primaryColor
                        //     //                               .withOpacity(0.5)
                        //     //                           : Colors.transparent,
                        //     //                       borderRadius:
                        //     //                           BorderRadius.circular(10),
                        //     //                     ),
                        //     //                     child: ListTile(
                        //     //                       contentPadding:
                        //     //                           EdgeInsets.zero,
                        //     //                       title: Text(
                        //     //                         e.value,
                        //     //                       ),
                        //     //                       trailing: const Icon(
                        //     //                         Icons.arrow_forward_ios,
                        //     //                         size: 20,
                        //     //                       ),
                        //     //                     ),
                        //     //                   ),
                        //     //                 );
                        //     //               },
                        //     //             ),
                        //     //           ],
                        //     //         ),
                        //     //       ),
                        //     //     );
                        //     //   },
                        //     // ),
                        //     // const Gap(5),
                        //     // GetBuilder(
                        //     //   init: QuranAudioSettingsController(),
                        //     //   builder: (controller) {
                        //     //     return Text(
                        //     //       controller.selectedRepeatChoice,
                        //     //       style: context.textTheme.bodyLarge,
                        //     //     );
                        //     //   },
                        //     // ),
                        //   ],
                        // ),
                        IconButton(
                          icon: const Icon(
                            FluentIcons.play_settings_20_regular,
                            size: 25,
                          ),
                          onPressed: () {
                            Get.toNamed(
                              Routes.AUDIO_SETTINGS,
                              arguments: controller.quranPageViewController.currentPageData,
                            );
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            Obx(() => controller.isControlsVisible.value && controller.audioHandler != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          StreamBuilder<PlaybackState>(
                            stream: controller.audioHandler!.playbackState,
                            builder: (context, snapshot) {
                              final playbackState = snapshot.data;
                              final processingState = playbackState?.processingState;
                              final playing = playbackState?.playing;
                              if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Center(child: CustomCircularProgressIndicator()),
                                );
                              } else if (playing != true) {
                                return IconButton.filled(
                                  onPressed: controller.audioHandler!.play,
                                  icon: const Icon(
                                    FluentIcons.play_48_regular,
                                    size: 30,
                                  ),
                                );
                              } else {
                                return IconButton.filled(
                                  onPressed: controller.audioHandler!.pause,
                                  icon: const Icon(
                                    Iconsax.pause,
                                    size: 30,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 5),
                          Row(
                            children: [
                              IconButton(
                                style: IconButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  final QuranReadingController quranPageViewController = Get.find();
                                  controller.audioHandler!.stop();
                                  controller.isControlsVisible.value = false;
                                  quranPageViewController.changePageWithVolumeKeys();
                                  AudioSettingsCache.setPlayRangeValidState(isValid: false);
                                },
                                icon: const Icon(
                                  FluentIcons.stop_16_regular,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    controller.changeSpeed();
                                  },
                                  child: Text(
                                    // '${ArabicNumbers().convert(controller.playbackSpeed.value.toString())}x',
                                    '${controller.playbackSpeed.value.toString()}x',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                );
                              }),
                              const SizedBox(width: 10),
                              StreamBuilder<QueueState>(
                                stream: controller.audioHandler!.queueState,
                                builder: (context, snapshot) {
                                  final queueState = snapshot.data ?? QueueState.empty;
                                  return IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: queueState.hasNext ? controller.audioHandler!.skipToNext : null,
                                    icon: const Icon(
                                      FluentIcons.fast_forward_20_regular,
                                    ),
                                  );
                                },
                              ),
                              StreamBuilder<QueueState>(
                                stream: controller.audioHandler!.queueState,
                                builder: (context, snapshot) {
                                  final queueState = snapshot.data ?? QueueState.empty;
                                  return IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    icon: Transform.flip(
                                      flipX: true,
                                      child: const Icon(
                                        FluentIcons.fast_forward_20_regular,
                                      ),
                                    ),
                                    onPressed: queueState.hasPrevious ? controller.audioHandler!.skipToPrevious : null,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Obx(() {
                            return GestureDetector(
                              onTap: () {
                                controller.changeRepeat();
                              },
                              child: Column(
                                children: [
                                  Text(
                                    controller.playbackRepeat.value.toString(),
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  const Icon(
                                    Icons.repeat_outlined,
                                    size: 25,
                                  ),
                                ],
                              ),
                            );
                          }),
                          // GetBuilder(
                          //   init: QuranAudioSettingsController(),
                          //   builder: (controller) {
                          //     return Text(
                          //       controller.selectedRepeatChoice,
                          //       style: context.textTheme.bodyLarge,
                          //     );
                          //   },
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //    updateRepeat(theme);
                          //   },
                          //   child: const Icon(
                          //     // FluentIcons.arrow_repeat_1_16_regular,
                          //     Icons.repeat_outlined,
                          //     size: 25,
                          //   ),
                          // ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          FluentIcons.play_settings_20_regular,
                        ),
                        onPressed: () {
                          Get.toNamed(
                            Routes.AUDIO_SETTINGS,
                            arguments: controller.quranPageViewController.currentPageData,
                          );
                        },
                      ),
                    ],
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }

  void updateRepeat(ThemeData theme) {
    final controller = Get.put(QuranAudioSettingsController());
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...controller.repeatChoice.entries.map(
              (e) {
                return GestureDetector(
                  onTap: () {
                    controller.selectedRepeat = e.value;
                    controller.onSaveAllPressed();
                    Get.closeCurrentSnackbar();
                    controller.update();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: controller.selectedRepeat == e.value ? theme.primaryColor.withOpacity(0.5) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        e.value,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
