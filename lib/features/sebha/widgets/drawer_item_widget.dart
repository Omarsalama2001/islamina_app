import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/widgets/snack_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:islamina_app/controllers/e_tasbih_controller.dart';
import 'package:islamina_app/data/models/e_tasbih.dart';

class DrawerItemWidget extends GetView<ElectronicTasbihController> {
  final ElectronicTasbihModel eTasbihModel;
  final int index;
  const DrawerItemWidget({
    required this.eTasbihModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      
      key: UniqueKey(),
      background:  Container(
        color: eTasbihModel.isSystem==1? Colors.white: Colors.red,
        child:eTasbihModel.isSystem==1? null: const Icon(Icons.delete, color: Colors.white),),
      secondaryBackground: Container(
        color: eTasbihModel.isSystem==1? Colors.white: Colors.orange,
        child:  eTasbihModel.isSystem==1? null: const Icon(Icons.edit , color: Colors.white),),
      onDismissed: (direction) {
        if ( eTasbihModel.isSystem==1){
           Fluttertoast.showToast(msg: 'لا يمكنك حذف هذا التسبيح');
          return;
        }
      direction == DismissDirection.endToStart ? controller.editTasbih(eTasbihModel) :  controller.deleteTasbih(eTasbihModel.id!);
      },
      child: GestureDetector(
        onTap: () {
          
          controller.pageController.jumpToPage(index);
          Get.back();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 10.h,
            width: double.infinity,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        eTasbihModel.name,
                        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                       eTasbihModel.advantage,
                        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Get.theme.primaryColor),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
