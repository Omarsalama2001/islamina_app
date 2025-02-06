import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/features/auth/presentation/pages/login_page.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddKhatmaChips extends StatelessWidget {
  const AddKhatmaChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: context.theme.hoverColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Center(
          child: BlocBuilder<KhatmaCubit, KhatmaState>(
            builder: (context, state) {
              return Wrap(runSpacing: 8, spacing: 8, children: [
                _buildChipItem("Reading", context),
                _buildChipItem("Contemplation", context),
                _buildChipItem("save", context),
                _buildChipItem("RevisionofMemorization", context),
                _buildChipItem("Other", context),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

_buildChipItem(String label, BuildContext context) => ChoiceChip(
      label: Text(
        context.translate(label),
      ),
      labelStyle:  GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 17.sp, color:context.read<KhatmaCubit>().khatmaChipsValue == label? Colors.white :Colors.black),
     iconTheme: IconThemeData(
      color: context.theme.primaryColor
     ),
      elevation: 5,
      chipAnimationStyle: ChipAnimationStyle(
         selectAnimation: AnimationStyle(
           duration: const Duration(
            microseconds: 1
           )
         )
      ),

      selected: context.read<KhatmaCubit>().khatmaChipsValue == label,
      onSelected: (value) {
        context.read<KhatmaCubit>().changeKhatmaChipsValue(label);
      },
      disabledColor: context.theme.primaryColor,
      selectedColor: Colors.orangeAccent  ,
    );
