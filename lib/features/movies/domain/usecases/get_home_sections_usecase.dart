import '../../../../core/error/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class HomeSectionsResult {
  final List<Movie> topRated;
  final List<Movie> upcoming;

  const HomeSectionsResult({required this.topRated, required this.upcoming});
}

class GetHomeSectionsUseCase {
  final MovieRepository repository;

  GetHomeSectionsUseCase(this.repository);

  Future<Result<HomeSectionsResult>> call() async {
    final topRated = await repository.getTopRatedPreview();
    final upcoming = await repository.getUpcomingPreview();

    if (!topRated.isSuccess) return Result.error(topRated.failure);
    if (!upcoming.isSuccess) return Result.error(upcoming.failure);

    return Result.success(HomeSectionsResult(topRated: topRated.data!, upcoming: upcoming.data!));
  }
}
