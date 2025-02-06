import '../../domain/entities/radio_entity.dart';

class RadioModel extends RadioEntity{
   RadioModel({
    required super.title,
    required super.countryCode,
    required super.audioUrl,
  });
 

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      title: json['title'],
      countryCode: json['country_code'],
      audioUrl: json['audio_url'],
    );
  }
Map<String, dynamic> toJson() => {
    'title': title,
    'country_code': countryCode,
    'audio_url': audioUrl
  };
}