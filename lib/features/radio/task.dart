import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
   onStart(var params) async {
    // Start playback (you can initialize with an audio URL)
    _player.play();
    _isPlaying = true;
    
    // Set up notifications
    AudioServiceBackground.setMediaItem(
      MediaItem(
        id: 'audio_id',
        album: "الاذاعة",
        title: 'Radio Title',
        artUri: Uri.parse("https://img.freepik.com/free-photo/al-maghfirah-mosque-uae-with-its-domes-towers-clear-sky_181624-27600.jpg"),
      ),
    );

    AudioServiceBackground.setState(
      controls: [
        MediaControl.play,
        MediaControl.pause,
      ],
      playing: _isPlaying,
      processingState: AudioProcessingState.ready,
    );
    
    // You can add more configuration here if needed
  }

  @override
  Future<void> onPlay() async {
    _isPlaying = true;
    await _player.play();
    AudioServiceBackground.setState(
      controls: [MediaControl.pause],
      playing: _isPlaying,
      processingState: AudioProcessingState.ready,
    );
  }

  @override
  Future<void> onPause() async {
    _isPlaying = false;
    await _player.pause();
    AudioServiceBackground.setState(
      controls: [MediaControl.play],
      playing: _isPlaying,
      processingState: AudioProcessingState.ready,
    );
  }

  @override
  Future<void> onStop() async {
    await _player.stop();
    await super.onStop();
  }
}
