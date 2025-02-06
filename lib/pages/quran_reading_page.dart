import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/controllers/quran_audio_player_controller.dart';
import 'package:islamina_app/controllers/quran_settings_controller.dart';
import 'package:islamina_app/core/extensions/media_query_extension.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/data/models/quran_navigation_data_model.dart';
import 'package:islamina_app/features/khatma/data/models/khatma_model.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/services/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quran/quran.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/data/cache/quran_settings_cache.dart';
import 'package:islamina_app/utils/extension.dart';
import 'package:islamina_app/utils/quran_utils.dart';
import 'package:islamina_app/utils/sheets/sheet_methods.dart';
import 'package:islamina_app/widgets/custom_pop_menu_item.dart';
import 'package:islamina_app/widgets/custom_scroll_behavior.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/models/quran_page.dart';
import '../../../../routes/app_pages.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/quran_reading_controller.dart';
import '../data/models/quran_verse_model.dart';
import '../widgets/quran_reading_page_widgets.dart';
import 'quran_audio_player_page.dart';

class QuranReadingPage extends GetView<QuranReadingController> {
  QuranReadingPage({super.key});
  @override
  Widget build(BuildContext context) {
    final QuranNavigationArgumentModel arguments = Get.arguments as QuranNavigationArgumentModel;

    var controller = Get.put(QuranReadingController());
    //  Future.delayed( Duration(seconds: 4)).then((context) => QuranUtils.toggleFullscreen(isFullScreen: controller.isFullScreenMode),);
    controller.changePageWithVolumeKeys();

    var theme = Theme.of(context);
    return GetBuilder(
        init: QuranReadingController(),
        builder: (quranController) {
          arguments.khatmaModel != null ? controller.getKhatmaStatus(arguments.khatmaModel!) : null;
          return Scaffold(
            backgroundColor: quranController.selectedBackgroundColorIndex == 0 || quranController.selectedBackgroundColorIndex == 1 || quranController.selectedBackgroundColorIndex == 2 ? quranController.backgroundColors[quranController.selectedBackgroundColorIndex] : null,
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: buildQuranAudioPlayer(),
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: buildAppBar(theme: theme),
            // toggle fullscreen when tap on body
            body: PopScope(
              onPopInvoked: (_) async => await controller.onCloseView(),
              child: GestureDetector(
                onTap: () => QuranUtils.toggleFullscreen(isFullScreen: controller.isFullScreenMode),
                child: GetBuilder<QuranReadingController>(
                  // PageView for handling the 604 Quran Page
                  builder: (controller) => Stack(
                    children: [
                      PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: controller.quranPageController,
                        itemCount: 604,
                        onPageChanged: (value) {
                          controller.onPageChanged(context, value);
                        },
                        itemBuilder: (context, index) {
                          // current page data might be null
                          QuranPageModel? currentPage = controller.quranPages[index];
                          QuranPageModel? nextPage;
                          if (index != 603) {
                            nextPage = null;
                            nextPage = controller.quranPages[index + 1];
                          }
                          // if null return loading text
                          if (currentPage == null) {
                            return Center(child: Text(context.translate('loadingText')));
                          }
                          // return the page data of requseted page
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // if page is odd view page strokes
                              if (currentPage.pageNumber.isOdd) buildPageStrokes(false),
                              // the page view handler
                              Expanded(
                                  child: QuranPageView(
                                currentPage,
                                nextPage: nextPage,
                              )),
                              // if page is even view page strokes
                              if (currentPage.pageNumber.isEven) buildPageStrokes(true),
                            ],
                          );
                        },
                      ),
                      controller.isFullScreenMode.value
                          ? const SizedBox.shrink()
                          : arguments.isKhatma
                              ? Positioned(
                                  bottom: 10.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          showDragHandle: true,
                                          // barrierColor: Colors.,
                                          enableDrag: true,
                                          isDismissible: true,
                                          useSafeArea: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          elevation: 10,
                                          backgroundColor: Colors.white,
                                          context: context,
                                          builder: (_) => SizedBox(
                                                height: context.height * 0.6,
                                                child: ListView.builder(
                                                  itemBuilder: (context, index) => buildKhatmaSheetItem(context.read<KhatmaCubit>().khatmas[index]),
                                                  itemCount: context.read<KhatmaCubit>().khatmas.length,
                                                ),
                                              ));
                                    },
                                    child: GetBuilder<QuranReadingController>(
                                      init: QuranReadingController(),
                                      builder: (controller) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5),
                                              boxShadow: const [
                                                BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 7),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(7.0),
                                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                GetBuilder<QuranReadingController>(
                                                    init: QuranReadingController(),
                                                    builder: (controller) {
                                                      print(controller.getPageEquaility(arguments.khatmaModel!));
                                                      return CircularPercentIndicator(
                                                        radius: 15.sp,
                                                        percent: (controller.getPageEquaility(arguments.khatmaModel!) <= arguments.khatmaModel!.lastPage) ? (controller.getPageEquaility(arguments.khatmaModel!) / arguments.khatmaModel!.lastPage) : 1,
                                                        progressColor: controller.khatmaStatus == 'normalRate' ? context.theme.primaryColor : Colors.orange,
                                                      );
                                                    }),
                                                const Gap(7),
                                                Text(
                                                  controller.khatmaStatus,
                                                  style: GoogleFonts.amiri().copyWith(color: Colors.black),
                                                ),
                                                const Gap(7),
                                                const Icon(FluentIcons.chevron_right_20_regular),
                                              ]),
                                            )),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  buildKhatmaSheetItem(KhatmaModel khatmaModel) {
    return GestureDetector(
      onTap: () {
        QuranReadingController controller = Get.find();
        // Start loading the page and then scroll to the page
        final page = mapInitialPositionToPage(khatmaModel.unit, khatmaModel.initialPage);
        controller.fetchQuranPageData(pageNumber: page.pageNumber, scrollToPage: true);
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1),
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircularPercentIndicator(
                    header: Text('% ${calculatePercent(khatmaModel)}', style: GoogleFonts.tajawal().copyWith(fontSize: 17.sp)),
                    center: Container(
                      height: 27.sp,
                      width: 27.sp,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(17.sp),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              getKhatmaImage(khatmaModel!.khatmaType).toLowerCase(),
                            ),
                          )),
                    ),
                    radius: 23.sp,
                    animation: true,
                    progressColor: Get.context?.theme.primaryColor,
                    percent: (khatmaModel.initialPage > khatmaModel.valueOfUnit ? khatmaModel.valueOfUnit : khatmaModel.initialPage) / khatmaModel.valueOfUnit,
                    animateFromLastPercent: true,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.sp),
                      boxShadow: [
                        BoxShadow(color: Get.context!.theme.primaryColorLight.withOpacity(0.5), spreadRadius: 1, blurRadius: 10),
                      ],
                      color: const Color(0xffb8e2ce),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        Get.context!.translate(khatmaModel.khatmaType),
                        style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: Get.context!.theme.primaryColor, fontSize: 17.sp),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      khatmaModel!.name,
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: Get.context!.theme.primaryColor, fontSize: 15.sp),
                    ),
                    Text(
                      '${Get.context!.translate("khamta_ends_after")} ${calculateExpirationTimeOfKhatma(khatmaModel.createdAt, khatmaModel.expectedPeriodOfKhatma)}${Get.context!.translate("day")} - ${khatmaModel.unitPerDay} ${Get.context!.translate(khatmaModel.unit)} ${Get.context!.translate("daily")}',
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: Get.context!.theme.primaryColor, fontSize: 15.sp),
                    ),
                    const Gap(7),
                    Text(
                      khatmaModel.moshafType ? Get.context!.translate("app'sMoshaf") : Get.context!.translate("ownMoshaf"),
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: Colors.orange, fontSize: 15.sp),
                    ),
                    // Text(
                    //   controller.khatmaStatus,
                    //   style: GoogleFonts.amiri().copyWith(color: Colors.black),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // build the appbar
  PreferredSize buildAppBar({required ThemeData theme}) {
    return PreferredSize(
      preferredSize: const Size(0, kToolbarHeight),
      child: Obx(
        () {
          return IgnorePointer(
            ignoring: controller.isFullScreenMode.value ? true : false,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: controller.isFullScreenMode.value ? 0 : 1,
              child: AppBar(
                titleSpacing: 0,
                leading: buildAppBarMenuButton(),
                actions: buildAppBarActions(),
                title: buildAppBarTitle(),
              ),
            ),
          );
        },
      ),
    );
  }

  // build the app bar that contains the current surah,juz,pageNumber
  GetBuilder<QuranReadingController> buildAppBarTitle() {
    var theme = Theme.of(Get.context!);
    return GetBuilder<QuranReadingController>(
      builder: (context) {
        if (controller.currentPageData != null) {
          var page = controller.currentPageData!; //
          var textStyle = theme.primaryTextTheme.labelSmall;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // surah name of code qcf
              // surahNameInQcf(
              //   surahNumber: page.surahNumber,
              //   fontSize: 25,
              // ),
              Text(
                'سورة ${page.surahNumber.getSurahNameOnlyArabicSimple}',
                textScaler: TextScaler.noScaling,
                style: const TextStyle(
                  height: 1,
                  fontSize: 16,
                ),
              ),
              // current page juz, pagenumber
              Row(
                children: [
                  Text(
                    // 'الجزء ${ArabicNumbers().convert(page.juzNumber)}',
                    '${Get.context!.translate('theJuz')}${page.juzNumber}',
                    style: textStyle,
                  ),
                  Text(
                    ' | ',
                    style: textStyle,
                  ),
                  Text(
                    // 'الصفحة ${ArabicNumbers().convert(page.pageNumber)}',
                    '${Get.context!.translate('thePage')} ${page.pageNumber}',
                    style: textStyle,
                  ),
                ],
              )
            ],
          );
        } else {
          // if page is not loaded yet view empty size box
          return const SizedBox();
        }
      },
    );
  }

  // bottom nav bar that handle the audio controls and audio settings
  Widget buildQuranAudioPlayer() {
    return Obx(
      () {
        return IgnorePointer(
          ignoring: controller.isFullScreenMode.value ? true : false,
          child: AnimatedOpacity(
            opacity: controller.isFullScreenMode.value ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: const QuranAudioPlayerBottomBar(),
          ),
        );
      },
    );
  }

  // pop up menu that contains quick actions
  PopupMenuButton<dynamic> buildAppBarMenuButton() {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      itemBuilder: (context) {
        return [
          CustomPopupMenuItem.build(index: 'search', iconData: FluentIcons.book_search_24_regular, text: context.translate('search')),
          // customMenuItem(
          //     index: 'fadl',
          //     iconData: FlutterIslamicIcons.quran,
          //     text: 'فضل قراءة القرآن'),
          // customMenuItem(
          //     index: 'dua',
          //     iconData: FlutterIslamicIcons.prayer,
          //     text: 'دعاء ختم القرآن'),
          CustomPopupMenuItem.build(index: 'page', iconData: FluentIcons.book_number_16_regular, text: context.translate('moveTopage')),
          CustomPopupMenuItem.build(index: 'surah', iconData: Iconsax.book_1, text: context.translate('moveTosurah')),
          CustomPopupMenuItem.build(index: 'juz', iconData: Iconsax.book_square, text: context.translate('moveTojuz')),
          CustomPopupMenuItem.build(index: 'bookmark', iconData: FluentIcons.bookmark_search_20_regular, text: context.translate('bookMarks')),
          CustomPopupMenuItem.build(index: 'audio', iconData: FluentIcons.play_settings_20_regular, text: context.translate('sounds_settings')),
          CustomPopupMenuItem.build(index: 'screen', iconData: FluentIcons.settings_16_regular, text: context.translate('quranSettings')),
        ];
      },
      onSelected: controller.onMenuItemSelected,
    );
  }

  //build the AppBar actions
  List<Widget> buildAppBarActions() {
    return [
      // bookmarks
      IconButton(
        onPressed: controller.handleBookmarkPage,
        icon: const Icon(FluentIcons.bookmark_search_20_regular),
      ),
      // search quran
      IconButton(
        onPressed: controller.handleSearchPage,
        icon: const Icon(FluentIcons.book_search_20_regular),
      ),
      // quran settinigs
      IconButton(
        onPressed: () => Get.toNamed(Routes.QURAN_DISPLAY_SETTINGS),
        icon: const Icon(FluentIcons.settings_16_regular),
      ),
      // back button
      IconButton(
        padding: const EdgeInsets.all(16.0),
        onPressed: () async {
          // await controller.onCloseView();
          Get.back();
        },
        icon: const Icon(Icons.arrow_forward_rounded),
      ),
    ];
  }
}

/// The [QuranPageHeader] widget represents the header of a Quranic page.
/// It displays the names of the Surahs present on the page and information about the Juz, Hizb,
/// and Rub El Hizb details.
class QuranPageHeader extends StatelessWidget {
  const QuranPageHeader({super.key, required this.page});

  final QuranPageModel page;

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.labelSmall;

    return SizedBox(
      height: QuranSettingsCache.getStatusBarHeight(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // Display Surah names of the page
              getPageData(page.pageNumber).map((element) => (element['surah'] as int).getSurahNameOnlyArabicSimple).join(' | '),
              style: textStyle,
            ),
            // Display Juz number and Hizb details of the page
            Row(
              children: [
                Text(
                  // 'الجزء ${ArabicNumbers().convert(page.juzNumber)}',
                  'الجزء ${page.juzNumber}',
                  style: textStyle,
                ),
                const Gap(8),
                Text(
                  // ArabicNumbers().convert(
                  //   context.getHizbText(
                  //     hizbNumber: page.hizbNumber,
                  //     rubElHizbNumber: page.rubElHizbNumber,
                  //   ),
                  // ),
                  context.getHizbText(
                    hizbNumber: page.hizbNumber,
                    rubElHizbNumber: page.rubElHizbNumber,
                  ),
                  style: textStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// The [QuranPageView] widget to handle the quran page view options.
/// this will handl all senarios of the view [QuranAdaptiveView], [QuranExpandedPageView], [QuranNormalPageView] d.
class QuranPageView extends GetView<QuranReadingController> {
  final QuranPageModel page;
  final QuranPageModel? nextPage;

  const QuranPageView(this.page, {this.nextPage, super.key});
  @override
  Widget build(BuildContext context) {
    List<Word> allWords = page.verses.expand((verse) => verse.words).toList();
    List<Word>? allWordsNextPage;

    if (nextPage != null) {
      allWordsNextPage = nextPage!.verses.expand((verse) => verse.words).toList();
      controller.nextPageWords = allWordsNextPage;
    }

    controller.currentPageWords = allWords;

    return GetBuilder<QuranReadingController>(
      builder: (controller) {
        if (controller.displaySettings.isAdaptiveView) {
          return QuranAdaptiveView(words: allWords, page: page, fontSize: controller.displaySettings.displayFontSize);
        } else {
          final quranSettingsController = Get.put(QuranSettingsController());
          return context.isLandscape || Get.height < 750
              // enable scroll if the orientation is landscape or screen is small
              ? nextPage != null && quranSettingsController.settingsModel.isDisplayTwoPage
                  ? Row(
                      children: [
                        Expanded(
                          child: QuranExpandedPageView(
                            page: page,
                            allWords: allWords,
                          ),
                        ),
                        Expanded(
                          child: QuranExpandedPageView(
                            page: nextPage!,
                            allWords: allWordsNextPage!,
                          ),
                        ),
                      ],
                    )
                  : QuranExpandedPageView(
                      page: page,
                      allWords: allWords,
                    )
              : QuranNormalPageView(
                  page: page,
                  allWords: allWords,
                );
        }
      },
    );
  }
}

/// The [QuranExpandedPageView] widget is for displaying the Quranic page with scroll
/// with an expanded [SingleChildScrollView] this will make page fit on all available width with scroll view.
/// It displays a Quranic page, including a header
/// with Surah names, Quranic verses represented by [QuranLines], and a footer for navigation.
class QuranExpandedPageView extends StatelessWidget {
  const QuranExpandedPageView({
    super.key,
    required this.page,
    required this.allWords,
  });

  final QuranPageModel page;

  final List<Word> allWords;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuranPageHeader(page: page),
              QuranLines(words: allWords, page: page),
              context.orientation == Orientation.landscape
                  ? const SizedBox.shrink()
                  : PageNumberButtonWidget(
                      pageNumber: page.pageNumber,
                      height: QuranUtils.getQuranPageFooterHeight(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The [QuranNormalPageView] widget is for displaying the Quranic page with normal view
/// this will make page fit on height - footer_height && - navigation_height.
/// It displays a Quranic page, including a header
/// with Surah names, Quranic verses represented by [QuranLines], and a footer for navigation.
class QuranNormalPageView extends StatelessWidget {
  const QuranNormalPageView({
    super.key,
    required this.page,
    required this.allWords,
  });

  final QuranPageModel page;
  final List<Word> allWords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuranPageHeader(page: page),
        Expanded(
          child: QuranLines(
            words: allWords,
            page: page,
          ),
        ),
        PageNumberButtonWidget(
          pageNumber: page.pageNumber,
          height: QuranUtils.getQuranPageFooterHeight(),
        ),
      ],
    );
  }
}

/// The [QuranLines] widget represents a column of 15 [QuranLine] widgets, each displaying a line
/// of Quranic text. It utilizes a [FittedBox] to maintain the aspect ratio and a [Column] to organize
/// the lines. The widget generates each line using the [QuranLine] widget, considering line-related
/// properties such as line number, words, and empty line conditions.
class QuranLines extends StatelessWidget {
  // list of all words of this page
  final List<Word> words;
  // the page data where we in
  final QuranPageModel page;
  const QuranLines({
    super.key,
    required this.words,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          15,
          (index) {
            int lineNumber = index + 1;
            // filter the words of this line
            List<Word> lineWords = QuranUtils.getWordsForLine(words, lineNumber);
            return QuranLine(
              lineNumber: lineNumber,
              words: lineWords,
              page: page,
              surahNumber: QuranUtils.getSurahNumberOfLine(words, lineNumber),
              isNextLineEmpty: QuranUtils.isNextLineEmpty(words, lineNumber),
              isPrevLineEmpty: QuranUtils.isPrevLineEmpty(words, lineNumber),
            );
          },
        ),
      ),
    );
  }
}

/// The [QuranLine] widget displays a line of Quranic text, Surah titles, words, verses
/// and Bismillah display based on specific conditions based on previous and next lines.
/// the RichText representation of the Quranic words, applying styles with [QuranUtils] methods for handling the highlights.
class QuranLine extends StatelessWidget {
  // the words of the line
  final List<Word> words;
  // the line number of which the line is
  final int lineNumber;
  // this parameter to check to print the surah box and bismillah
  final bool isNextLineEmpty;
  final bool isPrevLineEmpty;
  // the page where we in
  final QuranPageModel page;
  // the surah number of this line
  final int surahNumber;
  const QuranLine({
    super.key,
    required this.words,
    required this.lineNumber,
    required this.page,
    required this.surahNumber,
    required this.isNextLineEmpty,
    required this.isPrevLineEmpty,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(Get.context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if words of the line are empty then show surah box and bismillah
        if (words.isEmpty) ...[
          // if pageNumber = 1 or pageNumber = 187 skip bismillah
          if (isNextLineEmpty || page.pageNumber == 1 || page.pageNumber == 187) ...[
            if ((page.pageNumber == 1 || page.pageNumber == 2) && lineNumber > 8) ...[
              // first 2 pages has only 7 lines
              const SizedBox(height: 25),
            ] else ...[
              // Display Surah title when the line is empty and specific conditions are met.
              surahTitleWidget(theme, surahNumber)
            ]
          ] else if (page.pageNumber != 1 && page.pageNumber != 187) ...[
            // Display Bismillah when the line is empty and specific conditions are met.
            bismillahTextWidget(),
          ]
        ] else
          // Build the line using the buildLine method.
          buildLine(words, page)
      ],
    );
  }

  Widget buildLine(List<Word> words, QuranPageModel page) {
    var theme = Theme.of(Get.context!);
    return Obx(
      () {
        return RichText(
          text: TextSpan(
            // Set the line height based on the calculated height of a Quranic line.
            style: TextStyle(
              height: QuranUtils.calcHeightOfQuranLine(),
            ),
            children: words.map(
              (word) {
                // this handle of which verse we are
                var verse = page.verses.firstWhere((element) => element.id == word.verseId);
                // Build the Quranic word TextSpan using the buildQuranWordTextSpan method.
                return buildQuranWordTextSpan(
                  onTap: () {
                    final quranAudioPlayerBottomBarController = Get.put(QuranAudioPlayerBottomBarController());
                    if (verse.isHighlighted.value) {
                      quranAudioPlayerBottomBarController.isAyahSelected.value = false;
                      verse.isHighlighted.value = false;
                      for (var element in verse.words) {
                        element.isHighlighted.value = false;
                      }
                    } else {
                      quranAudioPlayerBottomBarController.isAyahSelected.value = true;
                      for (var i = 0; i < page.verses.length; i++) {
                        page.verses[i].isHighlighted.value = false;
                        for (var element in page.verses[i].words) {
                          element.isHighlighted.value = false;
                        }
                      }
                      showVerseInfoBottomSheet(
                        verse: verse,
                        word: word,
                        context: Get.context!,
                      );
                    }
                  },
                  text: word.textV1,
                  // color the word for highlighting
                  wordColor: QuranUtils.getQuranWordColor(
                    isHighlighted: word.isHighlighted,
                    isMarker: word.wordType == 'end',
                    theme: theme,
                  ),
                  // color the verse for highlighting
                  verseColor: QuranUtils.getVerseBackgroundColor(
                    isVerseHighlighted: verse.isHighlighted,
                    isWordHighlighted: word.isHighlighted,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                  ),
                  // fontFamily of the word
                  fontFamily: QuranUtils.getFontNameOfQuranPage(
                    pageNumber: page.pageNumber,
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

/// The [QuranAdaptiveView] widget is responsible for displaying the Quran in adaptive mode,
/// allowing users to adjust the font size dynamically. It includes a scroll view with rich text
/// for verses, surah names, and page header information.
class QuranAdaptiveView extends StatelessWidget {
  final List<Word> words;
  final QuranPageModel page;
  final double fontSize;

  const QuranAdaptiveView({
    super.key,
    required this.words,
    required this.page,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              QuranPageHeader(page: page),
              buildQuranText(theme),
              PageNumberButtonWidget(
                height: QuranUtils.getQuranPageFooterHeight(),
                pageNumber: page.pageNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuranText(ThemeData theme) {
    return Obx(() {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: page.verses
              .expand(
                (verse) => [
                  if (verse.verseNumber == 1) ...[
                    const TextSpan(text: '\n'),
                    WidgetSpan(
                      child: surahNameInQcf(
                        surahNumber: verse.surahNumber,
                        fontSize: 50,
                        textColor: theme.primaryColor,
                      ),
                    ),
                    const TextSpan(text: '\n'),
                    if ((page.pageNumber != 1 && page.pageNumber != 187)) ...[
                      TextSpan(
                        text: '$bismillahText\n',
                        style: TextStyle(
                          fontFamily: 'QCFBSML',
                          fontSize: 30,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ]
                  ],
                  ...verse.words.map(
                    (word) => buildQuranWordTextSpan(
                      onTap: () => showVerseInfoBottomSheet(verse: verse, word: word, context: Get.context!),
                      text: word.textV1,
                      fontSize: fontSize,
                      wordColor: QuranUtils.getQuranWordColor(isHighlighted: word.isHighlighted, isMarker: word.wordType == 'end', theme: theme),
                      verseColor: QuranUtils.getVerseBackgroundColor(isVerseHighlighted: verse.isHighlighted, isWordHighlighted: word.isHighlighted, backgroundColor: theme.colorScheme.surfaceVariant),
                      fontFamily: QuranUtils.getFontNameOfQuranPage(pageNumber: page.pageNumber),
                    ),
                  ),
                ],
              )
              .toList(),
        ),
      );
    });
  }
}
