import 'package:flutter/material.dart';
import 'package:islamina_app/core/utils/Localization/app_localization.dart';

extension TranslationExtension on BuildContext {
  String translate(String key) => AppLocalizations.of(this)!.translate(key)!;
}
