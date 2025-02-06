import 'package:flutter/widgets.dart';

extension MediaQueryExtension on BuildContext {
  double getHight({required double divide}) {
    return MediaQuery.of(this).size.height * divide;
  }

  double getWidth({required double divide}) {
    return MediaQuery.of(this).size.width * divide;
  }
  double getDefaultSize() {
    return getOrientation() == Orientation.landscape ? MediaQuery.of(this).size.height * .024 : MediaQuery.of(this).size.width * .024;
  }
    Orientation getOrientation() {
    return MediaQuery.of(this).orientation;
  }
}
