import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sysdev_suretti/models/database.dart';

final dbProvider = Provider((ref) => DBProvider());

class DBProvider {
  static final AppDatabase _appDatabase = AppDatabase();
  AppDatabase get database => _appDatabase;
}
