import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/quran_audio_player_settings_controller.dart';
import 'package:islamina_app/data/models/quran_play_range_model.dart';
import 'package:islamina_app/handlers/reader_timing_data_download_handler.dart';

import '../../../../../data/models/quran_reader.dart';
import '../../../../../services/audio/audio_manager.dart';
import '../../../../../services/audio/setup_audio.dart';
import '../data/cache/audio_settings_cache.dart';
import '../../data/repository/quran_audio_playlist_repository.dart';
import '../data/cache/quran_reader_cache.dart';
import 'quran_reading_controller.dart';

class QuranAudioPlayerBottomBarController extends GetxController {
  // Instance of the audio handler
  AudioPlayerHandlerImpl? audioHandler;


  // Observable to track visibility of controls
  final isControlsVisible = false.obs;
  RxBool isAyahSelected = false.obs;

  // Instance of the QuranReadingController to interact with Quran reading view
  final QuranReadingController quranPageViewController = Get.find();

  // Observable to track the selected Quran reader
  final Rx<QuranReader> selectedReader = QuranReader().obs;

  // Observable to track playback speed
  var playbackSpeed = 1.0.obs;

  // Method to change playback speed
  void changeSpeed() async {
    final availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75];
    final currentSpeed = playbackSpeed.value;
    final currentIndex = availableSpeeds.indexOf(currentSpeed);

    // Cycle to the next speed or wrap back to the first speed
    final nextIndex = (currentIndex + 1) % availableSpeeds.length;
    final nextSpeed = availableSpeeds[nextIndex];

    playbackSpeed.value = nextSpeed;
    await audioHandler!.setSpeed(playbackSpeed.value);
  }

  // Observable to track repeat
  var playbackRepeat = 1.obs;

  final audioSettingsController = Get.put(QuranAudioSettingsController());
  // Method to change repeat
  void changeRepeat() async {
    // final availableRepeats = [1, 2, 3, 4, 5];
    final availableRepeats = audioSettingsController.repeatChoice.keys.toList();
    // controller.selectedRepeat =
    //     controller.repeatChoice[AudioSettingsCache.getRepeat()].toString();
    final currentRepeat = playbackRepeat;
    // final currentRepeat = int.tryParse(controller.selectedRepeat) ?? 1;
    final currentIndex = availableRepeats.indexOf(currentRepeat.value);

    // Cycle to the next Repeat or wrap back to the first Repeat
    final nextIndex = (currentIndex + 1) % availableRepeats.length;
    final nextRepeat = availableRepeats[nextIndex];

    playbackRepeat.value = nextRepeat;

    // audioSettingsController.selectedRepeat = nextRepeat.toString();
    // audioSettingsController.selectedRepeat =
    //     audioSettingsController.repeatChoice.values.firstWhere((element) =>
    //         audioSettingsController.repeatChoice[element] ==
    //         audioSettingsController.selectedRepeat);
    audioSettingsController.selectedRepeat =
        audioSettingsController.repeatChoice[nextRepeat] ?? '';

    AudioSettingsCache.saveRepeat(repeatTimes: nextRepeat);
    audioSettingsController.update();

    audioSettingsController.initSettings();

    audioSettingsController.update();

    // await audioHandler!.setRepeat(playbackRepeat.value);
  }

  // Method to handle the main play button press
  Future<void> onMainPlayPressed({QuranPlayRangeModel? playRangeModel}) async {
    // Check if timing data is available
    // if (QuranSettingsCache.isWordByWordListen()) {
    //   if (await checkIfTimingDataAvailable()) {
    //     startPlaying(playRangeModel: playRangeModel, isWordByWord: true);
    //   } else {
    //     startPlaying(playRangeModel: playRangeModel, isWordByWord: false);
    //   }
    // } else {
    //   startPlaying(playRangeModel: playRangeModel, isWordByWord: false);
    // }
    quranPageViewController.volumeController.removeListener();
    startPlaying(playRangeModel: playRangeModel, isWordByWord: false);
  }

  // Method to check if timing data is available
  Future<bool> checkIfTimingDataAvailable() async {
    return await ReaderTimingDataDownloadHandler.checkIfDataExists(
        reader: selectedReader.value);
  }

  void startPlaying(
      {QuranPlayRangeModel? playRangeModel, required bool isWordByWord}) async {
    // Retrieve the saved play range or use default values
    playRangeModel ??= AudioSettingsCache.getQuranPlayRange();

    // Retrieve player speed settings
    final playerSpeed = AudioSettingsCache.getSpeed();
    playbackSpeed.value = AudioSettingsCache.getSpeed();

    // Setup and prepare the audio player
    await setupAudioPlayer();
    audioHandler = getIt<AudioPlayerHandlerImpl>();
    await audioHandler!.prepare();
    audioHandler!.isWordByWord = isWordByWord;
    // Show controls
    isControlsVisible.value = true;

    // Add queue items and play
    await audioHandler!
        .addQueueItems(await createPlaylistFromRange(playRangeModel));
    await audioHandler!.setSpeed(playerSpeed);
    await audioHandler!.play();
  }

  @override
  void onInit() async {
    super.onInit();
    selectedReader.value = QuranReaderCache.getSelectedReaderFromCache();
    playbackRepeat =
        Get.find<QuranAudioPlayerBottomBarController>().playbackRepeat;

    playbackRepeat.value = audioSettingsController.repeatChoice.keys.firstWhere(
        (element) =>
            audioSettingsController.repeatChoice[element] ==
            audioSettingsController.selectedRepeat);
  }
}
