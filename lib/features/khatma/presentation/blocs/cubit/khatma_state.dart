part of 'khatma_cubit.dart';

sealed class KhatmaState extends Equatable {
  const KhatmaState();

  @override
  List<Object> get props => [];
}

final class KhatmaInitial extends KhatmaState {}

final class KhatamaRadioChanged extends KhatmaState {}

final class khatmaWayRadioValueChanged extends KhatmaState {}

final class KhatamaChipsChanged extends KhatmaState {}

final class PageViewChanged extends KhatmaState {}

final class khatmaPeriodChangedState extends KhatmaState {}

final class KhatmaAddedSuccessState extends KhatmaState {}
final class KhatmaAddLoadingState extends KhatmaState {}

final class KhatmaAddErrorState extends KhatmaState {}

final class GetAllKhatmaSuccessState extends KhatmaState {
  List <KhatmaModel> khatmaModelList;
  GetAllKhatmaSuccessState(this.khatmaModelList);
}

final class GetAllKhatmaLoadingState extends KhatmaState {}

final class GetAllKhatmaErrorState extends KhatmaState {}

final class GetAllDoneKhatmaSuccessState extends KhatmaState {
  List <KhatmaModel> khatmaModelList;
  GetAllDoneKhatmaSuccessState(this.khatmaModelList);
}

final class GetAllDoneKhatmaLoadingState extends KhatmaState {}

final class GetAllDoneKhatmaErrorState extends KhatmaState {}
class SyncKhatmaLoadingState extends KhatmaState {}

class SyncKhatmaSuccessState extends KhatmaState {}

class SyncKhatmaErrorState extends KhatmaState {}
class NoUserState extends KhatmaState {}