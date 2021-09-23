import 'package:borderlands_perks/models/build.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  static final Storage _instance = Storage._internal();

  factory Storage() {
    return _instance;
  }

  var database;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    database =
        openDatabase(join(await getDatabasesPath(), 'borderlandsPerks.db'),
            onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE builds(id TEXT, name TEXT, character TEXT, trees TEXT)');
    }, version: 1);
  }

  Future<bool> exists(String id) async {
    final db = await database;

    var result = await db.query('builds', where: 'id = ?', whereArgs: [id]);

    return result.isNotEmpty;
  }

  Future<List<Build>> builds() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('builds');

    List<Build> builds = [];

    for (var element in maps) {
      Build build = await Build.fromJson(element);
      builds.add(build);
    }

    return builds;
  }

  Future<void> insertBuild(Build build) async {
    final db = await database;

    await db.insert('builds', build.toMap());
  }

  Future<void> updateBuild(Build build) async {
    final db = await database;

    await db.update('builds', build.toMap(),
        where: 'id = ?', whereArgs: [build.id]);
  }

  Future<void> removeBuild(String id) async {
    final db = await database;

    await db.delete('builds', where: 'id = ?', whereArgs: [id]);
  }

  Storage._internal();
}
