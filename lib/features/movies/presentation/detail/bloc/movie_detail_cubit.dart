import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/video_item.dart';
import '../../../domain/usecases/favorites_usecases.dart';
import '../../../domain/usecases/get_movie_videos_usecase.dart';

class MovieDetailState extends Equatable {
  final bool isLoading;
  final List<VideoItem> videos;
  final bool isFavorite;
  final String? error;

  const MovieDetailState({required this.isLoading, required this.videos, required this.isFavorite, required this.error});

  factory MovieDetailState.initial() => const MovieDetailState(isLoading: false, videos: [], isFavorite: false, error: null);

  MovieDetailState copyWith({bool? isLoading, List<VideoItem>? videos, bool? isFavorite, String? error}) {
    return MovieDetailState(
      isLoading: isLoading ?? this.isLoading,
      videos: videos ?? this.videos,
      isFavorite: isFavorite ?? this.isFavorite,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, videos, isFavorite, error];
}

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieVideosUseCase getVideos;
  final IsFavoriteUseCase isFavoriteUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;

  MovieDetailCubit({
    required this.getVideos,
    required this.isFavoriteUseCase,
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
  }) : super(MovieDetailState.initial());

  Future<void> load(int movieId) async {
    emit(state.copyWith(isLoading: true, error: null));
    final videosResult = await getVideos(movieId);
    final favoriteResult = await isFavoriteUseCase(movieId);

    emit(state.copyWith(
      isLoading: false,
      videos: videosResult.data ?? [],
      isFavorite: favoriteResult.data ?? false,
      error: videosResult.failure?.message,
    ));
  }
}
