part of 'on_boarding_cubit.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

final class OnBoardingInitial extends OnBoardingState {}

final class OnBoardingPageChangedState extends OnBoardingState {
  final int pageNumber;

  const OnBoardingPageChangedState({required this.pageNumber});

  @override
  List<Object> get props => [pageNumber];
}

final class GetLocationSuccessState extends OnBoardingState {}

final class GetLocationFailedState extends OnBoardingState {}

final class GetLocationLoadingState extends OnBoardingState {}