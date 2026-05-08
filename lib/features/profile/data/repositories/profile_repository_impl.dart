import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<Profile> getProfile() => localDataSource.getProfile();

  @override
  Future<void> saveProfile(Profile profile) {
    return localDataSource.saveProfile(ProfileModel.fromEntity(profile));
  }
}
