import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/favorites_usecases.dart';

class FavoritesState extends Equatable {
  final bool isLoading;
  final List<Movie> movies;
  final String? error;

  const FavoritesState({required this.isLoading, required this.movies, required this.error});

  factory FavoritesState.initial() => const FavoritesState(isLoading: false, movies: [], error: null);

  FavoritesState copyWith({bool? isLoading, List<Movie>? movies, String? error}) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, movies, error];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoriteMoviesUseCase getFavorites;
  final AddFavoriteUseCase addFavorite;
  final RemoveFavoriteUseCase removeFavorite;

  FavoritesCubit({required this.getFavorites, required this.addFavorite, required this.removeFavorite}) : super(FavoritesState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await getFavorites();
    if (!result.isSuccess) {
      emit(state.copyWith(isLoading: false, error: result.failure?.message));
      return;
    }
    emit(state.copyWith(isLoading: false, movies: result.data!, error: null));
  }

  Future<void> toggle(Movie movie) async {
    final exists = state.movies.any((m) => m.id == movie.id);
    if (exists) {
      await removeFavorite(movie.id);
    } else {
      await addFavorite(movie);
    }
    await load();
  }
}
