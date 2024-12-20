import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path/path.dart' as p;

part 'bookmarks.g.dart';

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get messageId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Bookmarks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<Bookmark> watchBookmark(int messageId) {
    return (select(bookmarks)..where((bm) => bm.messageId.equals(messageId)))
        .watchSingle();
  }

  Stream<bool> watchIsBookmarked(int messageId) {
    final StreamController<bool> controller = StreamController<bool>();

    (select(bookmarks)..where((bm) => bm.messageId.equals(messageId)))
        .watchSingleOrNull()
        .listen((event) {
      // log("isBookmarked: ${event != null}");
      controller.add(event != null);
    });

    return controller.stream;
  }

  Future<bool> isBookmarked(int messageId) async {
    final bookmark = await (select(bookmarks)
          ..where((bm) => bm.messageId.equals(messageId)))
        .getSingleOrNull();

    return bookmark != null;
  }

  Stream<List<Bookmark>> watchBookmarks() {
    return (select(bookmarks)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<int> addBookmark(int messageId) {
    return into(bookmarks)
        .insert(BookmarksCompanion.insert(messageId: messageId));
  }

  Future<void> deleteBookmark(int messageId) {
    return (delete(bookmarks)..where((bm) => bm.messageId.equals(messageId)))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFloder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFloder.path, 'db.sqlite'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(file, logStatements: true);
  });
}
