import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: json['release_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
    };
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] as int,
      title: map['title'] as String,
      overview: map['overview'] as String,
      posterPath: map['posterPath'] as String?,
      backdropPath: map['backdropPath'] as String?,
      voteAverage: (map['voteAverage'] as num).toDouble(),
      releaseDate: map['releaseDate'] as String,
    );
  }
}
