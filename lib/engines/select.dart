part of 'engine.dart';

Song select(List<Song> list, Info info) {
  final duration = info.duration;
  return list.sublist(0, min(5, list.length)).firstWhere(
        (song) => song.duration != null && (song.duration! - duration).abs() < 5 * 1e3,
        orElse: () => list.first,
      );
}
