import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class GoogleSigninButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final String method;
  const GoogleSigninButton({
    super.key,
    required this.onPressed, required this.icon, required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1.0.h),
          border: Border.all(color: Colors.black, width: 0.2.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 10.w, height: 7.h),
          const  Gap(5),
            Text(
            context.translate('login_with'),
              style: GoogleFonts.tajawal(),
            ),
         const   Gap(5),
            Text(
              method,
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
