import '../../../../core/error/result.dart';
import '../entities/movie_page.dart';
import '../repositories/movie_repository.dart';

class GetDiscoverMoviesUseCase {
  final MovieRepository repository;

  GetDiscoverMoviesUseCase(this.repository);

  Future<Result<MoviePage>> call({required int page}) {
    return repository.discoverMovies(page: page);
  }
}
