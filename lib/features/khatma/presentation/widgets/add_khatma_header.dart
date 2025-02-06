import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddKhatmaHeader extends StatelessWidget {
  final String title;
  final bool withDash;
  const AddKhatmaHeader({super.key, required this.title, required this.withDash});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 0,
      leading: withDash ? Text('-', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 28.sp, color: Colors.orangeAccent)): null,
      title: Text(
        title,
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 17.sp, color: context.theme.primaryColor),
      ),
    );
  }
}
