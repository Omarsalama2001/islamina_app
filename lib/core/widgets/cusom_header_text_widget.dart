import 'package:flutter/material.dart';

class CustomHeaderTextWidget extends StatelessWidget {
  const CustomHeaderTextWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.fontSize,
  }) : super(key: key);
  final String text;
  final Color color;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
