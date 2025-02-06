import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';

class CustomPopupMenuItem {
  static PopupMenuEntry<dynamic> build(
      {required dynamic index,
      required IconData iconData,
      required String text}) {
    return PopupMenuItem(
      value: index,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        minVerticalPadding: 0,
        dense: true,
        visualDensity: VisualDensity.compact,
        titleAlignment: ListTileTitleAlignment.center,
        leading: Icon(
          iconData,
        ),
        title: Text(
          Get.context!.translate(text),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
