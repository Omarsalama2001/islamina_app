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
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_page_veiw_sec_item_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AddKhatmaPageViewFourthItemWidget extends StatelessWidget {
  AddKhatmaPageViewFourthItemWidget({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // FocusNode _focusNode = FocusNode();
    var uuid = Uuid();
    KhatmaCubit khatmaCubit = context.read<KhatmaCubit>();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AddKhatmaHeader(withDash: false, title: context.translate('addKhatmaDurationHeader')),
            const Gap(15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: DefultTextFeild(
                    keyboardType: TextInputType.number,
                    hintText: context.translate('durationHintText'),
                    isMultiline: false,
                    controller: khatmaCubit.daysController,
                    onChanged: (p0) {
                      khatmaCubit.calculateExpectedPeriod();
                    },
                    validator: (p0) {
                      return validateDuration(p0);
                    }),
              ),
            ),
            const Gap(15),
            AddKhatmaHeader(withDash: false, title: context.translate('startKhatmaPositionHeader')),
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
                child: BlocBuilder<KhatmaCubit, KhatmaState>(
                  builder: (context, state) {
                    return Row(
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
                    );
                  },
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
                //   Navigator.push(context, MaterialPageRoute(builder: (_) => const KhatmaMainPage()));
                //   SnackBarMessage.showSnackBar(SnackBarTypes.SUCCESS, 'تمت أضافة الختمة', context);
                //   // context.read<KhatmaCubit>().restartPageView();
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
                            Get.context!.translate("expected_duration"),
                            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400, color: context.theme.primaryColor),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(10),
                          Text('${khatmaCubit.daysController.text} ${Get.context!.translate("day")}'),
                          const Gap(10),
                          Text(
                            Get.context!.translate("daily_rate"),
                            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400, color: context.theme.primaryColor),
                          ),
                          const Gap(10),
                          Text(khatmaCubit.handleTextExpectedPeriodOfKhatma),
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
                        text: context.translate('previous')),
                  ),
                ),
                const Gap(5),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: MainElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<KhatmaCubit>().changeAddKhatmaPage(true);
                            // KhatmaModel khatmaModel = KhatmaModel(
                            //   id: uuid.v1(),
                            //   createdAt: DateTime.now(),
                            //   description: khatmaCubit.khatmaDescriptionController.text,
                            //   khatmaType: khatmaCubit.khatmaChipsValue,
                            //   moshafType: khatmaCubit.khatamaRadioValue == 0 ? true : false,
                            //   name: khatmaCubit.khatmaNameController.text,
                            //   expectedPeriodOfKhatma: int.parse(khatmaCubit.daysController.text),
                            //   unit: 'صفحة',
                            //   valueOfUnit: 604,
                            //   unitPerDay: khatmaCubit.expectedPeriodOfKhatma,
                            //   initialPage: khatmaCubit.initialPage,
                            //   lastPage: khatmaCubit.lastPage,
                            //   lastModified: DateTime.now().copyWith(day: DateTime.now().day + -1),
                            //   isTaped: false,
                            // );
                            // khatmaCubit.saveKhatma(khatmaModel);
                          }
                        },
                        text: context.translate('next')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String? validateDuration(String? duration) {
    if (duration == null || duration.isEmpty) {
      return Get.context!.translate("enter_duration");
    }

    // Try to parse the input as an integer
    int? parsedDuration;
    try {
      parsedDuration = int.parse(duration);
    } catch (e) {
      return Get.context!.translate("duration_must_be_integer");
    }

    if (parsedDuration < 1) {
      return Get.context!.translate("duration_not_less_than_one");
    } else if (parsedDuration > 604) {
      return Get.context!.translate("duration_not_more_than_604");
    }

    return null; // Valid input
  }
}
