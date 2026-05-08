import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<void> call(Profile profile) => repository.saveProfile(profile);
}
