import '../../../../core/error/result.dart';
import '../entities/movie.dart';
import '../entities/movie_page.dart';
import '../entities/video_item.dart';

abstract class MovieRepository {
  Future<Result<MoviePage>> discoverMovies({required int page});
  Future<Result<List<Movie>>> getTopRatedPreview();
  Future<Result<List<Movie>>> getUpcomingPreview();
  Future<Result<List<Movie>>> searchMovies(String query);
  Future<Result<List<VideoItem>>> getMovieVideos(int movieId);
  Future<Result<List<Movie>>> getFavoriteMovies();
  Future<Result<bool>> isFavorite(int movieId);
  Future<Result<void>> addFavorite(Movie movie);
  Future<Result<void>> removeFavorite(int movieId);
}
