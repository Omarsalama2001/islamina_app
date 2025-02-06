import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/core/widgets/snack_bar.dart';
import 'package:islamina_app/features/khatma/data/models/khatma_model.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/pages/khatma_main_page.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_header.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

class AddKhatmaPageVeiwThirdItem2 extends StatefulWidget {
  const AddKhatmaPageVeiwThirdItem2({super.key});

  @override
  State<AddKhatmaPageVeiwThirdItem2> createState() => _AddKhatmaPageVeiwThirdItem2State();
}

class _AddKhatmaPageVeiwThirdItem2State extends State<AddKhatmaPageVeiwThirdItem2> {
  @override
  void initState() {
    super.initState();
    context.read<KhatmaCubit>().calculateExpectedPeriod();
  }

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    KhatmaCubit khatmaCubit = context.read<KhatmaCubit>();
    return BlocBuilder<KhatmaCubit, KhatmaState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: _SelectedCardItem(
                    title: context.translate('unit'),
                    description: khatmaCubit.selectedUnit,
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          content: SizedBox(
                            width: Get.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: khatmaCubit.units.asMap().entries.map((e) {
                                return InkWell(
                                  onTap: () {
                                    if (khatmaCubit.selectedUnit != e.value) {
                                      khatmaCubit.selectedDestiny = 0;
                                    }
                                    khatmaCubit.selectedUnit = e.value;
                                    khatmaCubit.unitIndex = e.key;
                                    khatmaCubit.calculateExpectedPeriod();
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          context.translate(e.value),
                                          style: GoogleFonts.amiri().copyWith(fontSize: 20.sp),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: khatmaCubit.selectedUnit == e.value ? context.theme.primaryColor : Colors.grey,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 6,
                                            backgroundColor: khatmaCubit.selectedUnit == e.value ? context.theme.primaryColor : Colors.transparent,
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
                    title: context.translate('destiny'),
                    description: (khatmaCubit.selectedDestiny + 1).toString(),
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          content: SizedBox(
                            width: Get.width,
                            child: ListView.builder(
                              itemCount: khatmaCubit.listOfSelectedUnitIndex.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    khatmaCubit.selectedDestiny = index;
                                    khatmaCubit.calculateExpectedPeriod();
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${index + 1}',
                                          style: context.textTheme.titleLarge,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: khatmaCubit.selectedDestiny == khatmaCubit.listOfSelectedUnitIndex[index] ? context.theme.primaryColor : Colors.grey,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 6,
                                            backgroundColor: khatmaCubit.selectedDestiny == khatmaCubit.listOfSelectedUnitIndex[index] ? context.theme.primaryColor : Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Gap(15),
            AddKhatmaHeader(withDash: false, title: context.translate("startKhatmaPositionHeader")),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    content: SizedBox(
                      width: Get.width,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: khatmaCubit.juz.asMap().entries.map((e) {
                            return InkWell(
                              onTap: () {
                                khatmaCubit.selectedJuz = e.value;
                                khatmaCubit.selectedJuzIndex = e.key;
                                khatmaCubit.calculateExpectedPeriod();
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.value,
                                      style: GoogleFonts.amiri().copyWith(fontSize: 17.sp),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: khatmaCubit.selectedJuz == e.value ? context.theme.primaryColor : Colors.grey,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 6,
                                        backgroundColor: khatmaCubit.selectedJuz == e.value ? context.theme.primaryColor : Colors.transparent,
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
              child: Container(
                padding: const EdgeInsetsDirectional.only(start: 10),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey,
                  //           spreadRadius: 0.4,
                  //           blurRadius: 4,
                  //           offset:  Offset(0, 2), // changes position of shadow
                  //         ),
                  //       ],
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      khatmaCubit.juz[khatmaCubit.selectedJuzIndex],
                      style: GoogleFonts.amiri().copyWith(fontSize: 20.sp),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: context.theme.primaryColor,
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: context.theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(40),
            BlocConsumer<KhatmaCubit, KhatmaState>(
              listener: (context, state) {
                // if (state is KhatmaAddLoadingState) {
                //   AlertDialog(
                //     content: LottieBuilder.asset('assets/animations/qurananimation.json'),
                //   );
                // }
                // if (state is KhatmaAddedSuccessState) {

                //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const KhatmaMainPage()));
                //   SnackBarMessage.showSnackBar(SnackBarTypes.SUCCESS, 'تمت أضافة الختمة', context);
                //   context.read<KhatmaCubit>().restartPageView();
                // }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.4,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.translate("expected_duration"),
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400, color: context.theme.primaryColor),
                          ),
                          const Gap(10),
                          const Gap(10),
                          Text('${khatmaCubit.expectedPeriodOfKhatma} ${Get.context!.translate("day")}'),
                          const Gap(10),
                          Text(
                            context.translate("daily_rate"),
                            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400, color: context.theme.primaryColor),
                          ),
                          const Gap(10),
                          Text('${khatmaCubit.selectedDestiny + 1} ${Get.context!.translate(khatmaCubit.selectedUnit)}'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: MainElevatedButton(
                        color: const WidgetStatePropertyAll(Colors.grey),
                        onPressed: () {
                          context.read<KhatmaCubit>().changeAddKhatmaPage(false);
                        },
                        text: context.translate("previous")),
                  ),
                ),
                const Gap(5),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: MainElevatedButton(
                        onPressed: () {
                          context.read<KhatmaCubit>().changeAddKhatmaPage(true);
                          // KhatmaModel khatmaModel = KhatmaModel(
                          //   id: uuid.v1(),
                          //   createdAt: DateTime.now(),
                          //   description: khatmaCubit.khatmaDescriptionController.text,
                          //   khatmaType: khatmaCubit.khatmaChipsValue,
                          //   moshafType: khatmaCubit.khatamaRadioValue == 0 ? true : false,
                          //   name: khatmaCubit.khatmaNameController.text,
                          //   expectedPeriodOfKhatma: khatmaCubit.expectedPeriodOfKhatma,
                          //   unit: khatmaCubit.selectedUnit,
                          //   valueOfUnit: khatmaCubit.valueOfUnit,
                          //   unitPerDay: khatmaCubit.selectedDestiny + 1,
                          //   initialPage: khatmaCubit.initialPage,
                          //   lastPage: khatmaCubit.lastPage,
                          //   lastModified: DateTime.now(),
                          //   isTaped: false,
                          // );
                          // khatmaCubit.saveKhatma(khatmaModel);
                        },
                        text: context.translate("next")),
                  ),
                ),
              ],
            )
          ]),
        );
      },
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
        Text(title, style: GoogleFonts.amiri().copyWith(fontSize: 20.sp, color: context.theme.primaryColor, fontWeight: FontWeight.w500)),
        const Gap(10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsetsDirectional.only(start: 10),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              // boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey,
              //           spreadRadius: 0.4,
              //           blurRadius: 4,
              //           offset:  Offset(0, 2), // changes position of shadow
              //         ),
              //       ],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.translate(description),
                    style: GoogleFonts.amiri().copyWith(fontSize: 20.sp),
                  ),
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
