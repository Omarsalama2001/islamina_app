import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/core/widgets/snack_bar.dart';
import 'package:islamina_app/features/khatma/data/models/khatma_model.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/pages/khatma_main_page.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_header_with_subtitle.dart';
import 'package:islamina_app/handlers/notification_alarm_handler.dart';
import 'package:islamina_app/services/notification_service.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/utils.dart';

class KhatmaAlarmaPagviewWidget extends StatefulWidget {
  const KhatmaAlarmaPagviewWidget({super.key});

  @override
  State<KhatmaAlarmaPagviewWidget> createState() => _KhatmaAlarmaPagviewWidgetState();
}

class _KhatmaAlarmaPagviewWidgetState extends State<KhatmaAlarmaPagviewWidget> {
  bool khatmaAlarm = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    KhatmaCubit khatmaCubit = context.read<KhatmaCubit>();
    return BlocListener<KhatmaCubit, KhatmaState>(
      listener: (context, state) {
        if (state is KhatmaAddLoadingState) {
          AlertDialog(
            content: LottieBuilder.asset('assets/animations/qurananimation.json'),
          );
        }
        if (state is KhatmaAddedSuccessState) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const KhatmaMainPage()), (Route<dynamic> route) => false);
          SnackBarMessage.showSnackBar(SnackBarTypes.SUCCESS,context.translate("khatma_added"), context);
          context.read<KhatmaCubit>().restartPageView();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                 Expanded(
                    child: AddKhatmaHeaderWithSubtitle(
                  title: context.translate("khatma_alarm"),
                  subtitle: context.translate("set_alarm_description")
                )),
                Switch(
                    value: khatmaAlarm,
                    onChanged: (value) {
                      setState(() {
                        khatmaAlarm = value;
                      });
                      if (value) {
                        showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          initialEntryMode: TimePickerEntryMode.dial,
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedTime = value;
                            });
                          } else {
                            setState(() {
                              selectedTime = TimeOfDay.now();
                              khatmaAlarm = false;
                            });
                          }
                        });
                      }
                    }),
              ],
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
                          context.read<KhatmaCubit>().changeAddKhatmaPage(false);
                          KhatmaModel khatmaModel = khatmaCubit.khatmaWayRadioValue == 0
                              ? KhatmaModel(
                                  id: uuid.v1(),
                                  createdAt: DateTime.now(),
                                  description: khatmaCubit.khatmaDescriptionController.text,
                                  khatmaType: khatmaCubit.khatmaChipsValue,
                                  moshafType: khatmaCubit.khatamaRadioValue == 0 ? true : false,
                                  name: khatmaCubit.khatmaNameController.text,
                                  expectedPeriodOfKhatma: int.parse(khatmaCubit.daysController.text),
                                  unit: 'page',
                                  valueOfUnit: 604,
                                  unitPerDay: khatmaCubit.expectedPeriodOfKhatma,
                                  initialPage: khatmaCubit.initialPage,
                                  lastPage: khatmaCubit.lastPage,
                                  lastModified: DateTime.now().copyWith(day: DateTime.now().day + -1),
                                  isTaped: false,
                                )
                              : KhatmaModel(
                                  id: uuid.v1(),
                                  createdAt: DateTime.now(),
                                  description: khatmaCubit.khatmaDescriptionController.text,
                                  khatmaType: khatmaCubit.khatmaChipsValue,
                                  moshafType: khatmaCubit.khatamaRadioValue == 0 ? true : false,
                                  name: khatmaCubit.khatmaNameController.text,
                                  expectedPeriodOfKhatma: khatmaCubit.expectedPeriodOfKhatma,
                                  unit: khatmaCubit.selectedUnit,
                                  valueOfUnit: khatmaCubit.valueOfUnit,
                                  unitPerDay: khatmaCubit.selectedDestiny + 1,
                                  initialPage: khatmaCubit.initialPage,
                                  lastPage: khatmaCubit.lastPage,
                                  lastModified: DateTime.now().copyWith(day: DateTime.now().day + -1),
                                  isTaped: false,
                                );
                          khatmaCubit.saveKhatma(khatmaModel);
                          if (khatmaAlarm) {
                            DateTime alarmTime = Utils.scheduleDateTime(selectedTime);
                            Get.find<NotificationService>().scheduleDailyNotification(
                              alarmTime,
                              'موعد ختمة (${khatmaCubit.khatmaNameController.text})',
                              khatmaModel.description,
                              Random().nextInt(2000000),
                              'khatma',
                            );
                          }
                        },
                        text: context.translate("done")), 
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
