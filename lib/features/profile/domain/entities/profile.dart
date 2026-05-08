import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String name;
  final String email;
  final String? imagePath;
  final String? birthDate;
  final String? address;
  final double? latitude;
  final double? longitude;

  const Profile({
    required this.name,
    required this.email,
    required this.imagePath,
    required this.birthDate,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  static const empty = Profile(
    name: '',
    email: '',
    imagePath: null,
    birthDate: null,
    address: null,
    latitude: null,
    longitude: null,
  );

  Profile copyWith({
    String? name,
    String? email,
    String? imagePath,
    String? birthDate,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    imagePath,
    birthDate,
    address,
    latitude,
    longitude,
  ];
}
