import '../../../../core/error/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMoviesUseCase {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<Result<List<Movie>>> call(String query) => repository.searchMovies(query);
}
