import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart' as intl;
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:quran/quran.dart';
import 'package:islamina_app/data/models/quran_navigation_data_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../data/cache/bookmark_cache.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_progress_indicator.dart';
import '../widgets/surah_verse.dart';

class QuranBookmarksView extends GetView {
  QuranBookmarksView({super.key});
  final BookmarkCache _bookmarkCache = BookmarkCache();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: theme.textTheme.titleMedium,
        title:  Text(
        context.translate('bookMarks'),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<void>(
        future: _bookmarkCache.loadBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomCircularProgressIndicator();
          } else {
            return Obx(() {
              final bookmarks = _bookmarkCache.bookmarks;
              if (bookmarks.isEmpty) {
                return  Center(
                  child: Text(context.translate('noReferenceSignsAreAdded')),
                );
              } else {
                return ListView.builder(
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            final pageNumber =
                                getPageNumber(bookmark.surah, bookmark.verse);
                            var navigationDetails =
                                QuranNavigationArgumentModel(
                              isKhatma: false,
                              surahNumber: bookmark.surah,
                              pageNumber: pageNumber,
                              verseNumber: bookmark.verse,
                              highlightVerse: true,
                            );
                            if (Get.previousRoute.contains('quran-reading')) {
                              Get.back(result: navigationDetails);
                            } else {
                              Get.toNamed(Routes.QURAN_READING_PAGE,
                                  arguments: navigationDetails);
                            }
                          },
                          horizontalTitleGap: 30,
                          isThreeLine: true,
                          title: Padding(
                            padding: const EdgeInsetsDirectional.only(top: 8),
                            child: Text(
                              getVerse(bookmark.surah, bookmark.verse),
                              maxLines: 5,
                              style: const TextStyle(
                                  fontFamily: 'Uthmanic_Script',
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              SurahVerseWidget(
                                  surah: bookmark.surah, verse: bookmark.verse),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                // '( ${ArabicNumbers().convert(intl.DateFormat('HH:mm yyyy/MM/d ').format(bookmark.addedDate!))} )',
                                '( ${intl.DateFormat('HH:mm yyyy/MM/d ').format(bookmark.addedDate!)})',
                                style: TextStyle(fontSize: 13.sp),
                              )
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Iconsax.minus_cirlce,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () {
                              _bookmarkCache.deleteBookmark(bookmark);
                            },
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    );
                  },
                );
              }
            });
          }
        },
      ),
    );
  }
}
