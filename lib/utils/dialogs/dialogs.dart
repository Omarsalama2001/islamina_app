// Show a dialog indicating no internet connection.
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:islamina_app/constants/json_path.dart';

Future<bool> showAskUserForAlarmPermission() async {
  return await Get.dialog(AlertDialog(
    title:  Text(Get.context!.translate("showAskUserForAlarmPermissionTitle")),
    content:  Text( Get.context!.translate("showAskUserForAlarmPermissionDescription")),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Get.back(result: true);
        },
        child:  Text(Get.context!.translate("allow")),
      ),
      TextButton(
        onPressed: () {
          Get.back(result: false);
        },
        child:  Text(Get.context!.translate("later")),
      )
    ],
  ));
}

Future<bool> showAskUserForNotificationsPermission() async {
  return await Get.dialog(AlertDialog(
    title:  Text(Get.context!.translate("showAskUserForNotificationsPermissionTitle") ),
    content:  Text(Get.context!.translate("showAskUserForNotificationsPermissionDescription") ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back(result: true);
        },
        child:  Text( Get.context!.translate("allow") ),
      ),
      TextButton(
        onPressed: () {
          Get.back(result: false);
        },
        child:  Text( Get.context!.translate("later") ),
      )
    ],
  ));
}

// show qibla compass calibration dialog
void showQiblaCompassCalibrationDialog() {
  Get.dialog(
    AlertDialog(
      title: Text(Get.context!.translate("showQiblaCompassCalibrationDialogTitle")),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(Get.context!.translate("showQiblaCompassCalibrationDialogDescription1")),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.arrow_forward, color: Colors.blue),
                SizedBox(width: 8),
                Flexible(
                  child: Text(Get.context!.translate("showQiblaCompassCalibrationDialogDescription2")),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_downward, color: Colors.blue),
                SizedBox(width: 8),
                Flexible(
                  child: Text(Get.context!.translate("showQiblaCompassCalibrationDialogDescription3")),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.refresh, color: Colors.blue),
                SizedBox(width: 8),
                Flexible(child: Text(Get.context!.translate("showQiblaCompassCalibrationDialogDescription4"))),
              ],
            ),
            SizedBox(height: 16),
            Text(Get.context!.translate("showQiblaCompassCalibrationDialogDescription5")),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(Get.context!.translate("okay")),
          onPressed: () {
            Get.back(); // Close the dialog
          },
        ),
      ],
    ),
  );
}

// show azkar not done alert dialog
Future<bool?> showAzkarNotDoneDialog() async {
  return await Get.dialog<bool>(
    AlertDialog(
      title:  Text(Get.context!.translate('alertTitle')),
      content: SizedBox(
        width: 100.w,
        child:  Text(Get.context!.translate('showAzkarNotDoneDialogDescription')),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Get.back(result: true),
              child:  Text(Get.context!.translate('saveAndLeave')),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child:  Text(Get.context!.translate('continueReading')),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child:  Text(Get.context!.translate('left')),
                ),
              ],
            )
          ],
        ),
      ],
    ),
  );
}

// show enable location to continue
Future<void> showLocationDisabledDialog() async {
  await Get.dialog(
    AlertDialog(
      title:  Text( Get.context!.translate('showLocationDisabledDialogTitle')),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(Get.context!.translate('showLocationDisabledDialogDescription')),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(5),
      actions: <Widget>[
        TextButton(
          child: Text(Get.context!.translate('openLocationSettings')),
          onPressed: () async {
            await Geolocator.openLocationSettings();
          },
        ),
        TextButton(
          child: Text(Get.context!.translate('cancel')),
          onPressed: () {
            Get.back(); // Close the dialog
          },
        ),
      ],
    ),
  );
}

// Show a dialog indicating no internet connection.
Future<void> showNoInternetDialog() async {
  await Get.dialog(
    AlertDialog(
      title: Text(Get.context!.translate('showNoInternetDialogTitle')),
      content: Text(Get.context!.translate('showNoInternetDialogDescription')),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(Get.context!.translate('ok')),
        ),
      ],
    ),
  );
}

Future<bool> showAskUserForDownloadTimingData() async {
  return await Get.dialog(
    AlertDialog(
      title: Text(Get.context!.translate('alertTitle')),
      content: Text(Get.context!.translate('showAskUserForDownloadTimingDataDescription')),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text(Get.context!.translate('download')),
        ),
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(Get.context!.translate('cancel')),
        ),
      ],
    ),
  );
}

// عرض مربع حوار يشير إلى فشل التنزيل.
Future<void> showDownloadFailedDialog() async {
  await showDialog(
    context: Get.overlayContext!,
    builder: (context) {
      return AlertDialog(
        title: Text(Get.context!.translate('showDownloadFailedDialogTitle')),
        content: Text(Get.context!.translate('showDownloadFailedDialogDescription')),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(Get.context!.translate('ok')),
          ),
        ],
      );
    },
  );
}

// show Completed dialog for  azkar
Future<dynamic> showAzkarCompletedDialog() {
  return Get.dialog(
    AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: LottieBuilder.asset(
              JsonPaths.checkIcon,
            ),
          ),
          Text(Get.context!.translate('showAzkarCompletedDialogTitle')),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.close(2);
            },
            child: Text(Get.context!.translate('left'))),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: Text(Get.context!.translate('re')),
        ),
      ],
    ),
  );
}

Future<bool> showResetTasbihCountersDialog() async {
  return await Get.dialog(
    AlertDialog(
      title: Text(Get.context!.translate('showResetTasbihCountersDialogTitle')),
      content: Text(
        Get.context!.translate('showResetTasbihCountersDialogDescription'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: Text(
            Get.context!.translate('cancel'),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: Text(
            Get.context!.translate('reset'),
          ),
        ),
      ],
    ),
  );
}

Future<bool> showDeleteItemDialog() async {
  return await Get.dialog(
    AlertDialog(
      title: Text(Get.context!.translate('showDeleteItemDialogTitle')),
      content: Text(Get.context!.translate('showDeleteItemDialogDescription')),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false); // Close the dialog
          },
          child: Text(
            Get.context!.translate('cancel'),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true); // Close the dialog
          },
          child: Text(
            Get.context!.translate('delete'),
          ),
        ),
      ],
    ),
  );
}

// show Zkr Progress is found
Future<bool?> showZkrProgressFoundForContinue() async {
  return await Get.dialog<bool>(
    AlertDialog(
      title: Text(Get.context!.translate('alertTitle')),
      content: Text(Get.context!.translate('showZkrProgressFoundForContinueDescription')),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: Text(Get.context!.translate('continuee')),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: Text(Get.context!.translate('startAgain')),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
