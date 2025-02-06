import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islamina_app/services/download_service.dart';
import 'package:islamina_app/utils/dialogs/dialogs.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../data/cache/quran_settings_cache.dart';
import '../data/models/quran_settings_model.dart';
import 'quran_reading_controller.dart';

class QuranSettingsController extends GetxController {
  late final QuranSettingsModel settingsModel;
  QuranReadingController? quranReadingController;
  RxBool loading = false.obs;
  // Method to handle the switch for marker color
  void onMarkerColorSwitched(bool value) async {
    settingsModel.isMarkerColored = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  void onWordByWordSwitched(bool value) async {
    settingsModel.wordByWordListen = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  void onDisplayTwoPage(bool value) async {
    settingsModel.isDisplayTwoPage = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to handle the change in display font size
  void onDisplayFontSizeChanged(double value) async {
    settingsModel.displayFontSize = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to handle the change in page display option
  void onDisplayOptionChanged(bool isAdaptive) async {
    settingsModel.isAdaptiveView = isAdaptive;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to update the settings cache
  Future<void> _updateSettingsCache() async {
    QuranSettingsCache.setMarkerColor(value: settingsModel.isMarkerColored);

    QuranSettingsCache.setQuranFontSize(fontSize: settingsModel.displayFontSize);
    QuranSettingsCache.setQuranAdaptiveView(isAdaptiveView: settingsModel.isAdaptiveView);
    QuranSettingsCache.setWordByWordListen(isWordByWord: settingsModel.wordByWordListen);
    QuranSettingsCache.setDisplayTwoPage(value: settingsModel.isDisplayTwoPage);

    try {
      quranReadingController = Get.find<QuranReadingController>();

      quranReadingController!.displaySettings = settingsModel;
      quranReadingController!.update();
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  Future<void> downloadPDF() async {
    const String fileName = "quran.pdf";

    loading.value = true; // Indicate loading

    try {
      // Let the user pick a directory
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath == null) {
        log("User canceled the directory selection.");
        loading.value = false;
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("Download Failed")));
        return;
      }
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.loading,
        title: 'Downloading',
      
        barrierDismissible: false,
      );
      await Future.delayed(const Duration(seconds: 3), () {});

      final String saveLocation = "$directoryPath/";

      final ByteData data = await rootBundle.load('assets/quran1_merged.pdf');
      final buffer = data.buffer.asUint8List();

      await File(saveLocation + fileName).writeAsBytes(buffer);
      log("File saved to $saveLocation$fileName");
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("File saved to $saveLocation$fileName")));
      loading.value = false;
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("Download Failed")));
      showDownloadFailedDialog();

      loading.value = false;
    }
  }

  // Method to initialize the controller
  Future<void> init() async {
    settingsModel = QuranSettingsModel();
    settingsModel.isMarkerColored = QuranSettingsCache.isQuranColored();
    settingsModel.isAdaptiveView = QuranSettingsCache.isQuranAdaptiveView();
    settingsModel.displayFontSize = QuranSettingsCache.getQuranFontSize();
    settingsModel.wordByWordListen = QuranSettingsCache.isWordByWordListen();
    settingsModel.isDisplayTwoPage = QuranSettingsCache.isDisplayTwoPageListen();

    update(); // Manually trigger UI update after initialization
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
