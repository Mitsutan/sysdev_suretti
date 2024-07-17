import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sysdev_suretti/models/scanned_user.dart';

class Sqlite {
  late final Future<Database> _database;

  Sqlite() {
    _database = _open();
  }

  /// SQLiteデータベースを開く
  ///
  /// @return Future<Database>
  Future<Database> _open() async {
    const sql = {
      '2': ['']
    };
    return openDatabase(
      join(await getDatabasesPath(), 'suretti.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE IF NOT EXISTS scanned_user(id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, is_got_post INTEGER DEFAULT 0, scanned_at TEXT)');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        for (var i = oldVersion + 1; i <= newVersion; i++) {
          if (sql.containsKey(i.toString())) {
            for (final query in sql[i.toString()]!) {
              db.execute(query);
            }
          }
        }
      },
    );
  }

  /// データベース削除
  Future<void> deleteDatabase() async {
    final db = await _database;
    await db.delete('scanned_user');
  }

  /// スキャンしたユーザーデータを登録する
  ///
  /// @param ScanedUser scandUser
  /// @return Future<void>
  Future<void> insertScanedUser(ScannedUser scandUser) async {
    final db = await _database;
    await db.insert(
      'scanned_user',
      scandUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// スキャンしたユーザーデータのうち投稿未取得のものを取得する
  ///
  /// @return Future<List<ScanedUser>>
  Future<List<ScannedUser>> getScanedUsers() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps =
        await db.query('scanned_user', where: 'is_got_post = 0');
    return List.generate(maps.length, (i) {
      return ScannedUser(
        id: maps[i]['id'],
        userId: maps[i]['user_id'],
        isGotPost: maps[i]['is_got_post'],
        scannedAt: DateTime.parse(maps[i]['scanned_at']),
      );
    });
  }
}
