import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/features/khatma/data/models/khatma_model.dart';
import 'package:islamina_app/routes/app_pages.dart';
import 'package:islamina_app/services/shared_preferences_service.dart';
import 'package:islamina_app/utils/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart' as quran;
part 'khatma_state.dart';

class KhatmaCubit extends Cubit<KhatmaState> {
  KhatmaCubit() : super(KhatmaInitial());
  static final SharedPreferences prefs = SharedPreferencesService.instance.prefs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker();

  //! handle khatma
  int khatamaRadioValue = 0;
  int khatmaWayRadioValue = 0;
  String khatmaChipsValue = 'Reading';
  PageController khatmaPageViewController = PageController();
  TextEditingController khatmaNameController = TextEditingController();
  TextEditingController khatmaDescriptionController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  resetKhatmaComponents() {
    khatamaRadioValue = 0;
    khatmaWayRadioValue = 0;
    khatmaChipsValue = 'Reading';
    khatmaNameController.clear();
    khatmaDescriptionController.clear();
    daysController.clear();
    selectedJuzIndex = 0;
    selectedUnit = 'juz';
    expectedPeriodOfKhatma = 0;
    selectedJuz = 1.getJuzName;
    handleTextExpectedPeriodOfKhatma = '';
    unitIndex = 0;
    initialPage = 0;
    lastPage = 0;
    selectedDestiny = 0;
  }

  void changeAddKhatmaPage(bool isNext) {
    emit(KhatmaInitial());
    if (isNext) {
      khatmaPageViewController.nextPage(duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
    } else {
      khatmaPageViewController.previousPage(duration: const Duration(milliseconds: 10), curve: Curves.easeIn);
    }
    emit(PageViewChanged());
  }

  void restartPageView() {
    khatmaPageViewController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeInOut,
    );
  }

  void changeKhatamaRadioValue(int value) {
    emit(KhatmaInitial());
    khatamaRadioValue = value;
    emit(KhatamaRadioChanged());
  }

  void changeKhatamaWayRadioValue(int value) {
    emit(KhatmaInitial());
    khatmaWayRadioValue = value;
    emit(khatmaWayRadioValueChanged());
  }

  void changeKhatmaChipsValue(String value) {
    emit(KhatmaInitial());
    khatmaChipsValue = value;
    emit(KhatamaChipsChanged());
  }

  String selectedJuz = 1.getJuzName;
  int selectedJuzIndex = 0;
  List<String> juz = BlocProvider.of<ThemeCubit>(Get.context!).locale.languageCode == 'ar' ? List.generate(30, (index) => (index + 1).getJuzName) : List.generate(30, (index) => (index + 1).getJuzNameEnglish);
  List<int> juzUnits = List.generate(30, (index) => index);
  List<int> hizbUnits = List.generate(60, (index) => index);
  List<int> quarterHizbUnits = List.generate(60 * 4, (index) => index);
  List<int> surahUnits = List.generate(114, (index) => index);
  List<int> pageUnits = List.generate(604, (index) => index);
  int unitIndex = 0;
  String selectedUnit = 'juz';
  List<String> units = ['juz', 'hizb', 'quarter_hizb', 'surah', 'page'];
  List<String> juzNames = List.generate(30, (index) => (index + 1).getJuzName);
  int get valueOfUnit {
    switch (unitIndex) {
      case 0:
        return 30;
      case 1:
        return 60;
      case 2:
        return 240;
      case 3:
        return 114;
      case 4:
        return 604;
      default:
        return 30;
    }
  }

  int selectedDestiny = 0;
  List<int> get listOfSelectedUnitIndex {
    switch (unitIndex) {
      case 0:
        return juzUnits;
      case 1:
        return hizbUnits;
      case 2:
        return quarterHizbUnits;
      case 3:
        return surahUnits;
      case 4:
        return pageUnits;
      default:
        return juzUnits;
    }
  }

// calculateKhatmaByNoOfDay

  calculateExpectedPeriod() {
    emit(KhatmaInitial());
    if (khatmaWayRadioValue == 0) calculateKhatmaByNoOfDay();
    if (khatmaWayRadioValue == 1) calculateKhatmaByReadingOfDay();
    emit(khatmaPeriodChangedState());
  }

  int expectedPeriodOfKhatma = 0;
  String handleTextExpectedPeriodOfKhatma = '';
  List<KhatmaModel> khatmas = [];
  List<KhatmaModel> doneKhatmas = [];
  int initialPage = 0;
  int lastPage = 0;

  void calculateKhatmaByReadingOfDay() {
    expectedPeriodOfKhatma = ((calculateDifferenceInDays(valueOfUnit)) / (selectedDestiny + 1)).ceil();
    initialPage = (valueOfUnit - (calculateDifferenceInDays(valueOfUnit) - 1)) == 0 ? 1 : (valueOfUnit - (calculateDifferenceInDays(valueOfUnit) - 1));
    lastPage = (initialPage + (selectedDestiny + 1)) == 0 ? 1 : (initialPage + (selectedDestiny + 1));
  }

  int calculateDifferenceInDays(valueofUnit) {
    final surahAndVerses = quran.getSurahAndVersesFromJuz(selectedJuzIndex + 1);
    final currentPage = quran.getPageNumber(surahAndVerses.keys.first, surahAndVerses.values.first.first);
    if (valueofUnit == 30) {
      return (valueofUnit - selectedJuzIndex * 1);
    } else if (valueofUnit == 60) {
      return (valueofUnit - selectedJuzIndex * 2);
    } else if (valueofUnit == 240) {
      return (valueofUnit - selectedJuzIndex * 8);
    } else if (valueofUnit == 114) {
      return (valueofUnit - surahAndVerses.keys.first) + 1;
    }
    return (valueofUnit - (currentPage - 1));
  }

  void calculateKhatmaByNoOfDay() {
    int days = int.tryParse(daysController.text) ?? 1;
    if (days <= 604 && days >= 1) {
      initialPage = (604 - (calculateDifferenceInDays(604) - 1)) == 0 ? 1 : (604 - (calculateDifferenceInDays(604) - 1));
      int pages = calculateDifferenceInDays(604);
      expectedPeriodOfKhatma = (pages / days).ceil();
      lastPage = expectedPeriodOfKhatma + initialPage;
      handleTextExpectedPeriodOfKhatma = '$expectedPeriodOfKhatma ${Get.context!.translate("page")}';
    } else {
      Fluttertoast.showToast(msg: Get.context!.translate("please_enter_valid_number"));
    }
  }

//! save and get khatma model list
// Encode and Decode Functions
  String encodeToJson(KhatmaModel model) {
    return jsonEncode(model.toJson());
  }

  List<String> encodeListToJson(List<KhatmaModel> models) {
    return models.map((model) => encodeToJson(model)).toList();
  }

  KhatmaModel decodeFromJson(String jsonString) {
    try {
      return KhatmaModel.fromJson(jsonDecode(jsonString));
    } catch (e) {
      throw e;
    }
  }

  List<KhatmaModel> decodeListFromJson(List<String> jsonStringList) {
    return jsonStringList.map((jsonString) => decodeFromJson(jsonString)).toList();
  }

  Future<void> saveKhatmaModelList(List<KhatmaModel> models) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = encodeListToJson(models);
    await prefs.setStringList('khatmaModelList', encodedList);
  }

  Future<List<KhatmaModel>> getKhatmaModelList() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedList = prefs.getStringList('khatmaModelList');
    if (encodedList != null) {
      return decodeListFromJson(encodedList);
    }
    return [];
  }

  getAllKhatma() async {
    List<KhatmaModel> allKhatma = [];
    emit(GetAllKhatmaLoadingState());
    try {
      allKhatma = await getKhatmaModelList();
      khatmas = allKhatma.where((khatma) => khatma.initialPage < khatma.valueOfUnit).toList();
      emit(GetAllKhatmaSuccessState(khatmas));
    } catch (e) {
      emit(GetAllKhatmaErrorState());
    }
  }

  getDoneKhatma() async {
    emit(GetAllDoneKhatmaLoadingState());
    try {
      final allkhatma = await getKhatmaModelList();
      doneKhatmas = allkhatma.where((khatma) => khatma.initialPage >= khatma.valueOfUnit).toList();
      emit(GetAllDoneKhatmaSuccessState(doneKhatmas));
    } catch (e) {
      emit(GetAllKhatmaErrorState());
    }
  }

  saveKhatma(KhatmaModel model) async {
    try {
      emit(KhatmaAddLoadingState());
      khatmas = await getKhatmaModelList();
      khatmas.add(model);
      await saveKhatmaModelList(khatmas);
      emit(KhatmaAddedSuccessState());
    } catch (e) {
      emit(KhatmaAddErrorState());
    }
  }

  Future<void> updateKhatma(KhatmaModel updatedKhatma) async {
    // emit(KhatmaAddLoadingState());
    List<KhatmaModel> khatmaModelList = await getKhatmaModelList();
    KhatmaModel? khatmaToUpdate = khatmaModelList.firstWhere((khatma) => khatma.id == updatedKhatma.id);

    khatmaToUpdate.initialPage = updatedKhatma.initialPage;
    khatmaToUpdate.lastPage = updatedKhatma.lastPage;
    khatmaToUpdate.lastModified = updatedKhatma.lastModified;
    khatmaToUpdate.isTaped = updatedKhatma.isTaped;
    await saveKhatmaModelList(khatmaModelList);
    // emit(KhatmaAddedSuccessState());
    getDoneKhatma();
    getAllKhatma();
  }

  Future<void> syncKhatmas() async {
    try {
      emit(SyncKhatmaLoadingState());

      // // 1. Check internet connection
      if (await internetConnectionChecker.hasConnection == false) {
        Fluttertoast.showToast(msg: "No internet connection!");
        emit(SyncKhatmaErrorState());
        return;
      }
      // 2. Get the current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Fluttertoast.showToast(msg: "User not logged in!");
        emit(NoUserState());
        Get.toNamed(Routes.login);
        return;
      }

      // 3. Fetch local khatmas
      final localKhatmas = await getKhatmaModelList();

      // 4. Fetch khatmas from Firebase for this user
      final firebaseKhatmas = await fetchKhatmasFromFirebase(userId);

      // 5. Merge both lists
      final mergedKhatmas = mergeKhatmas(localKhatmas, firebaseKhatmas);

      // 6. Update both local and Firebase data
      await saveKhatmaModelList(mergedKhatmas); // Save to local storage
      await saveKhatmasToFirebase(userId, mergedKhatmas); // Save to Firebase

      Fluttertoast.showToast(msg: "Khatmas synced successfully!");
      emit(SyncKhatmaSuccessState());
      getAllKhatma();
      getDoneKhatma();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to sync khatmas: $e");
      emit(SyncKhatmaErrorState());
    }
  }

  List<KhatmaModel> mergeKhatmas(List<KhatmaModel> localKhatmas, List<KhatmaModel> firebaseKhatmas) {
    // Use a map to ensure uniqueness by khatma ID
    final Map<String, KhatmaModel> mergedKhatmasMap = {};

    // Add Firebase khatmas to the map, overriding if necessary
    for (var khatma in firebaseKhatmas) {
      mergedKhatmasMap[khatma.id] = khatma;
    }

    // Add local khatmas to the map
    for (var khatma in localKhatmas) {
      mergedKhatmasMap[khatma.id] = khatma;
    }

    // Convert the map values back to a list
    return mergedKhatmasMap.values.toList();
  }

  Future<List<KhatmaModel>> fetchKhatmasFromFirebase(String userId) async {
    final snapshot = await firestore.collection('users').doc(userId).collection('khatmas').get();
    return snapshot.docs.map((doc) => KhatmaModel.fromJson(doc.data())).toList();
  }

// Save khatmas to Firebase for a specific user
  Future<void> saveKhatmasToFirebase(String userId, List<KhatmaModel> khatmas) async {
    final batch = firestore.batch();
    final userCollection = firestore.collection('users').doc(userId).collection('khatmas');
    for (var khatma in khatmas) {
      final doc = userCollection.doc(khatma.id);
      batch.set(doc, khatma.toJson());
    }
    await batch.commit();
  }
}
