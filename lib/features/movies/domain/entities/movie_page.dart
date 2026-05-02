import 'package:equatable/equatable.dart';

import 'movie.dart';

class MoviePage extends Equatable {
  final int page;
  final int totalPages;
  final List<Movie> results;

  const MoviePage({required this.page, required this.totalPages, required this.results});

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [page, totalPages, results];
}
