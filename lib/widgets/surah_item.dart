import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:islamina_app/utils/extension.dart';
import 'package:quran/quran.dart' as quran;
import 'package:islamina_app/widgets/custom_container.dart';

class SurahItem extends StatelessWidget {
  final int surahNumber;
  // final String surahName;
  final Function()? onTap;

  const SurahItem({
    super.key,
    required this.surahNumber,
    // required this.surahName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSurahNumber(context),
              _buildVerseInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahNumber(BuildContext context) {
    return FittedBox(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSurahNumberDecoration(context),
          const SizedBox(width: 10),
          Text(
            surahNumber.getSurahNameOnlyArabicSimple,
            // surahNumber.toString().padLeft(3, '0'),
            // surahName,
            maxLines: 1,
            style: const TextStyle(
              // fontFamily: 'SURAHNAMES',
              fontSize: 20,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }

  Widget _buildSurahNumberDecoration(BuildContext context) {
    return Stack(
      children: [
        Transform.rotate(
          angle: 40,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomContainer(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              // ArabicNumbers().convert(surahNumber.toString()),
              surahNumber.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerseInfo() {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_getVerseCount()} ${_getVerseCountSuffix()}',
            style: const TextStyle(fontSize: 16),
          ),
          // Text(
          //   '(${quran.getPlaceOfRevelation(surahNumber)})',
          //   style: const TextStyle(fontSize: 13),
          // ),
          const Gap(5),
          quran.getPlaceOfRevelation(surahNumber) == 'Makkah'
              ? Image.asset(
                  'assets/images/kaaba.png',
                  width: 25,
                )
              : Image.asset(
                  'assets/images/roza.png',
                  width: 25,
                ),
          const Gap(10),
          Column(
            children: [
              const Text(
                'الصفحة',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                getPageNumber,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getVerseCount() {
    return quran.getVerseCount(surahNumber).toString();
  }

  String get getPageNumber {
    return quran.getPageNumber(surahNumber, 1).toString();
  }

  String _getArabicVerseCount() {
    // return ArabicNumbers().convert(quran.getVerseCount(surahNumber));
    return quran.getVerseCount(surahNumber).toString();
  }

  String _getVerseCountSuffix() {
    return quran.getVerseCount(surahNumber) < 10 ? ' آيات' : ' آية';
  }
}
