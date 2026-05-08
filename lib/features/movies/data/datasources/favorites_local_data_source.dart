import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/failure.dart';
import '../models/movie_model.dart';

class FavoritesLocalDataSource {
  static const _tableName = 'favorites';
  Database? _database;

  Future<Database> _db() async {
    try {
      _database ??= await openDatabase(
        join(await getDatabasesPath(), 'movie_app.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            posterPath TEXT,
            backdropPath TEXT,
            voteAverage REAL,
            releaseDate TEXT
          )
        ''');
        },
      );
      return _database!;
    } catch (e) {
      throw Failure('DB: Failed to initialize local database');
    }
  }

  Future<List<MovieModel>> getFavorites() async {
    try {
      final db = await _db();
      final maps = await db.query(_tableName, orderBy: 'id DESC');
      return maps.map(MovieModel.fromMap).toList();
    } catch (e) {
      throw Failure('DB: Failed to load favorites');
    }
  }

  Future<void> addFavorite(MovieModel movie) async {
    try {
      final db = await _db();
      await db.insert(_tableName, movie.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Failure('DB: Failed to save favorite movie');
    }
  }

  Future<void> removeFavorite(int movieId) async {
    try {
      final db = await _db();
      await db.delete(_tableName, where: 'id = ?', whereArgs: [movieId]);
    } catch (e) {
      throw Failure('DB: Failed to remove favorite movie');
    }
  }

  Future<bool> isFavorite(int movieId) async {
    try {
      final db = await _db();
      final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [movieId], limit: 1);
      return maps.isNotEmpty;
    } catch (e) {
      throw Failure('DB: Failed to read favorite status');
    }
  }
}
