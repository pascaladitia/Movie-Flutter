import '../../domain/entities/movie_page.dart';
import 'movie_model.dart';

class MoviePageModel extends MoviePage {
  const MoviePageModel({
    required super.page,
    required super.totalPages,
    required super.results,
  });

  factory MoviePageModel.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List<dynamic>? ?? [])
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return MoviePageModel(
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      results: results,
    );
  }
}
