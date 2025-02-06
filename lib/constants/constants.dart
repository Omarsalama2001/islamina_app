import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:islamina_app/generated/l10n.dart';
import 'package:quran/quran.dart';

S $strings = S.of(Get.context!);
const String islaminaLink = 'http://islamina.com';
const String bismillahText = '324';
const String loadingText = 'يتم تحضير البيانات...';
// const String appName = 'تَوَكَّلَ';
const String appName = 'إسلامنا';
const String previewColorMarkerText = 'ﭑ ﭒ ﭓ ﭔ ﭕ ﭖ ﭗ';
const String previewColorBox = 'ò';
const String previewVerse = "ﯜ ﯝ ﯞ ﯟ ﯠ";
const String previewText = basmala;
const String explainAdaptiveModeText = "Dynamic_display_sub";

final List<Map<String, dynamic>> madhabList = [
  {
    "title": "shafiTitle",
    "description": "shafiDescription",
    "madhab": Madhab.shafi.index,
  },
  {
    "title": "hanafiTitle",
    "description": "hanafiDescription" ,
    "madhab": Madhab.hanafi.index,
  },
];

final List<Map<String, dynamic>> calculationMethodList = [
  {
    "title": "calculationMuslimWorldLeagueTitle",
    "description": "calculationMuslimWorldLeagueDescription",
    "method": CalculationMethod.muslim_world_league.index,
  },
  {
    "title": "calculationEgyptianTitle",
    "description": "calculationEgyptianDescription",
    "method": CalculationMethod.egyptian.index,
  },
  {
    "title": "calculationKarachiTitle",
    "description":  "calculationKarachiDescription",
    "method": CalculationMethod.karachi.index,
  },
  {
    "title": "calculationUmmAlQuraTitle",
    "description":  "calculationUmmAlQuraDescription",
    "method": CalculationMethod.umm_al_qura.index,
  },
  {
    "title": "calculationDubaiTitle",
    "description": "calculationDubaiDescription",
    "method": CalculationMethod.dubai.index,
  },
  {
    "title": "calculationMoonSightingCommitteeTitle",
    "description":  "calculationMoonSightingCommitteeDescription",
    "method": CalculationMethod.moon_sighting_committee.index,
  },
  {
    "title": "calculationNorthAmericaTitle",
    "description": "calculationNorthAmericaDescription",
    "method": CalculationMethod.north_america.index,
  },
  {
    "title": "calculationKuwaitTitle",
    "description":"calculationKuwaitDescription",
    "method": CalculationMethod.kuwait.index,
  },
  {
    "title": "calculationQatarTitle",
    "description":  "calculationQatarDescription",
    "method": CalculationMethod.qatar.index,
  },
  {
    "title": "calculationSingaporeTitle",
    "description": "calculationSingaporeDescription",
    "method": CalculationMethod.singapore.index,
  },
  {
    "title": "calculationTurkeyTitle",
    "description": "calculationTurkeyDescription",
    "method": CalculationMethod.turkey.index,
  },
  {
    "title": "calculationTehranTitle",
    "description":"calculationTehranDescription",
    "method": CalculationMethod.tehran.index,
  },
];
