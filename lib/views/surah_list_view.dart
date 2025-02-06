import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:islamina_app/data/models/quran_navigation_data_model.dart';
import 'package:islamina_app/utils/extension.dart';
import 'package:quran/surah_data.dart';

import '../../../routes/app_pages.dart';
import '../Widgets/surah_item.dart';

class SurahListView extends GetView {
  const SurahListView({super.key, this.searchText = ''});

  final String searchText;

  @override
  Widget build(BuildContext context) {
    final surahNumbers = List.generate(114, (index) => index + 1)
        .where((surahNumber) =>
            surahNumber.getSurahNameArabicSimple.contains(searchText))
        .toList();
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: surahNumbers.length,
      separatorBuilder: (context, index) {
        return const Divider(height: 1);
      },
      itemBuilder: (BuildContext context, int index) {
        final surahNumber = surahNumbers[index];
        return buildSurahItem(context, surahNumber, surah[index]['arabic']);
      },
    );
  }

  Widget buildSurahItem(
    BuildContext context,
    int surahNumber,
    String surahName,
  ) {
    return SurahItem(
      surahNumber: surahNumber,
      // surahName: surahName,
      onTap: () async {
        Get.toNamed(
          Routes.QURAN_READING_PAGE,
          arguments: QuranNavigationArgumentModel(
            isKhatma: false,
            surahNumber: surahNumber,
            pageNumber: quran.getPageNumber(surahNumber, 1),
            verseNumber: 1,
            highlightVerse: true,
          ),
        );
      },
    );
  }
}
