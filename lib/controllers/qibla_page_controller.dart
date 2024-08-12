import 'dart:math' show cos, sqrt, asin;
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/prayer_time_controller.dart';
import 'package:islamina_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class QiblaController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  late List<CameraDescription> cameras;

  Future<bool> getAvailableCameras() async {
    try {
      cameras = await availableCameras();
      return true;
    } catch (e) {
      cameras = [];
      return false;
    }
  }

  double distanceToKaaba = 0.0;

  Future<void> calculateDistance() async {
    PrayerTimeController controller = Get.find();
    double currentLatitude = controller.repository.coordinates!.latitude;
    double currentLongitude = controller.repository.coordinates!.longitude;

    // Coordinates of the Kaaba
    double kaabaLatitude = 21.4225;
    double kaabaLongitude = 39.8262;

    double distance = _calculateDistance(
        currentLatitude, currentLongitude, kaabaLatitude, kaabaLongitude);

    distanceToKaaba = distance;
    update();
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();
  Stream<LocationStatus> get stream => _locationStreamController.stream;

  final StreamController<Position> _positionStreamController =
      StreamController();
  Stream<Position> get locStream => _positionStreamController.stream;

  // Method to check and handle location status
  Future<void> checkLocationStatus() async {
    var status = await Utils.handleLocationStatus();
    _locationStreamController.sink.add(status);
    if (status.enabled &&
        (status.status == LocationPermission.always ||
            status.status == LocationPermission.whileInUse)) {
      getPosition();
      hasPermission = true;
      update();
    }
  }

  Animation<double>? animations;
  AnimationController? animationsController;
  double begin = 0.0;

  @override
  void onInit() async {
    super.onInit();
    getPermission();
    animationsController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animations = Tween(begin: 0.0, end: 0.0).animate(animationsController!);
    tabController = TabController(length: 2, vsync: this);
    // Check location status when the controller is initialized
    final initialStatus = await FlutterQiblah.checkLocationStatus();
    _locationStreamController.sink.add(initialStatus);
    if (initialStatus.enabled &&
        (initialStatus.status == LocationPermission.always ||
            initialStatus.status == LocationPermission.whileInUse)) {
      calculateDistance();
      getPosition();
    }
  }

  // Dispose of the stream controller when the controller is disposed
  @override
  void onClose() {
    _locationStreamController.close();
    _positionStreamController.close();
    super.onClose();
  }

  void getPosition() {
    _positionStreamController
        .addStream(Geolocator.getPositionStream().handleError((error) {}));
  }

  bool hasPermission = false;

  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        Permission.location.request().then((value) {
          hasPermission = (value == PermissionStatus.granted);
        });
      }
    }
    update();
  }
}
