import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_page.dart';
import '../../domain/entities/video_item.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/favorites_local_data_source.dart';
import '../datasources/movies_remote_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MoviesRemoteDataSource remote;
  final FavoritesLocalDataSource local;

  MovieRepositoryImpl({required this.remote, required this.local});

  Future<Result<T>> _wrap<T>(Future<T> Function() fn) async {
    try {
      return Result.success(await fn());
    } on Failure catch (e) {
      return Result.error(e);
    } catch (_) {
      return const Result.error(Failure('Unexpected error occurred'));
    }
  }

  @override
  Future<Result<MoviePage>> discoverMovies({required int page}) => _wrap(() => remote.discoverMovies(page: page));

  @override
  Future<Result<List<Movie>>> getTopRatedPreview() => _wrap(remote.getTopRatedPreview);

  @override
  Future<Result<List<Movie>>> getUpcomingPreview() => _wrap(remote.getUpcomingPreview);

  @override
  Future<Result<List<Movie>>> searchMovies(String query) => _wrap(() => remote.searchMovies(query));

  @override
  Future<Result<List<VideoItem>>> getMovieVideos(int movieId) => _wrap(() => remote.getMovieVideos(movieId));

  @override
  Future<Result<List<Movie>>> getFavoriteMovies() => _wrap(local.getFavorites);

  @override
  Future<Result<bool>> isFavorite(int movieId) => _wrap(() => local.isFavorite(movieId));

  @override
  Future<Result<void>> addFavorite(Movie movie) => _wrap(() => local.addFavorite(MovieModel(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        posterPath: movie.posterPath,
        backdropPath: movie.backdropPath,
        voteAverage: movie.voteAverage,
        releaseDate: movie.releaseDate,
      )));

  @override
  Future<Result<void>> removeFavorite(int movieId) => _wrap(() => local.removeFavorite(movieId));
}
