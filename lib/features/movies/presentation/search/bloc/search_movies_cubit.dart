import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/search_movies_usecase.dart';

class SearchMoviesState extends Equatable {
  final bool isLoading;
  final List<Movie> movies;
  final String? error;

  const SearchMoviesState({required this.isLoading, required this.movies, required this.error});

  factory SearchMoviesState.initial() => const SearchMoviesState(isLoading: false, movies: [], error: null);

  SearchMoviesState copyWith({bool? isLoading, List<Movie>? movies, String? error}) {
    return SearchMoviesState(
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, movies, error];
}

class SearchMoviesCubit extends Cubit<SearchMoviesState> {
  final SearchMoviesUseCase useCase;

  SearchMoviesCubit(this.useCase) : super(SearchMoviesState.initial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchMoviesState.initial());
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    final result = await useCase(query);
    if (!result.isSuccess) {
      emit(state.copyWith(isLoading: false, error: result.failure?.message ?? 'Error'));
      return;
    }

    emit(state.copyWith(isLoading: false, movies: result.data!, error: null));
  }
}
