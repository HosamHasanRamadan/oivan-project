import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('This value should be overridden');
});

class LocalStorage {
  final Database database;

  static Future<LocalStorage> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = '${dir.path}/local.db';
    final db = await databaseFactoryIo.openDatabase(dbPath);
    return LocalStorage(db);
  }

  LocalStorage(this.database);

  void dispose() {
    database.close();
  }
}
