import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_discover_movies_usecase.dart';
import '../../../domain/usecases/get_home_sections_usecase.dart';

class HomeMoviesState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final List<Movie> discoverMovies;
  final List<Movie> topRated;
  final List<Movie> upcoming;
  final int page;
  final bool hasReachedEnd;

  const HomeMoviesState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.error,
    required this.discoverMovies,
    required this.topRated,
    required this.upcoming,
    required this.page,
    required this.hasReachedEnd,
  });

  factory HomeMoviesState.initial() => const HomeMoviesState(
        isLoading: false,
        isLoadingMore: false,
        error: null,
        discoverMovies: [],
        topRated: [],
        upcoming: [],
        page: 1,
        hasReachedEnd: false,
      );

  HomeMoviesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    List<Movie>? discoverMovies,
    List<Movie>? topRated,
    List<Movie>? upcoming,
    int? page,
    bool? hasReachedEnd,
  }) {
    return HomeMoviesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      discoverMovies: discoverMovies ?? this.discoverMovies,
      topRated: topRated ?? this.topRated,
      upcoming: upcoming ?? this.upcoming,
      page: page ?? this.page,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoadingMore, error, discoverMovies, topRated, upcoming, page, hasReachedEnd];
}

class HomeMoviesCubit extends Cubit<HomeMoviesState> {
  final GetDiscoverMoviesUseCase discoverUseCase;
  final GetHomeSectionsUseCase sectionsUseCase;

  HomeMoviesCubit({required this.discoverUseCase, required this.sectionsUseCase}) : super(HomeMoviesState.initial());

  Future<void> loadInitial() async {
    emit(state.copyWith(isLoading: true, error: null, page: 1, hasReachedEnd: false, discoverMovies: []));

    final sectionsResult = await sectionsUseCase();
    final discoverResult = await discoverUseCase(page: 1);

    if (!discoverResult.isSuccess) {
      emit(state.copyWith(isLoading: false, error: discoverResult.failure?.message ?? 'Error'));
      return;
    }

    final pageData = discoverResult.data!;
    emit(state.copyWith(
      isLoading: false,
      error: null,
      discoverMovies: pageData.results,
      page: pageData.page,
      hasReachedEnd: !pageData.hasMore,
      topRated: sectionsResult.data?.topRated ?? [],
      upcoming: sectionsResult.data?.upcoming ?? [],
    ));
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.isLoading) return;
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;
    final result = await discoverUseCase(page: nextPage);
    if (!result.isSuccess) {
      emit(state.copyWith(isLoadingMore: false, error: result.failure?.message));
      return;
    }

    final pageData = result.data!;
    emit(state.copyWith(
      isLoadingMore: false,
      error: null,
      discoverMovies: [...state.discoverMovies, ...pageData.results],
      page: pageData.page,
      hasReachedEnd: !pageData.hasMore,
    ));
  }
}
