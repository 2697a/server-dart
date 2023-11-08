import 'dart:math';

part 'bilibili/bilibili.dart';

part 'find.dart';

part 'kugou/kugou.dart';

part 'kuwo/kuwo.dart';

part 'qq/qq.dart';

part 'select.dart';

abstract class Engine<T> {
  void search(Info info);

  void track(Info info);

  // 返回url
  Future<String> check(Info info);
}

class Info {
  String id;

  // 歌名
  String name;

  // 别名
  String alias;

  // 时长
  int duration;

  // 专辑
  Album album;

  // 歌手
  List<Artist> artists;

  // 关键字
  String keyword;

  Info(this.id, this.name, this.alias, this.duration, this.album, this.artists, this.keyword);
}

class Id {}

// 歌曲
class Song {
  int id;

  // 歌名
  String name;

  // 时长
  int duration;

  Song({required this.id, required this.name, required this.duration});
}

// 专辑
class Album {
  // 专辑ID
  String id;

  // 专辑名
  String name;

  Album(this.id, this.name);
}

// 歌手
class Artist {
  // 歌手ID
  String id;

  // 歌手名
  String name;

  Artist(this.id, this.name);
}
