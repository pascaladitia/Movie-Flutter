import '../../../../core/error/result.dart';
import '../entities/video_item.dart';
import '../repositories/movie_repository.dart';

class GetMovieVideosUseCase {
  final MovieRepository repository;

  GetMovieVideosUseCase(this.repository);

  Future<Result<List<VideoItem>>> call(int movieId) => repository.getMovieVideos(movieId);
}
