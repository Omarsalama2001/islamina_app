import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:islamina_app/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());
  SharedPreferences prefs = SharedPreferencesService.instance.prefs;
  int onBoardingPageNumber = 0;

  void changeOnBoardingPage(int pageNumber) {
    onBoardingPageNumber = pageNumber;
    emit(OnBoardingPageChangedState(pageNumber: pageNumber));
  }

  void setOnboardingEnded() {
    prefs.setBool('onboarding', true);
  }

  bool getOnboardingStatus() {
    if (prefs.containsKey('onboarding')) {
      return true;
    }
    return false;
  }
}
