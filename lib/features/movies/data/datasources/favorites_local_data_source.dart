import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/movie_model.dart';

class FavoritesLocalDataSource {
  static const _tableName = 'favorites';
  Database? _database;

  Future<Database> _db() async {
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
  }

  Future<List<MovieModel>> getFavorites() async {
    final db = await _db();
    final maps = await db.query(_tableName, orderBy: 'id DESC');
    return maps.map(MovieModel.fromMap).toList();
  }

  Future<void> addFavorite(MovieModel movie) async {
    final db = await _db();
    await db.insert(_tableName, movie.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(int movieId) async {
    final db = await _db();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [movieId]);
  }

  Future<bool> isFavorite(int movieId) async {
    final db = await _db();
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [movieId], limit: 1);
    return maps.isNotEmpty;
  }
}
