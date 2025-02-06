import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/media_query_extension.dart';

import 'package:responsive_sizer/responsive_sizer.dart';


// ignore: must_be_immutable
class MainElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
final   WidgetStatePropertyAll<Color?>? color;
  const MainElevatedButton({super.key, required this.onPressed, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     
      height: context.getHight(divide: 0.07),
      child: ElevatedButton(
        style: ButtonStyle(
          shape:   WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0.h))), 
          backgroundColor: color == null ?  WidgetStatePropertyAll(context.theme.primaryColor) : color!,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
