import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:islamina_app/core/extensions/media_query_extension.dart';
import 'package:islamina_app/core/utils/app_colors.dart';

class MainButtonWidget extends StatelessWidget {
  const MainButtonWidget({Key? key, required this.text, required this.onPressed, required, required this.width, required this.hight}) : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double hight;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: hight,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Get.theme.primaryColor),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: context.getDefaultSize() * 1.8, color: Colors.white),
          )),
    );
  }
}
