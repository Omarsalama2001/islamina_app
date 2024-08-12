import 'package:get/get.dart';
import 'package:islamina_app/data/models/azkar_category_mode.dart';
import 'package:islamina_app/data/repository/azkar_repository.dart';

class AzkarCategoriesController extends GetxController {
  late Future<List<AzkarCategoryModel>> futureAzkarCategories;
  late final AzkarRepository azkarRepository;

  List<String> azkarPathIcons = [
    'assets/images/athkar_muslim/sun.png',
    'assets/images/athkar_muslim/night.png',
    'assets/images/athkar_muslim/pray.png',
    'assets/images/athkar_muslim/dua.png',
    'assets/images/athkar_muslim/man.png',
    'assets/images/athkar_muslim/sleeping.png',
    'assets/images/athkar_muslim/get-up.png',
    'assets/images/athkar_muslim/the-prophets-mosque.png',
    'assets/images/athkar_muslim/wudhu.png',
    'assets/images/athkar_muslim/solar-house.png',
    'assets/images/athkar_muslim/eid.png',
    'assets/images/athkar_muslim/public-toilet.png',
    'assets/images/athkar_muslim/travel.png',
  ];

  @override
  void onInit() async {
    super.onInit();
    azkarRepository = AzkarRepository();
    futureAzkarCategories = azkarRepository.getAzkarCategories();
  }
}
