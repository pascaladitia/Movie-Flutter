import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.name,
    required super.email,
    required super.imagePath,
    required super.birthDate,
    required super.address,
    required super.latitude,
    required super.longitude,
  });

  factory ProfileModel.fromMap(Map<String, Object?> map) {
    return ProfileModel(
      name: (map['name'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      imagePath: map['imagePath'] as String?,
      birthDate: map['birthDate'] as String?,
      address: map['address'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      name: profile.name,
      email: profile.email,
      imagePath: profile.imagePath,
      birthDate: profile.birthDate,
      address: profile.address,
      latitude: profile.latitude,
      longitude: profile.longitude,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'email': email,
      'imagePath': imagePath,
      'birthDate': birthDate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
