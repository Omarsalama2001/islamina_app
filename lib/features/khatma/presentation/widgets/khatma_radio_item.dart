import 'package:easy_radio/easy_radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class KhatmaRadioItem extends StatelessWidget {
  final String headerText;
  final String subText;
  final int radioValue;
  final int groupValue;
  final void Function(int?)? onChanged;
  final void Function()? onTap;

  const KhatmaRadioItem({super.key, required this.headerText, required this.subText, required this.radioValue, required this.onChanged, required this.onTap, required this.groupValue});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KhatmaCubit, KhatmaState>(
      builder: (context, state) {
        return InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              boxShadow:const [
                BoxShadow(color: Colors.grey, spreadRadius: 0.3
                , blurRadius: 3),
              ],
              borderRadius: BorderRadius.circular(10.sp),
              color: Colors.white,
            ),
            child: ListTile(
              leading: EasyRadio<int>(value: radioValue, groupValue: groupValue, onChanged: onChanged),
              title: Text(
                headerText,
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 17.sp, color: Colors.orangeAccent),
              ),
              subtitle: Text(subText,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  )),
            ),
          ),
        );
      },
    );
  }
}
