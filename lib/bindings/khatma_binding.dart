import 'package:get/get.dart';
import 'package:islamina_app/controllers/khatma_controller.dart';

class KhatmaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KhatmaController>(
      () => KhatmaController(),
    );
  }
}
