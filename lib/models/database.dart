import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get messageId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Notices extends Table {
  IntColumn get id => integer().autoIncrement()();
  // IntColumn get messageId => integer().nullable()();
  TextColumn get title => text().withDefault(const Constant(""))();
  TextColumn get body => text().withDefault(const Constant(""))();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ScannedUsers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  DateTimeColumn get scannedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Bookmarks, Notices, ScannedUsers])
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

  // -----

  Future<int> addNotice(String title, String body) {
    return into(notices).insert(
        NoticesCompanion.insert(title: Value(title), body: Value(body)));
  }

  Future<void> readAllNotices() {
    return (update(notices)..where((n) => n.readAt.isNull()))
        .write(NoticesCompanion(readAt: Value(DateTime.now())));
  }

  Stream<List<Notice>> watchNotices(String filter) {
    if (filter == "新しい順") {
      return (select(notices)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();
    } else {
      return (select(notices)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();
    }
  }

  Stream<int> watchUnreadNoticeCount() {
    return (select(notices)..where((n) => n.readAt.isNull()))
        .watch()
        .map((notices) => notices.length);
  }

  // -----

  Future<int> addScannedUser(int userId) async {
    // ５分以内に同じユーザーがスキャンされた場合は無視
    final now = DateTime.now();
    final scannedUser = await (select(scannedUsers)
          ..where((su) => su.userId.equals(userId))
          ..where((su) => su.scannedAt.isBiggerThanValue(
              now.subtract(const Duration(minutes: 5))))
          ..limit(1))
        .getSingleOrNull();

    if (scannedUser != null) {
      log("同じユーザーが５分以内にスキャンされました。");
      log(scannedUser.toString(), name: 'scannedUser');
      log(now.toString(), name: 'now');
      return Future.value(0);
    }

    return into(scannedUsers)
        .insert(ScannedUsersCompanion.insert(userId: userId));
  }

  Stream<List<ScannedUser>> watchScannedUsers() {
    return (select(scannedUsers)
          ..orderBy([(t) => OrderingTerm.desc(t.scannedAt)]))
        .watch();
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
