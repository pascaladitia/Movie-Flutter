import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/failure.dart';
import '../models/profile_model.dart';

class ProfileLocalDataSource {
  static const _tableName = 'profile';
  Database? _database;

  Future<Database> _db() async {
    try {
      _database ??= await openDatabase(
        join(await getDatabasesPath(), 'movie_profile.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY,
              name TEXT,
              email TEXT,
              imagePath TEXT,
              birthDate TEXT,
              address TEXT,
              latitude REAL,
              longitude REAL
            )
          ''');
          await db.insert(_tableName, {'id': 1, 'name': '', 'email': ''});
        },
      );
      return _database!;
    } catch (_) {
      throw Failure('DB: Failed to initialize profile database');
    }
  }

  Future<ProfileModel> getProfile() async {
    try {
      final db = await _db();
      final rows = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );
      if (rows.isEmpty) {
        await db.insert(_tableName, {'id': 1, 'name': '', 'email': ''});
        return const ProfileModel(
          name: '',
          email: '',
          imagePath: null,
          birthDate: null,
          address: null,
          latitude: null,
          longitude: null,
        );
      }
      return ProfileModel.fromMap(rows.first);
    } catch (_) {
      throw Failure('DB: Failed to load profile');
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    try {
      final db = await _db();
      await db.update(
        _tableName,
        profile.toMap(),
        where: 'id = ?',
        whereArgs: [1],
      );
    } catch (_) {
      throw Failure('DB: Failed to save profile');
    }
  }
}
