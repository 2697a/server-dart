import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:server_dart/engines/engine.dart';

part 'db.g.dart';

// 歌曲
@UseRowClass(Song)
class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 6, max: 32)();

  IntColumn get duration => integer()();
}

@DriftDatabase(tables: [Songs])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final db = Database();

void testDb() async {
  await db.into(db.songs).insert(SongsCompanion.insert(name: '七里香', duration: 300));
  List<Song> songs = await db.select(db.songs).get();
  print(songs);
}

// 一次生成所有必需的代码。
// dart run build_runner build
// 监视源代码中的更改，并通过增量重新生成生成代码。这适用于开发会话。
// dart run build_runner watch
