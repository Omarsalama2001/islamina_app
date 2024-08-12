import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/khatma_controller.dart';
import 'package:islamina_app/utils/extension.dart';

class AddKhatmaPage extends GetView<KhatmaController> {
  const AddKhatmaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.daysController.text = '';
          controller.handleTextExpectedPeriodOfKhatma = '';
          controller.update();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('إضافة ختمة'),
          titleTextStyle: context.theme.primaryTextTheme.titleMedium,
        ),
        body: const _BodyView(),
      ),
    );
  }
}

class _BodyView extends GetView<KhatmaController> {
  const _BodyView();

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [
      const _CalculateKhatma(),
      const _SetYourDailyReading(),
      const _AlarmKhatma(),
    ];

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: views.length,
            onPageChanged: (value) {
              controller.currentIndex = value;
              controller.update();
            },
            itemBuilder: (_, index) => views[index],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: controller.previousPage,
                      color: Colors.grey,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'السابق',
                        style: context.textTheme.titleMedium?.copyWith(
                          // color: context.theme.scaffoldBackgroundColor,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: GetBuilder<KhatmaController>(
                      builder: (_) {
                        return MaterialButton(
                          onPressed: controller.nextPage,
                          color: context.theme.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.currentIndex == views.length - 1
                                ? 'تم'
                                : 'التالي',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.theme.scaffoldBackgroundColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Gap(20),
              GetBuilder(
                init: KhatmaController(),
                builder: (controller) {
                  return DotsIndicator(
                    position: controller.currentIndex,
                    dotsCount: views.length,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalculateKhatma extends StatelessWidget {
  const _CalculateKhatma();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 4,
                color: Colors.orange,
              ),
              const Gap(10),
              Text(
                'إحسب ختمتك',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const Gap(5),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 0),
            child: Text(
              'إحسب ختمتك بإحدى الطريقتين',
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.theme.primaryColor,
                fontSize: 18,
              ),
            ),
          ),
          const Gap(30),
          GetBuilder(
              init: KhatmaController(),
              builder: (controller) {
                return SelectWayKhatma(
                  title: 'إحسب ختمتك',
                  subTitle: 'عن طريق تحديد عدد الأيام المتوقعة لإنهاء الختمة',
                  onTap: () {
                    controller.calculateByNoOfDay = true;
                    controller.calculateByReadingOfDay = false;
                    controller.daysController.text = '';
                    controller.selectedJuz = 1.getJuzName;
                    controller.handleTextExpectedPeriodOfKhatma = '';
                    controller.update();
                  },
                  isSelected: controller.calculateByNoOfDay,
                );
              }),
          const Gap(20),
          GetBuilder(
            init: KhatmaController(),
            builder: (controller) {
              return SelectWayKhatma(
                title: 'معدل الورد اليومي',
                subTitle: 'عن طريق الكم الذي تريد قراءته في كل مرة',
                onTap: () {
                  controller.calculateByNoOfDay = false;
                  controller.calculateByReadingOfDay = true;
                  controller.daysController.text = '';
                  controller.selectedJuz = 1.getJuzName;
                  controller.handleTextExpectedPeriodOfKhatma = '';
                  controller.update();
                },
                isSelected: controller.calculateByReadingOfDay,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SetYourDailyReading extends StatelessWidget {
  const _SetYourDailyReading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: GetBuilder(
            init: KhatmaController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'حدد قراءتك اليومية',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(20),
                  controller.calculateByNoOfDay
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'عدد الأيام',
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(10),
                            SizedBox(
                              // clipBehavior: Clip.antiAlias,
                              // decoration: BoxDecoration(
                              //   borderRadius: const BorderRadius.all(
                              //     Radius.circular(8),
                              //   ),
                              //   border: Border.all(
                              //     color: context.theme.primaryColor,
                              //   ),
                              // ),
                              height: 75,
                              child: TextField(
                                controller: controller.daysController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (controller
                                      .daysController.text.isNotEmpty) {
                                    controller.calculateExpectedPeriod();
                                    controller.update();
                                  } else {
                                    controller.daysController.text = value;
                                    controller.update();
                                  }
                                  // controller.calculateExpectedPeriod();
                                },
                                onTapOutside: (_) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                decoration: const InputDecoration(
                                  label: Text('عدد الأيام'),
                                  hintText: '10',
                                  border: OutlineInputBorder(),
                                  filled: false,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _SelectedCardItem(
                                title: 'الوحدة',
                                description: controller.selectedUnit,
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor:
                                          context.theme.scaffoldBackgroundColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      content: SizedBox(
                                        width: Get.width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: controller.units
                                              .asMap()
                                              .entries
                                              .map((e) {
                                            return InkWell(
                                              onTap: () {
                                                if (controller.selectedUnit !=
                                                    e.value) {
                                                  controller.selectedDestiny =
                                                      0;
                                                }
                                                controller.selectedUnit =
                                                    e.value;
                                                controller.unitIndex = e.key;
                                                controller
                                                    .calculateExpectedPeriod();
                                                controller.update();
                                                Get.back();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      e.value,
                                                      style: context
                                                          .textTheme.titleLarge,
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: controller
                                                                      .selectedUnit ==
                                                                  e.value
                                                              ? context.theme
                                                                  .primaryColor
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 6,
                                                        backgroundColor: controller
                                                                    .selectedUnit ==
                                                                e.value
                                                            ? context.theme
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Gap(30),
                            Expanded(
                              child: _SelectedCardItem(
                                title: 'القدر',
                                description:
                                    (controller.selectedDestiny + 1).toString(),
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor:
                                          context.theme.scaffoldBackgroundColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      content: SizedBox(
                                        width: Get.width,
                                        child: ListView.builder(
                                          itemCount: controller
                                              .listOfSelectedUnitIndex.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                controller.selectedDestiny =
                                                    index;
                                                controller
                                                    .calculateExpectedPeriod();
                                                controller.update();
                                                Get.back();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${index + 1}',
                                                      style: context
                                                          .textTheme.titleLarge,
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: controller.selectedDestiny ==
                                                                  controller
                                                                          .listOfSelectedUnitIndex[
                                                                      index]
                                                              ? context.theme
                                                                  .primaryColor
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 6,
                                                        backgroundColor: controller
                                                                    .selectedDestiny ==
                                                                controller
                                                                        .listOfSelectedUnitIndex[
                                                                    index]
                                                            ? context.theme
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // child: Column(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: controller.listOfSelectedUnitIndex
                                        //       .asMap()
                                        //       .entries
                                        //       .map((e) {
                                        //     return InkWell(
                                        //       onTap: () {},
                                        //       child: Padding(
                                        //         padding: const EdgeInsets.all(4),
                                        //         child: Row(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.spaceBetween,
                                        //           children: [
                                        //             Text(
                                        //               e.value.toString(),
                                        //               style: context
                                        //                   .textTheme.titleLarge,
                                        //             ),
                                        //             Container(
                                        //               padding:
                                        //                   const EdgeInsets.all(3),
                                        //               decoration: BoxDecoration(
                                        //                 shape: BoxShape.circle,
                                        //                 border: Border.all(
                                        //                   color: controller
                                        //                               .selectedUnit ==
                                        //                           e.value
                                        //                       ? context
                                        //                           .theme.primaryColor
                                        //                       : Colors.grey,
                                        //                 ),
                                        //               ),
                                        //               child: CircleAvatar(
                                        //                 radius: 6,
                                        //                 backgroundColor:
                                        //                     controller.selectedUnit ==
                                        //                             e.value
                                        //                         ? context.theme
                                        //                             .primaryColor
                                        //                         : Colors.transparent,
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     );
                                        //   }).toList(),
                                        // ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                  const Gap(20),
                  _SelectedCardItem(
                    title: 'من أي مكان في المصحف تريد بدء الختمة',
                    description: controller.selectedJuz,
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor:
                              context.theme.scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          content: SizedBox(
                            width: Get.width,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    controller.juz.asMap().entries.map((e) {
                                  return InkWell(
                                    onTap: () {
                                      controller.selectedJuz = e.value;
                                      controller.selectedJuzIndex = e.key;
                                      controller.calculateExpectedPeriod();
                                      controller.update();
                                      Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.value,
                                            style: context.textTheme.titleLarge,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: controller.selectedJuz ==
                                                        e.value
                                                    ? context.theme.primaryColor
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: controller
                                                          .selectedJuz ==
                                                      e.value
                                                  ? context.theme.primaryColor
                                                  : Colors.transparent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Gap(40),
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'المدة المتوقعة لإنهاء الختمة',
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        GetBuilder<KhatmaController>(
                          builder: (_) {
                            // String data = controller.daysController.text;
                            String data = '';
                            if (controller.calculateByNoOfDay) {
                              data = controller.daysController.text;
                            } else {
                              data =
                                  controller.expectedPeriodOfKhatma.toString();
                              // data =
                              //     '${controller.selectedDestiny + 1} ${controller.selectedUnit}';
                            }

                            return Text(
                              '${data.isEmpty ? '0' : data} يوم',
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            );
                          },
                        ),
                        const Gap(10),
                        Text(
                          'معدل وردك اليومي',
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        GetBuilder<KhatmaController>(
                          builder: (_) {
                            // String data =
                            //     controller.handleTextExpectedPeriodOfKhatma;
                            String data = '';
                            if (controller.calculateByNoOfDay) {
                              data =
                                  controller.handleTextExpectedPeriodOfKhatma;
                            } else {
                              data =
                                  '${controller.selectedDestiny + 1} ${controller.selectedUnit}';
                            }
                            return Text(
                              (controller.calculateByNoOfDay) &&
                                      (data.isEmpty ||
                                          controller
                                              .daysController.text.isEmpty)
                                  ? '0 صفحة'
                                  : data,
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class SelectWayKhatma extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function() onTap;
  final bool isSelected;
  const SelectWayKhatma({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: context.theme.primaryColor,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckWidget(isSelected: isSelected),
            const Gap(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.orange : null,
                  ),
                ),
                FittedBox(
                  child: Text(
                    subTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckWidget extends StatelessWidget {
  final bool isSelected;
  const CheckWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.grey,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: isSelected ? Colors.orange : Colors.grey,
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: context.theme.scaffoldBackgroundColor,
              )
            : const Icon(
                Icons.check,
                color: Colors.transparent,
              ),
      ),
    );
  }
}

class _SelectedCardItem extends StatelessWidget {
  final String title;
  final String description;
  final Function() onTap;
  const _SelectedCardItem({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsetsDirectional.only(start: 10),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: context.theme.primaryColor,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  description,
                  style: context.textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: context.theme.primaryColor,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: context.theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AlarmKhatma extends GetView<KhatmaController> {
  const _AlarmKhatma();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<KhatmaController>(
            builder: (controller) {
              return SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Row(
                  children: [
                    Container(
                      width: 15,
                      height: 4,
                      color: Colors.orange,
                    ),
                    const Gap(10),
                    Text(
                      'تفعيل التنبيه',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'حدد هل تريد أن ننبهك بوقت قراءة الورد',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.theme.primaryColor,
                    fontSize: 18,
                  ),
                ),
                value: controller.enableAlarm,
                isThreeLine: true,
                onChanged: (value) {
                  controller.enableAlarm = value;
                  controller.update();
                },
              );
            },
          ),
          GetBuilder<KhatmaController>(
            builder: (controller) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                dense: true,
                title: Text(
                  'اختر وقت التنبيه',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: !controller.enableAlarm ? Colors.grey : null,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    if (controller.enableAlarm) {
                      controller.selectTime(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller.enableAlarm
                          ? context.theme.primaryColor.withOpacity(0.2)
                          : context.theme.primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    child: Icon(
                      FluentIcons.add_28_regular,
                      color: !controller.enableAlarm ? Colors.grey : null,
                    ),
                  ),
                ),
              );
            },
          ),
          GetBuilder<KhatmaController>(
            builder: (controller) {
              return controller.selectedTextTime != null &&
                      controller.enableAlarm
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 8,
                        left: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.notifications_active,
                            color: Colors.orange,
                          ),
                          title: Text(
                            controller.selectedTextTime!,
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color:
                                  !controller.enableAlarm ? Colors.grey : null,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: controller.clearTime,
                            child: const Icon(
                              FluentIcons.delete_24_regular,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
