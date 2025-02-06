part of 'raido_cubit.dart';

sealed class RaidoState extends Equatable {
  const RaidoState();

  @override
  List<Object> get props => [];
}

final class RaidoInitial extends RaidoState {}

class GetAllRadiosLoadingState extends RaidoState {
 
}
class GetAllRadiosSuccessState extends RaidoState {
  final List<RadioEntity> radios;
  const GetAllRadiosSuccessState({required this.radios});
}

class GetAllRadiosErrorState extends RaidoState {}

class ChangeSelectedRadioState extends RaidoState {}
class ChangeAudioState extends RaidoState {
  final bool isPlaying;
  final ProcessingState processingState;
  const ChangeAudioState({required this.isPlaying, required this.processingState});
}