import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:islamina_app/data/models/asmaullah_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AsmaulahWidget extends StatelessWidget {
  final AsmaullahModel asmaullah;
  const AsmaulahWidget({
    Key? key,
    required this.asmaullah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                        child: Text(
                          asmaullah.id!.toString(),
                          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 17.sp, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Gap(2.h),
                    Row
                    (mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                      
                      Expanded(
                        child: Column(
                          
                          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            asmaullah.ttl!,
                            style: TextStyle(fontFamily: 'Uthmanic_Script', fontWeight: FontWeight.w400, fontSize: 30.sp, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          Gap(2.h),
                          Text(
                            asmaullah.dsc!,
                            style: GoogleFonts.tajawal(fontSize: 14.sp, color: Colors.grey),
                            textAlign: TextAlign.start,
                          ),
                        ]),
                      ),
                      Text(
                        asmaullah.fontCode!,
                        style: TextStyle(fontFamily: 'allah_names', fontSize: 40.sp),
                      )
                    ]),
                  ]),
                ),
              ),
            );
  }
}
