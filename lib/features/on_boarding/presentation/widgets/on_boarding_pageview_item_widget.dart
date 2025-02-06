import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/features/on_boarding/presentation/widgets/lang_widget.dart';

import 'package:islamina_app/widgets/language_dialog_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnBoardingPageViewItemWidgetLanguage extends StatelessWidget {
  const OnBoardingPageViewItemWidgetLanguage({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String image;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          context.translate("lang"),
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      GestureDetector(
        onTap: () {
          BlocProvider.of<ThemeCubit>(context).changeLocale(const Locale('ar'));
        },
        child: LangWidget(
          langCode: 'ar',
          countryCode: 'SA',
          langName: 'العربية',
        ),
      ),
      GestureDetector(
        onTap: () {
          BlocProvider.of<ThemeCubit>(context).changeLocale(const Locale('en'));
        },
        child: LangWidget(
          langCode: 'en',
          countryCode: 'GB',
          langName: 'English',
        ),
      )
    ]);
  }
}
