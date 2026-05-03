import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../models/movie_model.dart';
import '../models/movie_page_model.dart';
import '../models/video_model.dart';

class MoviesRemoteDataSource {
  final Dio dio;

  MoviesRemoteDataSource(this.dio);

  Failure _mapApiFailure(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.message ?? 'Network error';
    return Failure('API: ${statusCode != null ? '[$statusCode] ' : ''}$message');
  }

  Future<MoviePageModel> discoverMovies({required int page}) async {
    try {
      final response = await dio.get('/discover/movie', queryParameters: {
        'page': page,
        'sort_by': 'popularity.desc',
        'include_adult': false,
      });
      return MoviePageModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapApiFailure(e);
    }
  }

  Future<List<MovieModel>> getTopRatedPreview() async {
    try {
      final response = await dio.get('/movie/top_rated', queryParameters: {'page': 1});
      final results = (response.data['results'] as List<dynamic>? ?? [])
          .take(10)
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return results;
    } on DioException catch (e) {
      throw _mapApiFailure(e);
    }
  }

  Future<List<MovieModel>> getUpcomingPreview() async {
    try {
      final response = await dio.get('/movie/upcoming', queryParameters: {'page': 1});
      final results = (response.data['results'] as List<dynamic>? ?? [])
          .take(10)
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return results;
    } on DioException catch (e) {
      throw _mapApiFailure(e);
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await dio.get('/search/movie', queryParameters: {'query': query, 'page': 1});
      final results = (response.data['results'] as List<dynamic>?) ?? [];
      return results.map((json) => MovieModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapApiFailure(e);
    }
  }

  Future<List<VideoModel>> getMovieVideos(int movieId) async {
    try {
      final response = await dio.get('/movie/$movieId/videos');
      final results = (response.data['results'] as List<dynamic>?) ?? [];
      return results.map((json) => VideoModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapApiFailure(e);
    }
  }
}
