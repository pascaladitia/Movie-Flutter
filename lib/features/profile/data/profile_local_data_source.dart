import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/error/failure.dart';

class ProfileData extends Equatable {
  final String name;
  final String email;
  final String? imagePath;
  final String? birthDate;
  final String? address;
  final double? latitude;
  final double? longitude;

  const ProfileData({
    required this.name,
    required this.email,
    required this.imagePath,
    required this.birthDate,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  static const empty = ProfileData(
    name: '',
    email: '',
    imagePath: null,
    birthDate: null,
    address: null,
    latitude: null,
    longitude: null,
  );

  @override
  List<Object?> get props => [name, email, imagePath, birthDate, address, latitude, longitude];
}

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

  Future<ProfileData> getProfile() async {
    try {
      final db = await _db();
      final rows = await db.query(_tableName, where: 'id = ?', whereArgs: [1], limit: 1);
      if (rows.isEmpty) {
        await db.insert(_tableName, {'id': 1, 'name': '', 'email': ''});
        return ProfileData.empty;
      }
      final row = rows.first;
      return ProfileData(
        name: (row['name'] as String?) ?? '',
        email: (row['email'] as String?) ?? '',
        imagePath: row['imagePath'] as String?,
        birthDate: row['birthDate'] as String?,
        address: row['address'] as String?,
        latitude: (row['latitude'] as num?)?.toDouble(),
        longitude: (row['longitude'] as num?)?.toDouble(),
      );
    } catch (_) {
      throw Failure('DB: Failed to load profile');
    }
  }

  Future<void> saveProfile(ProfileData profile) async {
    try {
      final db = await _db();
      await db.update(
        _tableName,
        {
          'name': profile.name,
          'email': profile.email,
          'imagePath': profile.imagePath,
          'birthDate': profile.birthDate,
          'address': profile.address,
          'latitude': profile.latitude,
          'longitude': profile.longitude,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    } catch (_) {
      throw Failure('DB: Failed to save profile');
    }
  }
}
