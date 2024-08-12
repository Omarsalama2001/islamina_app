import 'package:get/get.dart';
import 'package:islamina_app/data/repository/daily_content_repository.dart';

import '../data/models/daily_content_model.dart';

class MainController extends GetxController {
  DailyContentModel? dailyContent;

  @override
  void onReady() async {
    super.onReady();
    dailyContent = await DailyContentRepository().getDailyContent();
    update();
  }
}
