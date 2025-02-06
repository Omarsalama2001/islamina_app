import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/data/models/quran_navigation_data_model.dart';
import 'package:islamina_app/routes/app_pages.dart';
import 'package:islamina_app/services/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/features/khatma/data/models/khatma_model.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';

class KhatmaItem extends StatefulWidget {
  final KhatmaModel khatmaModel;
  const KhatmaItem({
    super.key,
    required this.khatmaModel,
  });

  @override
  State<KhatmaItem> createState() => _KhatmaItemState();
}

class _KhatmaItemState extends State<KhatmaItem> {
  @override
  void initState() {
    super.initState();
    // Get.put(QuranReadingController());
  }

  List<String> khatmaImages = [
    "assets/images/khatma_1.jpg",
    "assets/images/khatma_2.jpg",
    "assets/images/khatma_3.jpg",
    "assets/images/khatma_4.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    KhatmaCubit khatmaCubit = context.read<KhatmaCubit>();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.sp),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 7),
            ],
            // border: Border.all(
            //   color: const Color(0xffb8e2ce),
            //   width: 4.sp,
            // )
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CircularPercentIndicator(
                          header: Text('% ${calculatePercent(widget.khatmaModel)}', style: GoogleFonts.tajawal().copyWith(fontSize: 17.sp)),
                          center: Container(
                            height: 35.sp,
                            width: 35.sp,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(27.sp),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    getKhatmaImage(widget.khatmaModel.khatmaType).toLowerCase(),
                                  ),
                                )),
                          ),
                          radius: 27.sp,
                          animation: true,
                          progressColor: context.theme.primaryColor,
                          percent: (widget.khatmaModel.initialPage > widget.khatmaModel.valueOfUnit ? widget.khatmaModel.valueOfUnit : widget.khatmaModel.initialPage) / widget.khatmaModel.valueOfUnit,
                          animateFromLastPercent: true,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.sp),
                            boxShadow: [
                              BoxShadow(color: context.theme.primaryColorLight.withOpacity(0.5), spreadRadius: 1, blurRadius: 10),
                            ],
                            color: const Color(0xffb8e2ce),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                        context.translate(widget.khatmaModel.khatmaType),
                              style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: context.theme.primaryColor, fontSize: 17.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.khatmaModel.name,
                            style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: context.theme.primaryColor, fontSize: 15.sp),
                          ),
                          Text(
                            '${context.translate("khamta_ends_after")} ${calculateExpirationTimeOfKhatma(widget.khatmaModel.createdAt, widget.khatmaModel.expectedPeriodOfKhatma)}${context.translate("day")} - ${widget.khatmaModel.unitPerDay} ${context.translate(widget.khatmaModel.unit)} ${context.translate("daily")}',
                            style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: context.theme.primaryColor, fontSize: 15.sp),
                          ),
                          //   Text(
                          //   calculateKhatmeProgress(widget.khatmaModel),
                          //   style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: context.theme.primaryColor, fontSize: 15.sp),
                          // ),
                          Text(
                            widget.khatmaModel.moshafType ? context.translate("app'sMoshaf") : context.translate("ownMoshaf"),
                            style: GoogleFonts.tajawal(fontWeight: FontWeight.w700).copyWith(color: Colors.orange, fontSize: 15.sp),
                          ),
                          Gap(15.sp),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: const Color(0xffb8e2ce),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                getInitialKhatmaVerse(widget.khatmaModel.initialPage > widget.khatmaModel.valueOfUnit ? widget.khatmaModel.valueOfUnit : widget.khatmaModel.initialPage, widget.khatmaModel.unit),
                                style: GoogleFonts.tajawal(fontWeight: FontWeight.w300).copyWith(color: context.theme.primaryColor, fontSize: 16.sp),
                              ),
                            ),
                          ),
                          Gap(12.sp),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: const Color(0xffb8e2ce),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                getLastKhatmaVerse(widget.khatmaModel.lastPage > widget.khatmaModel.valueOfUnit ? widget.khatmaModel.valueOfUnit : widget.khatmaModel.lastPage, widget.khatmaModel.unit),
                                style: GoogleFonts.tajawal(fontWeight: FontWeight.w300).copyWith(color: context.theme.primaryColor, fontSize: 16.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Gap(12.sp),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        height: 5.h,
                        child: MainElevatedButton(
                          color: const WidgetStatePropertyAll(Colors.orange),
                          onPressed: () {
                            final page = mapInitialPositionToPage(widget.khatmaModel.unit, widget.khatmaModel.initialPage);
                            Get.toNamed(
                              Routes.QURAN_READING_PAGE,
                              arguments: QuranNavigationArgumentModel(
                                isKhatma: true,
                                khatmaModel: widget.khatmaModel,
                                surahNumber: 0,
                                pageNumber: page!.pageNumber,
                                verseNumber: 0,
                                highlightVerse: false,
                              ),
                            );
                          },
                          text: context.translate('read_werd'),
                        ),
                      ),
                    ),
                    Gap(10.sp),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        height: 5.h,
                        child: MainElevatedButton(
                          color: getDoneButtonActivationTime(widget.khatmaModel.lastModified, widget.khatmaModel.isTaped) ? WidgetStatePropertyAll(context.theme.primaryColor) : WidgetStatePropertyAll(context.theme.primaryColorLight),
                          onPressed: () {
                            if (getDoneButtonActivationTime(widget.khatmaModel.lastModified, widget.khatmaModel.isTaped)) {
                              KhatmaModel updatedkhatmaModel = KhatmaModel(
                                id: widget.khatmaModel.id,
                                name: widget.khatmaModel.name,
                                description: widget.khatmaModel.description,
                                createdAt: widget.khatmaModel.createdAt,
                                lastModified: widget.khatmaModel.lastModified.add(const Duration(days: 1)),
                                moshafType: widget.khatmaModel.moshafType,
                                expectedPeriodOfKhatma: widget.khatmaModel.expectedPeriodOfKhatma,
                                unitPerDay: widget.khatmaModel.unitPerDay,
                                unit: widget.khatmaModel.unit,
                                valueOfUnit: widget.khatmaModel.valueOfUnit,
                                khatmaType: widget.khatmaModel.khatmaType,
                                initialPage: widget.khatmaModel.initialPage + widget.khatmaModel.unitPerDay,
                                lastPage: widget.khatmaModel.lastPage + widget.khatmaModel.unitPerDay,
                                isTaped: true,
                              );
                              khatmaCubit.updateKhatma(updatedkhatmaModel);
                            } else {
                              Fluttertoast.showToast(msg: context.translate("can_complete_after_24_hours"), backgroundColor: Colors.white, gravity: ToastGravity.BOTTOM, textColor: Colors.black, fontSize: 16);
                            }
                          },
                          text: context.translate("werd_done"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
