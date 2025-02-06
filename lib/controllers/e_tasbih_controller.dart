import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/data/models/e_tasbih.dart';
import 'package:islamina_app/data/repository/e_tasbih_repository.dart';
import 'package:islamina_app/features/sebha/widgets/sebha_widget.dart';

import 'package:islamina_app/utils/dialogs/dialogs.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

import '../utils/dialogs/add_edit_tasbih_dialog.dart';

class ElectronicTasbihController extends GetxController {
  final RxList<ElectronicTasbihModel> tasbihData = <ElectronicTasbihModel>[].obs;
  late ElectronicTasbihModel eTasbihModel;

  late final ElectronicTasbihRepository electronicTasbihRepository;
  AudioPlayer audioPlayer = AudioPlayer();
  List<BeadModel> beads = [
    BeadModel(beadPath: 'assets/images/bead-2.png', mandalaPath: 'assets/images/mandala.png', wireColor: Colors.orange.shade400, textColor: Get.theme.primaryColor, index: 0),
    BeadModel(beadPath: 'assets/images/bead-green.png', mandalaPath: 'assets/images/green-mandala.png', wireColor: Get.theme.primaryColor, textColor: Colors.white, index: 1),
    BeadModel(beadPath: 'assets/images/bead-purple.png', mandalaPath: 'assets/images/purple-mandala.png', wireColor: Colors.purple.shade400, textColor: Colors.white, index: 2),
  ]; // List to store bead models>
  PageController pageController = PageController();
  int beadIndex = 2;

  void changeBead(int index) {
    beadIndex = index;
    update();
  }

  void changeETasbih(ElectronicTasbihModel eTasbihModel) {
    this.eTasbihModel = eTasbihModel;
    update();
  }

  fetchDate() async {
    tasbihData.value = await electronicTasbihRepository.getAllTasbih();
    update();
  }

  void editTasbih(ElectronicTasbihModel tasbih) async {
    var result = await Get.dialog(
      AddEditTasbihDialog(
        isEditing: true,
        editItem: tasbih,
      ),
    );
    if (result != null) {
      await electronicTasbihRepository.updateTasbih(electronicTasbihModel: result);
      fetchDate();
      Get.back();
    }
  }

  void addTasbih() async {
    var result = await Get.dialog(
      AddEditTasbihDialog(
        isEditing: false,
      ),
    );
    if (result != null) {
      await electronicTasbihRepository.insertTasbih(electronicTasbihModel: result);
      fetchDate();
    }
  }

  void deleteAllTasbih() async {
    await electronicTasbihRepository.deleteAllTasbih();
    fetchDate();
  }

  void deleteTasbih(int id) async {
    var result = await showDeleteItemDialog();
    if (result) {
      await electronicTasbihRepository.deleteTasbih(id: id);
      fetchDate();
      Get.back();
    }
  }

  void onResetCounterPressed({required ElectronicTasbihModel eTasbihModel}) async {
    if (await showResetTasbihCountersDialog()) {
      resetCounter(eTasbihModel: eTasbihModel);
    }
  }

  void resetCounter({required ElectronicTasbihModel eTasbihModel}) async {
    eTasbihModel.counter.value = 0;
    eTasbihModel.totalCounter.value = 0;
    await electronicTasbihRepository.resetCounter(id: eTasbihModel.id!);
    update();
  }

  void counterIncrement({required ElectronicTasbihModel eTasbihModel}) async {
    eTasbihModel.counter.value += 1;
    eTasbihModel.totalCounter.value += 1;
    if (eTasbihModel.counter.value == eTasbihModel.count) {
      Vibration.vibrate(duration: 150);
      await audioPlayer.setVolume(0.1);
      await audioPlayer.seek(Duration.zero); // Restart the audio to the beginning
      await audioPlayer.play();
    }
    if (eTasbihModel.counter.value > eTasbihModel.count) {
      eTasbihModel.counter.value = 1;
    }
    await electronicTasbihRepository.updateCounters(eTasbihModel: eTasbihModel);
    update();
  }

  void counterDecrement({required ElectronicTasbihModel eTasbihModel}) async {
    if (eTasbihModel.counter.value == 0) {
      return;
    }
    eTasbihModel.counter.value -= 1;

    eTasbihModel.totalCounter.value -= 1;

    if (eTasbihModel.counter.value == eTasbihModel.count) {
      Vibration.vibrate(duration: 150);
    }
    if (eTasbihModel.counter.value > eTasbihModel.count) {
      eTasbihModel.counter.value = 1;
    }
    await electronicTasbihRepository.updateCounters(eTasbihModel: eTasbihModel);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    electronicTasbihRepository = ElectronicTasbihRepository();
    audioPlayer.setAsset('assets/audio/ring_sound.wav');
    await fetchDate();
    eTasbihModel = tasbihData[0];
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayer.dispose();
  }
}
