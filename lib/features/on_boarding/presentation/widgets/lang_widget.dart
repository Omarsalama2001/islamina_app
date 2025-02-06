import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';

class LangWidget extends StatelessWidget {
  const LangWidget({
    Key? key,
    required this.langCode,
    required this.langName,
    required this.countryCode,
  }) : super(key: key);
  final String langCode;
  final String langName;
  final String countryCode;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(5.0.w),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                border: BlocProvider.of<ThemeCubit>(context).locale.languageCode == langCode ? Border.all(color: Get.theme.primaryColor) : null,
                borderRadius: BorderRadius.all(Radius.circular(1.h)),
                color: Color.fromARGB(255, 205, 206, 207),
              ),
              child: ListTile(
                // leading: Icon(icon),
                title: Text(langName),

                subtitle: Text(langCode),
                trailing: CountryFlag.fromCountryCode(
                  countryCode,
                  shape: const RoundedRectangle(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
