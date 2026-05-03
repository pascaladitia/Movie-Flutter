import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_discover_movies_usecase.dart';
import '../../../domain/usecases/search_movies_usecase.dart';

class SearchMoviesState extends Equatable {
  final bool isLoading;
  final List<Movie> movies;
  final bool isSearchMode;
  final String? error;

  const SearchMoviesState({required this.isLoading, required this.movies, required this.isSearchMode, required this.error});

  factory SearchMoviesState.initial() => const SearchMoviesState(isLoading: false, movies: [], isSearchMode: false, error: null);

  SearchMoviesState copyWith({bool? isLoading, List<Movie>? movies, bool? isSearchMode, String? error}) {
    return SearchMoviesState(
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, movies, isSearchMode, error];
}

class SearchMoviesCubit extends Cubit<SearchMoviesState> {
  final SearchMoviesUseCase useCase;
  final GetDiscoverMoviesUseCase discoverUseCase;

  SearchMoviesCubit(this.useCase, this.discoverUseCase) : super(SearchMoviesState.initial());

  Future<void> loadInitialMovies() async {
    emit(state.copyWith(isLoading: true, error: null, isSearchMode: false));
    final result = await discoverUseCase(page: 1);
    if (!result.isSuccess) {
      emit(state.copyWith(isLoading: false, error: result.failure?.message ?? 'Error'));
      return;
    }
    emit(state.copyWith(isLoading: false, movies: result.data!.results, isSearchMode: false, error: null));
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await loadInitialMovies();
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, isSearchMode: true));
    final result = await useCase(query);
    if (!result.isSuccess) {
      emit(state.copyWith(isLoading: false, error: result.failure?.message ?? 'Error'));
      return;
    }

    emit(state.copyWith(isLoading: false, movies: result.data!, isSearchMode: true, error: null));
  }
}
