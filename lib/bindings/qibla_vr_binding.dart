import 'package:get/get.dart';

import '../controllers/qibla_vr_controller.dart';

class QiblaVrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QiblaVrController>(
      () => QiblaVrController(),
    );
  }
}
