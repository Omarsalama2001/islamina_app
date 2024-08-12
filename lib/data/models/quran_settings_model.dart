class QuranSettingsModel {
  bool isMarkerColored;
  double displayFontSize;
  bool isAdaptiveView;
  bool wordByWordListen;
  bool isDisplayTwoPage;
  QuranSettingsModel({
    this.isMarkerColored = true,
    this.displayFontSize = 25.0,
    this.isAdaptiveView = false,
    this.wordByWordListen = true,
    this.isDisplayTwoPage = false,
  });
}
