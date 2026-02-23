import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class QuranDatabaseService {
  QuranDatabaseService._();
  static final QuranDatabaseService instance = QuranDatabaseService._();

  static const String _dbFileName = 'quran.db';
  static const int _dbVersion = 1;

  static const String _assetPath = 'assets/databases/$_dbFileName';

  Database? _db;
  Future<Database>? _opening;

  Future<Database> get db {
    final existing = _db;
    if (existing != null) return Future.value(existing);

    final opening = _opening;
    if (opening != null) return opening;

    final future = _open();
    _opening = future;
    return future;
  }

  Future<Database> _open() async {
    final dbDir = await getDatabasesPath();
    final dbPath = p.join(dbDir, _dbFileName);

    await Directory(p.dirname(dbPath)).create(recursive: true);

    final file = File(dbPath);
    if (!await file.exists()) {
      await _copyAssetDbTo(dbPath);
    }

    // Open DB
    var database = await openDatabase(
      dbPath,
      singleInstance: true,
    );

    final currentVersion = await database.getVersion();
    if (currentVersion < _dbVersion) {
      await database.close();

      await deleteDatabase(dbPath);
      await _copyAssetDbTo(dbPath);

      database = await openDatabase(
        dbPath,
        singleInstance: true,
      );
      await database.setVersion(_dbVersion);
    } else if (currentVersion == 0) {
      await database.setVersion(_dbVersion);
    }

    _db = database;
    _opening = null;
    return database;
  }

  Future<void> _copyAssetDbTo(String dbPath) async {
    final data = await rootBundle.load(_assetPath);
    final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes, flush: true);
  }

  Future<void> close() async {
    _opening = null;
    final database = _db;
    _db = null;
    if (database != null) {
      await database.close();
    }
  }

  Future<void> reinstallFromAssets() async {
    final dbDir = await getDatabasesPath();
    final dbPath = p.join(dbDir, _dbFileName);

    await close();
    await deleteDatabase(dbPath);
    await _copyAssetDbTo(dbPath);

    await db;
  }
}