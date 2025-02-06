import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/e_tasbih_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SebhaWidgetCounter extends StatelessWidget {
  const SebhaWidgetCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ElectronicTasbihController>(
      builder: (controller) => GestureDetector(
        onTap: () {
          controller.counterIncrement(eTasbihModel: controller.eTasbihModel);
        },
        child: Center(
          child: CircularPercentIndicator(
            radius: 17.h,
            rotateLinearGradient: true,
            lineWidth: 20,
            circularStrokeCap:  CircularStrokeCap.round,
             animateFromLastPercent: true,
             animationDuration: 0,
            percent: controller.eTasbihModel.counter.value / controller.eTasbihModel.count,
            linearGradient:    LinearGradient(colors: [Get.theme.primaryColorLight,Colors.orange.shade600,], begin: Alignment.topLeft, end: Alignment.bottomRight),
            center: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/mandala.png'), fit: BoxFit.contain)),
               child:  Center(child: Text("${controller.eTasbihModel.totalCounter}", style:  TextStyle(color: Get.theme.primaryColor, fontSize: 25.sp, fontWeight: FontWeight.bold))),
            ),
          ),
        ),
      ),
    );
  }
}
