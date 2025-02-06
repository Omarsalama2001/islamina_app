import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:islamina_app/features/radio/data/models/radio_model.dart';
import 'package:islamina_app/features/radio/domain/entities/radio_entity.dart';
import 'package:just_audio/just_audio.dart';

part 'raido_state.dart';

class RaidoCubit extends Cubit<RaidoState> {
  final dio = Dio();
  final AudioPlayer player = AudioPlayer();
  int selectedRadioIndex = 0;
  bool isPlaying = false;
  var playlist;
  List<RadioEntity> radios = [];

  RaidoCubit() : super(RaidoInitial());
  _initAudioPlayer() async {
    await player.setLoopMode(LoopMode.all);
    await player.setAudioSource(playlist);
    listenToPlayer();
  }

  listenToPlayer() => player.playerStateStream.listen((event) {
        emit(RaidoInitial());
        if (event.playing && event.processingState == ProcessingState.ready) {
          isPlaying = true;
          emit(ChangeAudioState(isPlaying: true, processingState: event.processingState));
        } else {
          isPlaying = false;
          emit(ChangeAudioState(isPlaying: false, processingState: event.processingState));
        }
      });

  changeSelectedRadio(int index) async {
    emit(RaidoInitial());
    selectedRadioIndex = index;
    await player.seek(Duration.zero, index: selectedRadioIndex);
    player.play();
    emit(ChangeSelectedRadioState());
  }

  getPreviousRadio() async {
    selectedRadioIndex = (selectedRadioIndex - 1 + radios.length) % radios.length;
    changeSelectedRadio(selectedRadioIndex);
    emit(ChangeSelectedRadioState());
    player.seekToPrevious();
  }

  getNextRadio() async {
    selectedRadioIndex = (selectedRadioIndex + 1) % radios.length;
    changeSelectedRadio(selectedRadioIndex);
    player.seekToNext();
  }

  getAllRadios() async {
    emit(GetAllRadiosLoadingState());
    try {
      final Response response = await dio.get('https://islamina1-68jbw7rmy-omarsalama2001s-projects.vercel.app/?vercelToolbarCode=nb7OGz7VpUfDpfF');
      final List<RadioModel> allRadios = (response.data as List).map((e) => RadioModel.fromJson(e)).toList();
      radios = allRadios;
      final List<AudioSource> audioSources = allRadios
          .map((radio) => AudioSource.uri(
              Uri.parse(
                radio.audioUrl,
              ),
              headers: {},
              tag: MediaItem(
                id: radio.title,
                title: radio.title,
                
                artUri: Uri.parse('https://i.pinimg.com/564x/3a/a1/a1/3aa1a107c9434ca52b42b2dd0ffc896f.jpg'),
              )))
          .toList();
      playlist = ConcatenatingAudioSource(children: audioSources);
      await _initAudioPlayer();

      emit(GetAllRadiosSuccessState(radios: allRadios));
    } catch (e) {
      emit(GetAllRadiosErrorState());
    }
  }
}

  // getNextRadio() async {
  //   selectedRadioIndex = (selectedRadioIndex + 1) % radios.length;
  //   changeSelectedRadio(selectedRadioIndex);
  //   emit(ChangeSelectedRadioState());
  // }

  // getPreviousRadio() async {
  //   selectedRadioIndex = (selectedRadioIndex - 1 + radios.length) % radios.length;
  //   changeSelectedRadio(selectedRadioIndex);
  //   emit(ChangeSelectedRadioState());
  // }

  // palyAudio() {
  //   emit(RaidoInitial());
  //   if (isPlaying) {
  //     return;
  //   }
  //   _player.play();
  //   isPlaying = true;
  //   emit(ChangeAudioState());
  // }

  // pause() {
  //   emit(RaidoInitial());
  //   if (!isPlaying) {
  //     return;
  //   }
  //   _player.pause();
  //   isPlaying = false;
  //   emit(ChangeAudioState());
  // }
