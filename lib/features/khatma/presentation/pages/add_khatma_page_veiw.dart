import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/bindings/azkar_categories_binding.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/pages/khatma_main_page.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_chips.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_page_veiw_first_item_widget.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_page_veiw_sec_item_widget.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_page_veiw_third_item2.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_page_view_fourth_item_widget.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_page_view_third_item_widget.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/khatma_alarma_pagview_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddKhatmaPage extends StatelessWidget {
  const AddKhatmaPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<KhatmaCubit>().resetKhatmaComponents();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.info,
                  text: context.translate('alert_text'),
                  cancelBtnText: context.translate('cancel_btn'),
                  confirmBtnText: context.translate('confirm_btn'),
                  title: context.translate('alert_title'),
                  confirmBtnColor: context.theme.primaryColor.withOpacity(0.8),
                  onCancelBtnTap: () {
                    Get.back();
                  },
                  onConfirmBtnTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KhatmaMainPage(),
                        ),
                        (Route<dynamic> route) => false);
                  },
                  showCancelBtn: true,
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          centerTitle: true,
          title: Text(
            context.translate("addKhatma"),
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<KhatmaCubit, KhatmaState>(
          buildWhen: (previous, current) => current is PageViewChanged,
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: context.read<KhatmaCubit>().khatmaPageViewController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                       AddKhatmaPageViewFirstItemWidget(),
                      AddKhatmaPageVeiwSecItemWidget(),
                       AddKhatmaPageViewThirdItemWidget(),
                      context.read<KhatmaCubit>().khatmaWayRadioValue == 0 ? AddKhatmaPageViewFourthItemWidget() : const AddKhatmaPageVeiwThirdItem2(),
                    const KhatmaAlarmaPagviewWidget(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                      controller: context.read<KhatmaCubit>().khatmaPageViewController, // PageController
                      count: 5,
                      effect: const ExpandingDotsEffect(dotColor: Colors.grey, activeDotColor: Colors.orangeAccent, offset: 5), // your preferred effect
                      onDotClicked: (index) {}),
                )
              ],
            );
          },
        ));
  }
}
