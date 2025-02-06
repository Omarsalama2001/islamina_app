import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/data/models/azkar_category_mode.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:islamina_app/constants/enum.dart';
import 'package:islamina_app/data/repository/azkar_repository.dart';
import 'package:islamina_app/routes/app_pages.dart';

import '../controllers/azkar_categories_controller.dart';
import '../widgets/custom_container.dart';

class AzkarCategoriesPage extends GetView<AzkarCategoriesController> {
  const AzkarCategoriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:  Text(context.translate('azkarCategories')),
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
      ),
      body: GetBuilder<AzkarCategoriesController>(builder: (context) {
        return FutureBuilder(
          future: AzkarRepository().getAzkarCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<AzkarCategoryModel>? data =
                  snapshot.data?.where((element) => element.id != 13).toList();
              return GridView.builder(
                itemCount: data!.length,
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 75.h > 100.w ? 80.w / 2 : 80.h / 6,
                  mainAxisSpacing: 8,
                  // childAspectRatio: 16 / 12,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  var category = data[index];
                  return CustomContainer(
                    useMaterial: true,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(9),
                      onTap: () {
                        Get.toNamed(Routes.AZKAR_DETAILS, arguments: {
                          'pageTitle': category.title,
                          'categoryId': category.id,
                          'type': AzkarPageType.azkar,
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              controller.azkarPathIcons[index],
                              width: 35,
                            ),
                            const Gap(10),
                            FittedBox(
                              child: Text(
                               context.translate(category.title),
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        );
      }),
    );
  }
}
