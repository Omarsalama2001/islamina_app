import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/controllers/e_tasbih_controller.dart';
import 'package:islamina_app/core/extensions/media_query_extension.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/features/sebha/widgets/drawer_item_widget.dart';
import 'package:islamina_app/features/sebha/widgets/modal_sheet_item_widget.dart';

import 'package:islamina_app/features/sebha/widgets/sebha_widget.dart';
import 'package:islamina_app/features/sebha/widgets/sebha_widget_counter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SebhaPage extends GetView<ElectronicTasbihController> {
  SebhaPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: GetBuilder<ElectronicTasbihController>(
          builder: (controller) => Column(children: [
            Container(
              height: 10.h,
              color: Get.theme.primaryColor,
              width: double.infinity,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Text(context.translate("tasbihList"), textAlign: TextAlign.center, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.tasbihData.length,
                  itemBuilder: (context, index) => DrawerItemWidget(
                        eTasbihModel: controller.tasbihData[index],
                        index: index,
                      )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(width: double.infinity, child: MainElevatedButton(onPressed: controller.addTasbih, text: context.translate("addNewTasbih"))),
            ),
          ]),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),

        automaticallyImplyLeading: false, // this will hide Drawer hamburger icon
        title: Text(
         context.translate("eTasbih"),
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<ElectronicTasbihController>(
        builder: (controller) => DefaultTabController(
          length: 2,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ButtonsTabBar(backgroundColor: context.theme.primaryColor, duration: 0, contentCenter: true, width: context.getWidth(divide: 0.4), labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.white), elevation: 5.sp, contentPadding: EdgeInsets.all(10.sp), unselectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.black), tabs: const [

            //     Tab(
            //       text: "السبحة",
            //     ),
            //       Tab(
            //       text: "العداد",
            //     ),
            //   ]),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Builder(builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.3,
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(Icons.menu)),
                  );
                }),
                ButtonsTabBar(backgroundColor: context.theme.primaryColor, duration: 0, contentCenter: true, width: context.getWidth(divide: 0.3), labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.white), elevation: 5.sp, contentPadding: EdgeInsets.all(10.sp), unselectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.black), tabs:  [
                  Tab(
                    text: context.translate("elsebha"),
                  ),
                  Tab(
                    text: context.translate("counter"),
                  ),
                ]),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0.3,
                        blurRadius: 3,
                      )
                    ],
                  ),
                  child: IconButton(
                      onPressed: () {
                        controller.onResetCounterPressed(eTasbihModel: controller.eTasbihModel);
                      },
                      icon: const Icon(Icons.restart_alt_outlined)),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Text(
                                 context.translate("tasbihDetails"),
                                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    ModalSheetItemWidget(
                                      title: context.translate('tasbihBeadsno'),
                                      number: controller.eTasbihModel.count,
                                    ),
                                    Gap(5.w),
                                    ModalSheetItemWidget(
                                      title: context.translate('noOfRounds'),
                                      number: controller.eTasbihModel.totalCounter.value ~/ controller.eTasbihModel.count,
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Row(
                                  children: [
                                    ModalSheetItemWidget(
                                      title: context.translate('roundTasbihs'),
                                      number: controller.eTasbihModel.counter.value,
                                    ),
                                    Gap(5.w),
                                    ModalSheetItemWidget(
                                      title: context.translate('totalTasbihs'),
                                      number: controller.eTasbihModel.totalCounter.value,
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                controller.eTasbihModel.isSystem == 1
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: MainElevatedButton(
                                                color: const WidgetStatePropertyAll<Color>(Colors.red),
                                                onPressed: () {
                                                  controller.deleteTasbih(controller.eTasbihModel.id!);
                                                },
                                                text: context.translate('deleteTasbih')),
                                          ),
                                          const Gap(5),
                                          Expanded(
                                            child: MainElevatedButton(
                                                color: const WidgetStatePropertyAll<Color>(Colors.orange),
                                                onPressed: () {
                                                  controller.editTasbih(controller.eTasbihModel);
                                                },
                                                text: context.translate('editTasbih')),
                                          ),
                                        ],
                                      )
                              ]),
                            ),
                          )
                          );
                },
                child: Container(
                  height: 20.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/back.jpg',
                          ),
                          fit: BoxFit.cover,
                          opacity: 0.3),
                      boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 0.3, blurRadius: 3)],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                        color: Colors.white,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                                            Text(
                                             context.translate("tasbihDetails"),
                                              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                                            ),
                                            const Divider(),
                                            Row(
                                              children: [
                                                ModalSheetItemWidget(
                                                  title: 'عدد حبات التسبيح',
                                                  number: controller.eTasbihModel.count,
                                                ),
                                                Gap(5.w),
                                                ModalSheetItemWidget(
                                                  title: 'عدد الدورات حتي الأن',
                                                  number: controller.eTasbihModel.totalCounter.value ~/ controller.eTasbihModel.count,
                                                ),
                                              ],
                                            ),
                                            const Gap(10),
                                            Row(
                                              children: [
                                                ModalSheetItemWidget(
                                                  title: 'تسبيحات الدورة الحالية',
                                                  number: controller.eTasbihModel.counter.value,
                                                ),
                                                Gap(5.w),
                                                ModalSheetItemWidget(
                                                  title: 'أجمالي التسبيحات',
                                                  number: controller.eTasbihModel.totalCounter.value,
                                                ),
                                              ],
                                            ),
                                            const Gap(10),
                                            controller.eTasbihModel.isSystem == 1
                                                ? const SizedBox()
                                                : Row(
                                                    children: [
                                                      Expanded(
                                                        child: MainElevatedButton(
                                                            color: const WidgetStatePropertyAll<Color>(Colors.red),
                                                            onPressed: () {
                                                              controller.deleteTasbih(controller.eTasbihModel.id!);
                                                            },
                                                            text: 'حذف التسبيح'),
                                                      ),
                                                      const Gap(5),
                                                      Expanded(
                                                        child: MainElevatedButton(
                                                            color: const WidgetStatePropertyAll<Color>(Colors.orange),
                                                            onPressed: () {
                                                              controller.editTasbih(controller.eTasbihModel);
                                                            },
                                                            text: 'تعديل التسبيح'),
                                                      ),
                                                    ],
                                                  )
                                          ]),
                                        ),
                                      ));
                            },
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              size: 3.h,
                            )),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: GetBuilder<ElectronicTasbihController>(
                              builder: (controller) => PageView.builder(
                                  controller: controller.pageController,
                                  itemCount: controller.tasbihData.length,
                                  onPageChanged: (value) {
                                    controller.changeETasbih(controller.tasbihData[value]);
                                  },
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                controller.tasbihData[index].name,
                                                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18.sp),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                controller.tasbihData[index].advantage,
                                                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Get.theme.primaryColor, fontSize: 16.sp),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: controller.pageController,
              count: controller.tasbihData.length,
              effect: ExpandingDotsEffect(
                dotColor: Colors.orange,
                dotHeight: 10.sp,
                dotWidth: 10.sp,
                activeDotColor: Colors.orangeAccent,
              ),
              onDotClicked: (index) {
                controller.changeETasbih(controller.tasbihData[index]);
                controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
              },
            ),

            const Spacer(),
            SizedBox(
              height: 50.h,
              child: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SebhaAnimation(),
                  SebhaWidgetCounter(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
