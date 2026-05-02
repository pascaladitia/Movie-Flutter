import '../../../../core/error/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetFavoriteMoviesUseCase {
  final MovieRepository repository;
  GetFavoriteMoviesUseCase(this.repository);
  Future<Result<List<Movie>>> call() => repository.getFavoriteMovies();
}

class AddFavoriteUseCase {
  final MovieRepository repository;
  AddFavoriteUseCase(this.repository);
  Future<Result<void>> call(Movie movie) => repository.addFavorite(movie);
}

class RemoveFavoriteUseCase {
  final MovieRepository repository;
  RemoveFavoriteUseCase(this.repository);
  Future<Result<void>> call(int movieId) => repository.removeFavorite(movieId);
}

class IsFavoriteUseCase {
  final MovieRepository repository;
  IsFavoriteUseCase(this.repository);
  Future<Result<bool>> call(int movieId) => repository.isFavorite(movieId);
}
