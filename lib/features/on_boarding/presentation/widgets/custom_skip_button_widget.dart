import 'package:flutter/material.dart';
import 'package:islamina_app/core/utils/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class CustomSkipButtonWidget extends StatelessWidget {
  const CustomSkipButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, color: AppColors.primaryColor),
      ),
    );
  }
}
