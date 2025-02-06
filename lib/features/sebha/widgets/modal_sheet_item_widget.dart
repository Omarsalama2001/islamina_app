import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:islamina_app/controllers/e_tasbih_controller.dart';

class ModalSheetItemWidget extends GetView<ElectronicTasbihController> {
  final String title;
  final int number;
  const ModalSheetItemWidget({
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.jpg',
                ),
                fit: BoxFit.cover,
                opacity: 0.5),
            boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 0.3, blurRadius: 3)],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                title,
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Get.theme.primaryColor,),
                textAlign: TextAlign.center,
              ),
              Text(
               number.toString(),
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
