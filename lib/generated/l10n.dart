// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Islamuna`
  String get appName {
    return Intl.message(
      'Islamuna',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Quran`
  String get quran {
    return Intl.message(
      'Quran',
      name: 'quran',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Times`
  String get prayerTimes {
    return Intl.message(
      'Prayer Times',
      name: 'prayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `eTasbih`
  String get eTasbih {
    return Intl.message(
      'eTasbih',
      name: 'eTasbih',
      desc: '',
      args: [],
    );
  }

  /// `Muslim Azkar`
  String get azkarCategories {
    return Intl.message(
      'Muslim Azkar',
      name: 'azkarCategories',
      desc: '',
      args: [],
    );
  }

  /// `Names of Allah`
  String get asmaullah {
    return Intl.message(
      'Names of Allah',
      name: 'asmaullah',
      desc: '',
      args: [],
    );
  }

  /// `Istighfar`
  String get istighfar {
    return Intl.message(
      'Istighfar',
      name: 'istighfar',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get quranBookMarks {
    return Intl.message(
      'Bookmarks',
      name: 'quranBookMarks',
      desc: '',
      args: [],
    );
  }

  /// `Qibla`
  String get qibla {
    return Intl.message(
      'Qibla',
      name: 'qibla',
      desc: '',
      args: [],
    );
  }

  /// `Kabba`
  String get kabba {
    return Intl.message(
      'Kabba',
      name: 'kabba',
      desc: '',
      args: [],
    );
  }

  /// `Tasbeeh`
  String get tasabih {
    return Intl.message(
      'Tasbeeh',
      name: 'tasabih',
      desc: '',
      args: [],
    );
  }

  /// `Praise`
  String get hmd {
    return Intl.message(
      'Praise',
      name: 'hmd',
      desc: '',
      args: [],
    );
  }

  /// `Qibla AR`
  String get qiblaVr {
    return Intl.message(
      'Qibla AR',
      name: 'qiblaVr',
      desc: '',
      args: [],
    );
  }

  /// `40 Nawawi Hadiths`
  String get hadith40 {
    return Intl.message(
      '40 Nawawi Hadiths',
      name: 'hadith40',
      desc: '',
      args: [],
    );
  }

  /// `Prophets' Duas`
  String get prophetDua {
    return Intl.message(
      'Prophets\' Duas',
      name: 'prophetDua',
      desc: '',
      args: [],
    );
  }

  /// `Prophetic Duas`
  String get pDua {
    return Intl.message(
      'Prophetic Duas',
      name: 'pDua',
      desc: '',
      args: [],
    );
  }

  /// `Quranic Duas`
  String get quranDua {
    return Intl.message(
      'Quranic Duas',
      name: 'quranDua',
      desc: '',
      args: [],
    );
  }

  /// `Quran Search`
  String get quranSearch {
    return Intl.message(
      'Quran Search',
      name: 'quranSearch',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get shareApp {
    return Intl.message(
      'Share App',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `Preparing data...`
  String get loadingText {
    return Intl.message(
      'Preparing data...',
      name: 'loadingText',
      desc: '',
      args: [],
    );
  }

  /// `Allows users to fully control the font size and zoom according to their personal needs. The text can be adjusted to a comfortable size for the eyes, making reading more comfortable.`
  String get explainAdaptiveModeText {
    return Intl.message(
      'Allows users to fully control the font size and zoom according to their personal needs. The text can be adjusted to a comfortable size for the eyes, making reading more comfortable.',
      name: 'explainAdaptiveModeText',
      desc: '',
      args: [],
    );
  }

  /// `Shafi'i School`
  String get shafiTitle {
    return Intl.message(
      'Shafi\'i School',
      name: 'shafiTitle',
      desc: '',
      args: [],
    );
  }

  /// `Asr prayer is calculated in the Shafi'i school when the shadow of an object is equal to its length plus the length of its shadow at noon.`
  String get shafiDescription {
    return Intl.message(
      'Asr prayer is calculated in the Shafi\'i school when the shadow of an object is equal to its length plus the length of its shadow at noon.',
      name: 'shafiDescription',
      desc: '',
      args: [],
    );
  }

  /// `Hanafi School`
  String get hanafiTitle {
    return Intl.message(
      'Hanafi School',
      name: 'hanafiTitle',
      desc: '',
      args: [],
    );
  }

  /// `Asr prayer is calculated in the Hanafi school when the shadow of an object is twice its length plus the length of its shadow at noon.`
  String get hanafiDescription {
    return Intl.message(
      'Asr prayer is calculated in the Hanafi school when the shadow of an object is twice its length plus the length of its shadow at noon.',
      name: 'hanafiDescription',
      desc: '',
      args: [],
    );
  }

  /// `Muslim World League`
  String get calculationMuslimWorldLeagueTitle {
    return Intl.message(
      'Muslim World League',
      name: 'calculationMuslimWorldLeagueTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 18° and an Isha angle of 17°`
  String get calculationMuslimWorldLeagueDescription {
    return Intl.message(
      'Uses a Fajr angle of 18° and an Isha angle of 17°',
      name: 'calculationMuslimWorldLeagueDescription',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian General Authority of Survey`
  String get calculationEgyptianTitle {
    return Intl.message(
      'Egyptian General Authority of Survey',
      name: 'calculationEgyptianTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 19.5° and an Isha angle of 17.5°`
  String get calculationEgyptianDescription {
    return Intl.message(
      'Uses a Fajr angle of 19.5° and an Isha angle of 17.5°',
      name: 'calculationEgyptianDescription',
      desc: '',
      args: [],
    );
  }

  /// `University of Islamic Sciences, Karachi`
  String get calculationKarachiTitle {
    return Intl.message(
      'University of Islamic Sciences, Karachi',
      name: 'calculationKarachiTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 18° and an Isha angle of 18°`
  String get calculationKarachiDescription {
    return Intl.message(
      'Uses a Fajr angle of 18° and an Isha angle of 18°',
      name: 'calculationKarachiDescription',
      desc: '',
      args: [],
    );
  }

  /// `Umm al-Qura University, Makkah`
  String get calculationUmmAlQuraTitle {
    return Intl.message(
      'Umm al-Qura University, Makkah',
      name: 'calculationUmmAlQuraTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 18.5° and an Isha angle of 90°. Note: A custom adjustment of +30 minutes for Isha during Ramadan should be added.`
  String get calculationUmmAlQuraDescription {
    return Intl.message(
      'Uses a Fajr angle of 18.5° and an Isha angle of 90°. Note: A custom adjustment of +30 minutes for Isha during Ramadan should be added.',
      name: 'calculationUmmAlQuraDescription',
      desc: '',
      args: [],
    );
  }

  /// `Gulf Region`
  String get calculationDubaiTitle {
    return Intl.message(
      'Gulf Region',
      name: 'calculationDubaiTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr and Isha angle of 18.2°`
  String get calculationDubaiDescription {
    return Intl.message(
      'Uses a Fajr and Isha angle of 18.2°',
      name: 'calculationDubaiDescription',
      desc: '',
      args: [],
    );
  }

  /// `Moon Sighting Committee`
  String get calculationMoonSightingCommitteeTitle {
    return Intl.message(
      'Moon Sighting Committee',
      name: 'calculationMoonSightingCommitteeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 18° and an Isha angle of 18°. Also uses seasonal adjustment values.`
  String get calculationMoonSightingCommitteeDescription {
    return Intl.message(
      'Uses a Fajr angle of 18° and an Isha angle of 18°. Also uses seasonal adjustment values.',
      name: 'calculationMoonSightingCommitteeDescription',
      desc: '',
      args: [],
    );
  }

  /// `ISNA Method`
  String get calculationNorthAmericaTitle {
    return Intl.message(
      'ISNA Method',
      name: 'calculationNorthAmericaTitle',
      desc: '',
      args: [],
    );
  }

  /// `Included for completeness, but not recommended. Uses a Fajr angle of 15° and an Isha angle of 15°`
  String get calculationNorthAmericaDescription {
    return Intl.message(
      'Included for completeness, but not recommended. Uses a Fajr angle of 15° and an Isha angle of 15°',
      name: 'calculationNorthAmericaDescription',
      desc: '',
      args: [],
    );
  }

  /// `Kuwait`
  String get calculationKuwaitTitle {
    return Intl.message(
      'Kuwait',
      name: 'calculationKuwaitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 18° and an Isha angle of 17.5°`
  String get calculationKuwaitDescription {
    return Intl.message(
      'Uses a Fajr angle of 18° and an Isha angle of 17.5°',
      name: 'calculationKuwaitDescription',
      desc: '',
      args: [],
    );
  }

  /// `Qatar`
  String get calculationQatarTitle {
    return Intl.message(
      'Qatar',
      name: 'calculationQatarTitle',
      desc: '',
      args: [],
    );
  }

  /// `A modified version of Umm al-Qura uses a Fajr angle of 18°`
  String get calculationQatarDescription {
    return Intl.message(
      'A modified version of Umm al-Qura uses a Fajr angle of 18°',
      name: 'calculationQatarDescription',
      desc: '',
      args: [],
    );
  }

  /// `Singapore`
  String get calculationSingaporeTitle {
    return Intl.message(
      'Singapore',
      name: 'calculationSingaporeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 20° and an Isha angle of 18°`
  String get calculationSingaporeDescription {
    return Intl.message(
      'Uses a Fajr angle of 20° and an Isha angle of 18°',
      name: 'calculationSingaporeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Turkey`
  String get calculationTurkeyTitle {
    return Intl.message(
      'Turkey',
      name: 'calculationTurkeyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uses a Fajr angle of 18° and an Isha angle of 17°`
  String get calculationTurkeyDescription {
    return Intl.message(
      'Uses a Fajr angle of 18° and an Isha angle of 17°',
      name: 'calculationTurkeyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Institute of Geophysics, University of Tehran`
  String get calculationTehranTitle {
    return Intl.message(
      'Institute of Geophysics, University of Tehran',
      name: 'calculationTehranTitle',
      desc: '',
      args: [],
    );
  }

  /// `Early Isha time at a 14° angle. Fajr time slightly delayed at a 17.7° angle. Maghrib is calculated based on the sun reaching an angle of 4.5° below the horizon.`
  String get calculationTehranDescription {
    return Intl.message(
      'Early Isha time at a 14° angle. Fajr time slightly delayed at a 17.7° angle. Maghrib is calculated based on the sun reaching an angle of 4.5° below the horizon.',
      name: 'calculationTehranDescription',
      desc: '',
      args: [],
    );
  }

  /// `Page`
  String get page {
    return Intl.message(
      'Page',
      name: 'page',
      desc: '',
      args: [],
    );
  }

  /// `Surah`
  String get surah {
    return Intl.message(
      'Surah',
      name: 'surah',
      desc: '',
      args: [],
    );
  }

  /// `Juz`
  String get juz {
    return Intl.message(
      'Juz',
      name: 'juz',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Hizb`
  String get hizb {
    return Intl.message(
      'Hizb',
      name: 'hizb',
      desc: '',
      args: [],
    );
  }

  /// `Once`
  String get once {
    return Intl.message(
      'Once',
      name: 'once',
      desc: '',
      args: [],
    );
  }

  /// `Twice`
  String get twice {
    return Intl.message(
      'Twice',
      name: 'twice',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '3Times' key

  // skipped getter for the '4Times' key

  // skipped getter for the '5Times' key

  /// `Search for Surah`
  String get searchForSurah {
    return Intl.message(
      'Search for Surah',
      name: 'searchForSurah',
      desc: '',
      args: [],
    );
  }

  /// `Search for Juz`
  String get searchForJuz {
    return Intl.message(
      'Search for Juz',
      name: 'searchForJuz',
      desc: '',
      args: [],
    );
  }

  /// `Search for Hizb`
  String get searchForHizb {
    return Intl.message(
      'Search for Hizb',
      name: 'searchForHizb',
      desc: '',
      args: [],
    );
  }

  /// `Search for Ayah...`
  String get searchForAyah {
    return Intl.message(
      'Search for Ayah...',
      name: 'searchForAyah',
      desc: '',
      args: [],
    );
  }

  /// `Ayah Tafsir`
  String get tafsirAyah {
    return Intl.message(
      'Ayah Tafsir',
      name: 'tafsirAyah',
      desc: '',
      args: [],
    );
  }

  /// `Abdul Basit Abdul Samad (Mujawwad)`
  String get defaultReader {
    return Intl.message(
      'Abdul Basit Abdul Samad (Mujawwad)',
      name: 'defaultReader',
      desc: '',
      args: [],
    );
  }

  /// `Morning Azkar`
  String get morningAzkarTitle {
    return Intl.message(
      'Morning Azkar',
      name: 'morningAzkarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Time to recite morning Azkar`
  String get morningAzkarDescription {
    return Intl.message(
      'Time to recite morning Azkar',
      name: 'morningAzkarDescription',
      desc: '',
      args: [],
    );
  }

  /// `Evening Azkar`
  String get eveningAzkarTitle {
    return Intl.message(
      'Evening Azkar',
      name: 'eveningAzkarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Time to recite evening Azkar`
  String get eveningAzkarDescription {
    return Intl.message(
      'Time to recite evening Azkar',
      name: 'eveningAzkarDescription',
      desc: '',
      args: [],
    );
  }

  /// `Sleep Azkar`
  String get sleepAzkarTitle {
    return Intl.message(
      'Sleep Azkar',
      name: 'sleepAzkarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Time to recite sleep Azkar`
  String get sleepAzkarDescription {
    return Intl.message(
      'Time to recite sleep Azkar',
      name: 'sleepAzkarDescription',
      desc: '',
      args: [],
    );
  }

  /// `It is now time for Adhan`
  String get nowPrayerTime {
    return Intl.message(
      'It is now time for Adhan',
      name: 'nowPrayerTime',
      desc: '',
      args: [],
    );
  }

  /// `Tasbeeh`
  String get tasbih {
    return Intl.message(
      'Tasbeeh',
      name: 'tasbih',
      desc: '',
      args: [],
    );
  }

  /// `Edit Tasbeeh`
  String get editTasbih {
    return Intl.message(
      'Edit Tasbeeh',
      name: 'editTasbih',
      desc: '',
      args: [],
    );
  }

  /// `Add New Tasbeeh`
  String get addNewTasbih {
    return Intl.message(
      'Add New Tasbeeh',
      name: 'addNewTasbih',
      desc: '',
      args: [],
    );
  }

  /// `Number of Beads`
  String get noOfBeads {
    return Intl.message(
      'Number of Beads',
      name: 'noOfBeads',
      desc: '',
      args: [],
    );
  }

  /// `Total Number`
  String get totleNo {
    return Intl.message(
      'Total Number',
      name: 'totleNo',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save Editing`
  String get saveEditing {
    return Intl.message(
      'Save Editing',
      name: 'saveEditing',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add Azkar Group`
  String get addGroupAzkar {
    return Intl.message(
      'Add Azkar Group',
      name: 'addGroupAzkar',
      desc: '',
      args: [],
    );
  }

  /// `Group Name`
  String get groupName {
    return Intl.message(
      'Group Name',
      name: 'groupName',
      desc: '',
      args: [],
    );
  }

  /// `Alarm Permission`
  String get showAskUserForAlarmPermissionTitle {
    return Intl.message(
      'Alarm Permission',
      name: 'showAskUserForAlarmPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `To remind you of prayer times and Azkar, the app needs alarm permission`
  String get showAskUserForAlarmPermissionDescription {
    return Intl.message(
      'To remind you of prayer times and Azkar, the app needs alarm permission',
      name: 'showAskUserForAlarmPermissionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get allow {
    return Intl.message(
      'Allow',
      name: 'allow',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get later {
    return Intl.message(
      'Later',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Notification Permission`
  String get showAskUserForNotificationsPermissionTitle {
    return Intl.message(
      'Notification Permission',
      name: 'showAskUserForNotificationsPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `To remind you of prayer times and Azkar, the app needs notification permission`
  String get showAskUserForNotificationsPermissionDescription {
    return Intl.message(
      'To remind you of prayer times and Azkar, the app needs notification permission',
      name: 'showAskUserForNotificationsPermissionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Phone and Compass Calibration`
  String get showQiblaCompassCalibrationDialogTitle {
    return Intl.message(
      'Phone and Compass Calibration',
      name: 'showQiblaCompassCalibrationDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Calibrate the phone and compass using the following steps:`
  String get showQiblaCompassCalibrationDialogDescription1 {
    return Intl.message(
      'Calibrate the phone and compass using the following steps:',
      name: 'showQiblaCompassCalibrationDialogDescription1',
      desc: '',
      args: [],
    );
  }

  /// `Move the phone horizontally (left and right)`
  String get showQiblaCompassCalibrationDialogDescription2 {
    return Intl.message(
      'Move the phone horizontally (left and right)',
      name: 'showQiblaCompassCalibrationDialogDescription2',
      desc: '',
      args: [],
    );
  }

  /// `Move the phone vertically (up and down)`
  String get showQiblaCompassCalibrationDialogDescription3 {
    return Intl.message(
      'Move the phone vertically (up and down)',
      name: 'showQiblaCompassCalibrationDialogDescription3',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the phone around itself clockwise and counterclockwise`
  String get showQiblaCompassCalibrationDialogDescription4 {
    return Intl.message(
      'Rotate the phone around itself clockwise and counterclockwise',
      name: 'showQiblaCompassCalibrationDialogDescription4',
      desc: '',
      args: [],
    );
  }

  /// `Warning: Stay away from magnetic objects`
  String get showQiblaCompassCalibrationDialogDescription5 {
    return Intl.message(
      'Warning: Stay away from magnetic objects',
      name: 'showQiblaCompassCalibrationDialogDescription5',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okay {
    return Intl.message(
      'Okay',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alertTitle {
    return Intl.message(
      'Alert',
      name: 'alertTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have not finished reading Azkar yet, do you want to exit?`
  String get showAzkarNotDoneDialogDescription {
    return Intl.message(
      'You have not finished reading Azkar yet, do you want to exit?',
      name: 'showAzkarNotDoneDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Save progress and exit`
  String get saveAndLeave {
    return Intl.message(
      'Save progress and exit',
      name: 'saveAndLeave',
      desc: '',
      args: [],
    );
  }

  /// `Continue reading`
  String get continueReading {
    return Intl.message(
      'Continue reading',
      name: 'continueReading',
      desc: '',
      args: [],
    );
  }

  /// `Leave`
  String get leave {
    return Intl.message(
      'Leave',
      name: 'leave',
      desc: '',
      args: [],
    );
  }

  /// `Location Services Disabled`
  String get showLocationDisabledDialogTitle {
    return Intl.message(
      'Location Services Disabled',
      name: 'showLocationDisabledDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enable location services to use Qibla.`
  String get showLocationDisabledDialogDescription {
    return Intl.message(
      'Please enable location services to use Qibla.',
      name: 'showLocationDisabledDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Go to Settings`
  String get openLocationSettings {
    return Intl.message(
      'Go to Settings',
      name: 'openLocationSettings',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get showNoInternetDialogTitle {
    return Intl.message(
      'No Internet Connection',
      name: 'showNoInternetDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again later.`
  String get showNoInternetDialogDescription {
    return Intl.message(
      'Something went wrong. Please try again later.',
      name: 'showNoInternetDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Timing files need to be downloaded first for word-by-word. Do you want to download now?`
  String get showAskUserForDownloadTimingDataDescription {
    return Intl.message(
      'Timing files need to be downloaded first for word-by-word. Do you want to download now?',
      name: 'showAskUserForDownloadTimingDataDescription',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Download Failed`
  String get showDownloadFailedDialogTitle {
    return Intl.message(
      'Download Failed',
      name: 'showDownloadFailedDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to download the file. Please try again later.`
  String get showDownloadFailedDialogDescription {
    return Intl.message(
      'Failed to download the file. Please try again later.',
      name: 'showDownloadFailedDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `You have completed reading Azkar`
  String get showAzkarCompletedDialogTitle {
    return Intl.message(
      'You have completed reading Azkar',
      name: 'showAzkarCompletedDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Left`
  String get left {
    return Intl.message(
      'Left',
      name: 'left',
      desc: '',
      args: [],
    );
  }

  /// `Re`
  String get re {
    return Intl.message(
      'Re',
      name: 're',
      desc: '',
      args: [],
    );
  }

  /// `Reset Counters`
  String get showResetTasbihCountersDialogTitle {
    return Intl.message(
      'Reset Counters',
      name: 'showResetTasbihCountersDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to reset the counters?`
  String get showResetTasbihCountersDialogDescription {
    return Intl.message(
      'Are you sure you want to reset the counters?',
      name: 'showResetTasbihCountersDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get showDeleteItemDialogTitle {
    return Intl.message(
      'Confirm Deletion',
      name: 'showDeleteItemDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this item?`
  String get showDeleteItemDialogDescription {
    return Intl.message(
      'Are you sure you want to delete this item?',
      name: 'showDeleteItemDialogDescription',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Previous progress found\n Do you want to continue from where you left off?`
  String get showZkrProgressFoundForContinueDescription {
    return Intl.message(
      'Previous progress found\n Do you want to continue from where you left off?',
      name: 'showZkrProgressFoundForContinueDescription',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continuee {
    return Intl.message(
      'Continue',
      name: 'continuee',
      desc: '',
      args: [],
    );
  }

  /// `Start again`
  String get startAgain {
    return Intl.message(
      'Start again',
      name: 'startAgain',
      desc: '',
      args: [],
    );
  }

  /// `Asr Calculation Method`
  String get calculateAsrTime {
    return Intl.message(
      'Asr Calculation Method',
      name: 'calculateAsrTime',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Loading timing data...`
  String get timingDataIsLoading {
    return Intl.message(
      'Loading timing data...',
      name: 'timingDataIsLoading',
      desc: '',
      args: [],
    );
  }

  /// `Getting current location...`
  String get getCurrentLocationIsLoading {
    return Intl.message(
      'Getting current location...',
      name: 'getCurrentLocationIsLoading',
      desc: '',
      args: [],
    );
  }

  /// `The Ayah`
  String get theAyah {
    return Intl.message(
      'The Ayah',
      name: 'theAyah',
      desc: '',
      args: [],
    );
  }

  /// `(Requires Internet)`
  String get requiredInternet {
    return Intl.message(
      '(Requires Internet)',
      name: 'requiredInternet',
      desc: '',
      args: [],
    );
  }

  /// `Listen to the word`
  String get listenToTheWord {
    return Intl.message(
      'Listen to the word',
      name: 'listenToTheWord',
      desc: '',
      args: [],
    );
  }

  /// `Recitation starts from this Ayah`
  String get recitationRunsFromThisAyah {
    return Intl.message(
      'Recitation starts from this Ayah',
      name: 'recitationRunsFromThisAyah',
      desc: '',
      args: [],
    );
  }

  /// `Tafsir`
  String get tafsir {
    return Intl.message(
      'Tafsir',
      name: 'tafsir',
      desc: '',
      args: [],
    );
  }

  /// `Remove Bookmark`
  String get removeBookMark {
    return Intl.message(
      'Remove Bookmark',
      name: 'removeBookMark',
      desc: '',
      args: [],
    );
  }

  /// `Add Bookmark`
  String get addBookMark {
    return Intl.message(
      'Add Bookmark',
      name: 'addBookMark',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Moved`
  String get heMoved {
    return Intl.message(
      'Moved',
      name: 'heMoved',
      desc: '',
      args: [],
    );
  }

  /// `The Page`
  String get thePage {
    return Intl.message(
      'The Page',
      name: 'thePage',
      desc: '',
      args: [],
    );
  }

  /// `Select Page`
  String get selectPage {
    return Intl.message(
      'Select Page',
      name: 'selectPage',
      desc: '',
      args: [],
    );
  }

  /// `Select Surah`
  String get selectSurah {
    return Intl.message(
      'Select Surah',
      name: 'selectSurah',
      desc: '',
      args: [],
    );
  }

  /// `The Juz`
  String get theJuz {
    return Intl.message(
      'The Juz',
      name: 'theJuz',
      desc: '',
      args: [],
    );
  }

  /// `Select Juz`
  String get selectJuz {
    return Intl.message(
      'Select Juz',
      name: 'selectJuz',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get darkMode {
    return Intl.message(
      'Dark',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get lightMode {
    return Intl.message(
      'Light',
      name: 'lightMode',
      desc: '',
      args: [],
    );
  }

  /// `System Default`
  String get systemMode {
    return Intl.message(
      'System Default',
      name: 'systemMode',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message(
      'Hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get minute {
    return Intl.message(
      'Minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Stay`
  String get stay {
    return Intl.message(
      'Stay',
      name: 'stay',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get bookMarks {
    return Intl.message(
      'Bookmarks',
      name: 'bookMarks',
      desc: '',
      args: [],
    );
  }

  /// `No reference signs are added`
  String get noReferenceSignsAreAdded {
    return Intl.message(
      'No reference signs are added',
      name: 'noReferenceSignsAreAdded',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Now`
  String get prayerNow {
    return Intl.message(
      'Prayer Now',
      name: 'prayerNow',
      desc: '',
      args: [],
    );
  }

  /// `Next Prayer`
  String get prayerNext {
    return Intl.message(
      'Next Prayer',
      name: 'prayerNext',
      desc: '',
      args: [],
    );
  }

  /// `Read the Juz`
  String get readTheJuz {
    return Intl.message(
      'Read the Juz',
      name: 'readTheJuz',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again later.`
  String get somthingWentWrong {
    return Intl.message(
      'Something went wrong. Please try again later.',
      name: 'somthingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Sam`
  String get sam {
    return Intl.message(
      'Sam',
      name: 'sam',
      desc: '',
      args: [],
    );
  }

  /// `Click here to quickly move between pages`
  String get clickHereToSpeedMocingBetweenPages {
    return Intl.message(
      'Click here to quickly move between pages',
      name: 'clickHereToSpeedMocingBetweenPages',
      desc: '',
      args: [],
    );
  }

  /// `Surahs`
  String get noOfTheSurah {
    return Intl.message(
      'Surahs',
      name: 'noOfTheSurah',
      desc: '',
      args: [],
    );
  }

  /// `Juz`
  String get noOfTheJuz {
    return Intl.message(
      'Juz',
      name: 'noOfTheJuz',
      desc: '',
      args: [],
    );
  }

  /// `Hizbs`
  String get noOfTheHizb {
    return Intl.message(
      'Hizbs',
      name: 'noOfTheHizb',
      desc: '',
      args: [],
    );
  }

  /// `Ayahs`
  String get noOfAyah {
    return Intl.message(
      'Ayahs',
      name: 'noOfAyah',
      desc: '',
      args: [],
    );
  }

  /// `Ayah`
  String get ayah {
    return Intl.message(
      'Ayah',
      name: 'ayah',
      desc: '',
      args: [],
    );
  }

  /// `Repetition`
  String get repetition {
    return Intl.message(
      'Repetition',
      name: 'repetition',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get public {
    return Intl.message(
      'General',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `App Theme`
  String get appTheme {
    return Intl.message(
      'App Theme',
      name: 'appTheme',
      desc: '',
      args: [],
    );
  }

  /// `Display, Sound, Download Management`
  String get quranDisplaySettings {
    return Intl.message(
      'Display, Sound, Download Management',
      name: 'quranDisplaySettings',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Times`
  String get prayerSettingsTitle {
    return Intl.message(
      'Prayer Times',
      name: 'prayerSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Calculation Methods, School of Thought, Prayer Notifications`
  String get prayerSettingsDescription {
    return Intl.message(
      'Calculation Methods, School of Thought, Prayer Notifications',
      name: 'prayerSettingsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Azkar`
  String get azkar {
    return Intl.message(
      'Azkar',
      name: 'azkar',
      desc: '',
      args: [],
    );
  }

  /// `Azkar Settings`
  String get AzkarSettingsTitle {
    return Intl.message(
      'Azkar Settings',
      name: 'AzkarSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Font, Notifications`
  String get AzkarSettingsDescription {
    return Intl.message(
      'Font, Notifications',
      name: 'AzkarSettingsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Width`
  String get width {
    return Intl.message(
      'Width',
      name: 'width',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get fontSize {
    return Intl.message(
      'Font Size',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get theNotifications {
    return Intl.message(
      'Notifications',
      name: 'theNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Show alert when leaving`
  String get showAlarmWhenLeave {
    return Intl.message(
      'Show alert when leaving',
      name: 'showAlarmWhenLeave',
      desc: '',
      args: [],
    );
  }

  /// `Alert when Azkar reading is incomplete`
  String get alarmWhenCompleteReadAzkar {
    return Intl.message(
      'Alert when Azkar reading is incomplete',
      name: 'alarmWhenCompleteReadAzkar',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Show notifications to remind for Azkar reading`
  String get showNotificationsForRemindTheReaders {
    return Intl.message(
      'Show notifications to remind for Azkar reading',
      name: 'showNotificationsForRemindTheReaders',
      desc: '',
      args: [],
    );
  }

  /// `Morning Azkar Time`
  String get morningTime {
    return Intl.message(
      'Morning Azkar Time',
      name: 'morningTime',
      desc: '',
      args: [],
    );
  }

  /// `Evening Azkar Time`
  String get eveningTime {
    return Intl.message(
      'Evening Azkar Time',
      name: 'eveningTime',
      desc: '',
      args: [],
    );
  }

  /// `Sleep Azkar Time`
  String get sleepTime {
    return Intl.message(
      'Sleep Azkar Time',
      name: 'sleepTime',
      desc: '',
      args: [],
    );
  }

  /// `Select Calculation Method`
  String get selectCalculateMethod {
    return Intl.message(
      'Select Calculation Method',
      name: 'selectCalculateMethod',
      desc: '',
      args: [],
    );
  }

  /// `Number of Courses`
  String get noOfCourses {
    return Intl.message(
      'Number of Courses',
      name: 'noOfCourses',
      desc: '',
      args: [],
    );
  }

  /// `Total Number`
  String get totalNumber {
    return Intl.message(
      'Total Number',
      name: 'totalNumber',
      desc: '',
      args: [],
    );
  }

  /// `Hadith Text:`
  String get hadithText {
    return Intl.message(
      'Hadith Text:',
      name: 'hadithText',
      desc: '',
      args: [],
    );
  }

  /// `Explanation and Benefits of the Hadith:`
  String get hadithExplainAndBenefits {
    return Intl.message(
      'Explanation and Benefits of the Hadith:',
      name: 'hadithExplainAndBenefits',
      desc: '',
      args: [],
    );
  }

  /// `Shortcuts`
  String get shortcuts {
    return Intl.message(
      'Shortcuts',
      name: 'shortcuts',
      desc: '',
      args: [],
    );
  }

  /// `Today's Dua`
  String get duaToday {
    return Intl.message(
      'Today\'s Dua',
      name: 'duaToday',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message(
      'Information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Today's Hadith`
  String get hadithToday {
    return Intl.message(
      'Today\'s Hadith',
      name: 'hadithToday',
      desc: '',
      args: [],
    );
  }

  /// `Today's Ayah`
  String get ayahToday {
    return Intl.message(
      'Today\'s Ayah',
      name: 'ayahToday',
      desc: '',
      args: [],
    );
  }

  /// `More Activities`
  String get moreActivities {
    return Intl.message(
      'More Activities',
      name: 'moreActivities',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Times Settings`
  String get prayerTimesSettings {
    return Intl.message(
      'Prayer Times Settings',
      name: 'prayerTimesSettings',
      desc: '',
      args: [],
    );
  }

  /// `Calculation Methods`
  String get calculationMethod {
    return Intl.message(
      'Calculation Methods',
      name: 'calculationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Calculation Method`
  String get calculateMethod {
    return Intl.message(
      'Calculation Method',
      name: 'calculateMethod',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Notifications`
  String get notificationsPrayers {
    return Intl.message(
      'Prayer Notifications',
      name: 'notificationsPrayers',
      desc: '',
      args: [],
    );
  }

  /// `Note: Changes will be applied after the next notification.`
  String get notePrayerSeettings {
    return Intl.message(
      'Note: Changes will be applied after the next notification.',
      name: 'notePrayerSeettings',
      desc: '',
      args: [],
    );
  }

  /// `Please allow location permissions at least once to get prayer times data`
  String get pleaseAllowPermissionFotGetPrayerTimes {
    return Intl.message(
      'Please allow location permissions at least once to get prayer times data',
      name: 'pleaseAllowPermissionFotGetPrayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `Give Permission`
  String get givePermission {
    return Intl.message(
      'Give Permission',
      name: 'givePermission',
      desc: '',
      args: [],
    );
  }

  /// `of the True North`
  String get ofTheRealNorth {
    return Intl.message(
      'of the True North',
      name: 'ofTheRealNorth',
      desc: '',
      args: [],
    );
  }

  /// `Calibrate the compass every time you use it`
  String get qiblaDescription {
    return Intl.message(
      'Calibrate the compass every time you use it',
      name: 'qiblaDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please allow location permissions to get the Qibla direction`
  String get pleaseAllowPermissionFotGetQiblaDirection {
    return Intl.message(
      'Please allow location permissions to get the Qibla direction',
      name: 'pleaseAllowPermissionFotGetQiblaDirection',
      desc: '',
      args: [],
    );
  }

  /// `Location settings were stopped. Please enable them to continue`
  String get locationWasStoppingPleaseEnable {
    return Intl.message(
      'Location settings were stopped. Please enable them to continue',
      name: 'locationWasStoppingPleaseEnable',
      desc: '',
      args: [],
    );
  }

  /// `Enable Location Settings`
  String get enableLocationSettings {
    return Intl.message(
      'Enable Location Settings',
      name: 'enableLocationSettings',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
