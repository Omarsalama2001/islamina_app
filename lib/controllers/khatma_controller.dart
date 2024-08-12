import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:islamina_app/utils/extension.dart';

class KhatmaController extends GetxController {
  List khatmas = [''];

  late PageController pageController;

  void nextPage() {
    if (currentIndex != 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
      currentIndex++;
      update();
    }
  }

  void previousPage() {
    if (currentIndex != 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
      currentIndex--;
      update();
    }
  }

  int currentIndex = 0;

  final daysController = TextEditingController();
  bool calculateByNoOfDay = true;
  bool calculateByReadingOfDay = false;

  int unitIndex = 0;
  String selectedUnit = 'جزء';
  List<String> units = ['جزء', 'حزب', 'ربع حزب', 'سورة', 'صفحة'];

  String selectedJuz = 1.getJuzName;
  int selectedJuzIndex = 0;
  List<String> juz = List.generate(30, (index) => (index + 1).getJuzName);

  List<int> juzUnits = List.generate(30, (index) => index);
  List<int> hizbUnits = List.generate(60, (index) => index);
  List<int> quarterHizbUnits = List.generate(60 * 4, (index) => index);
  List<int> surahUnits = List.generate(114, (index) => index);
  List<int> pageUnits = List.generate(604, (index) => index);

  bool enableAlarm = false;

  int expectedPeriodOfKhatma = 0;
  String handleTextExpectedPeriodOfKhatma = '';
  calculateExpectedPeriod() {
    if (calculateByNoOfDay) calculateKhatmaByNoOfDay();
    if (calculateByReadingOfDay) calculateKhatmaByReadingOfDay();
  }

  void calculateKhatmaByNoOfDay() {
    int days = int.tryParse(daysController.text) ?? 1;
    if (days <= 604 && days >= 1) {
      // expectedPeriodOfKhatma = (604 / days).floor().toInt();
      int pages = 604 - ((selectedJuzIndex + 1) * 20);
      expectedPeriodOfKhatma = pages ~/ days;
      // expectedPeriodOfKhatma =
      //     ((604 - ((selectedJuzIndex + 1) * 20)) / days).ceil().toInt();
      // expectedPeriodOfKhatma = (604 / days);
      handleTextExpectedPeriodOfKhatma = '$expectedPeriodOfKhatma صفحة';
    } else {
      Fluttertoast.showToast(msg: 'الرجاء إدخال عدد مناسب');
    }
    update();
  }

  void calculateKhatmaByReadingOfDay() {
    // int pages = 604 - ((selectedJuzIndex + 1) * 20);
    expectedPeriodOfKhatma = (valueOfUnit ~/ (selectedDestiny + 1));
    update();
  }

  int get valueOfUnit {
    switch (unitIndex) {
      case 0:
        return 30;
      case 1:
        return 60;
      case 2:
        return 240;
      case 3:
        return 114;
      case 4:
        return 604;
      default:
        return 30;
    }
  }

  int selectedDestiny = 0;
  List<int> get listOfSelectedUnitIndex {
    switch (unitIndex) {
      case 0:
        return juzUnits;
      case 1:
        return hizbUnits;
      case 2:
        return quarterHizbUnits;
      case 3:
        return surahUnits;
      case 4:
        return pageUnits;
      default:
        return juzUnits;
    }
  }

  String? selectedTextTime;

  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      selectedTime = picked;
      selectedTextTime = _formatTimeOfDay(selectedTime);
      selectedTextTime = convertArabicToEnglish(selectedTextTime ?? '');
    }
    update();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('hh:mm a');
    return format.format(dt);
  }

  String convertArabicToEnglish(String input) {
    const arabicToEnglish = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      // 'م': 'PM',
      // 'ص': 'AM',
    };

    return input.split('').map((char) => arabicToEnglish[char] ?? char).join();
  }

  void clearTime() {
    selectedTime = TimeOfDay.now();
    selectedTextTime = null;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    // daysController.addListener(() {
    //   print('-------------------');
    //   print(daysController.text);
    //   if (daysController.text.isNotEmpty) {
    //     calculateExpectedPeriod();
    //   }
    // });
  }
}
