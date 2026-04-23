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
    await _ensureDatabaseInstalled(dbPath);

    final database = await openDatabase(
      dbPath,
      singleInstance: true,
      readOnly: true,
    );

    _db = database;
    _opening = null;
    return database;
  }

  Future<void> _ensureDatabaseInstalled(String dbPath) async {
    final file = File(dbPath);

    // Случай 1: файла нет — первый запуск или после очистки данных.
    if (!await file.exists()) {
      await _copyAssetDbTo(dbPath);
      await _setVersionRW(dbPath, _dbVersion);
      return;
    }

    // Случай 2: файл есть — проверяем версию через отдельное соединение.
    final probe = await openDatabase(dbPath, singleInstance: false);
    final int currentVersion;
    try {
      currentVersion = await probe.getVersion();
    } finally {
      await probe.close();
    }

    if (currentVersion >= _dbVersion) return;

    // Случай 3: БД устарела — перезаливаем из assets.
    await deleteDatabase(dbPath);
    await _copyAssetDbTo(dbPath);
    await _setVersionRW(dbPath, _dbVersion);
  }

  Future<void> _setVersionRW(String dbPath, int version) async {
    final db = await openDatabase(dbPath, singleInstance: false);
    try {
      await db.setVersion(version);
    } finally {
      await db.close();
    }
  }

  Future<void> _copyAssetDbTo(String dbPath) async {
    final data = await rootBundle.load(_assetPath);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
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
    await _setVersionRW(dbPath, _dbVersion);

    await db;
  }
}