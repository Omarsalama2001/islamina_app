import 'package:flutter/material.dart';
import 'package:islamina_app/core/utils/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor:  Colors.white,
  textTheme: TextTheme(
      headlineMedium: TextStyle(
    color: Colors.black,
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
  )),
  brightness: Brightness.light,
  primaryColor: AppColors.primaryColor,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primaryColor,
    selectionColor: AppColors.primaryColor,
    selectionHandleColor: AppColors.primaryColor,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.8,
      iconTheme: IconThemeData(
        color: Colors.white,
      )),
  colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor)),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.white,
  ),
);
