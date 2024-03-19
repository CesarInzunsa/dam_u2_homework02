import 'package:shared_preferences/shared_preferences.dart';
import '../model/music.dart';

class MusicController {
  /// Create a new music
  Future<void> createMusic(Music music) async {
    SharedPreferences objet = await SharedPreferences.getInstance();

    List<String> musicList = objet.getStringList('musicList') ?? [];

    musicList.add(_musicToString(music));

    objet.setStringList('musicList', musicList);
  }

  Future<List<Music>> readMusic() async {
    SharedPreferences objet = await SharedPreferences.getInstance();
    List<String> musicList = objet.getStringList('musicList') ?? [];
    List<Music> musicListObject = [];

    for (String music in musicList) {
      musicListObject.add(_StringToMusic(music));
    }
    return musicListObject;
  }

  Future<void> updateMusic(Music oldDataMusic, Music newDataMusic) async {
    SharedPreferences object = await SharedPreferences.getInstance();

    List<String> musicList = object.getStringList('musicList') ?? [];

    // Convertir musicList a lista de objetos Music
    List<Music> musicListObject = [];
    for (String music in musicList) {
      musicListObject.add(_StringToMusic(music));
    }

    // Find and replace the music

    for (int i = 0; i < musicListObject.length; i++) {
      if (musicListObject[i].title == oldDataMusic.title) {
        musicListObject[i] = newDataMusic;
      }
    }

    // Convertir musicListObject a lista de strings
    musicList = [];
    for (Music music in musicListObject) {
      musicList.add(_musicToString(music));
    }

    object.setStringList('musicList', musicList);
  }

  Future<void> deleteMusic(Music music) async {
    SharedPreferences object = await SharedPreferences.getInstance();

    List<String> musicList = object.getStringList('musicList') ?? [];
    musicList.remove(_musicToString(music));
    object.setStringList('musicList', musicList);
  }

  String _musicToString(Music music) {
    return '${music.title}&&${music.artist}&&${music.album}&&${music.releaseYear}';
  }

  Music _StringToMusic(String music) {
    List<String> musicData = music.split('&&');
    return Music(
      title: musicData[0],
      artist: musicData[1],
      album: musicData[2],
      releaseYear: int.parse(musicData[3]),
    );
  }
}
