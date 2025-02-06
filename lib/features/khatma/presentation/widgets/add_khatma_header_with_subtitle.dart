import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddKhatmaHeaderWithSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const AddKhatmaHeaderWithSubtitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 0,
      leading: Text('-', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 30.sp, color: Colors.orangeAccent)),
      title: Text(
        title,  
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 17.sp, color: context.theme.primaryColor),
      ),
      subtitle: Text(
        subtitle,
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          )),
    );
  }
}
