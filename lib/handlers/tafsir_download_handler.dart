import 'package:islamina_app/constants/save_locations.dart';
import 'package:islamina_app/data/models/tafsir.dart';
import 'package:islamina_app/services/download_service.dart';
import 'package:islamina_app/utils/dialogs/dialogs.dart';
import 'package:islamina_app/utils/utils.dart';

class TafsirDownloadHandler {
  Future<void> deleteDownloadedTafsir({required tafsirIdentifier}) async {
    final savedLocation = await SaveLocationsPaths.getTafsirSaveLocationUrl();
    final fullPath = savedLocation + tafsirIdentifier;
    Utils.deleteDirectory(filePath: fullPath);
  }

  Future<bool> downloadTafsir({required Tafsir tafsir, required Function(int count, int total) onReceiveProgress}) async {
    final saveLocation = await SaveLocationsPaths.getTafsirSaveLocationUrl();

    if (await Utils.checkForInternetConnection()) {
      if (await DownloadService().downloadFile(
        url: tafsir.url,
        saveLocation: saveLocation,
        fileName: tafsir.identifier!,
        onReceiveProgress: onReceiveProgress,
      )) {
        return true;
      }
      showDownloadFailedDialog();
      return false;
    } else {
      showNoInternetDialog();
      return false;
    }
  }
}
