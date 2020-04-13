import 'package:audio_service/audio_service.dart';

final queue = <MediaItem>[
  MediaItem(
    id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: 5739820,
    artUri:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
  ),
  MediaItem(
    id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
    album: "Science Friday",
    title: "From Cat Rheology To Operatic Incompetence",
    artist: "Science Friday and WNYC Studios",
    duration: 2856950,
    artUri:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
  ),
];
