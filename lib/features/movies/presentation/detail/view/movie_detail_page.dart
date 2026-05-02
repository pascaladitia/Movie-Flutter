import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/widgets/movie_poster.dart';
import '../../../domain/entities/movie.dart';
import '../../favorites/bloc/favorites_cubit.dart';
import '../bloc/movie_detail_cubit.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MovieDetailCubit>()..load(movie.id)),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..load()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(movie.title)),
        body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, detailState) {
            final trailer = detailState.videos.where((e) => e.site.toLowerCase() == 'youtube').toList();
            final trailerKey = trailer.isNotEmpty ? trailer.first.key : null;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(child: MoviePoster(path: movie.posterPath, width: 180, height: 260)),
                const SizedBox(height: 16),
                Text('⭐ ${movie.voteAverage.toStringAsFixed(1)}   ${movie.releaseDate}'),
                const SizedBox(height: 12),
                Text(l10n.overview, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(movie.overview),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => context.read<FavoritesCubit>().toggle(movie),
                  icon: const Icon(Icons.favorite),
                  label: Text(l10n.favorites),
                ),
                const SizedBox(height: 20),
                Text(l10n.trailers, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (trailerKey == null)
                  Text(l10n.noTrailer)
                else
                  YoutubePlayer(
                    controller: YoutubePlayerController.fromVideoId(
                      videoId: trailerKey,
                      autoPlay: false,
                      params: const YoutubePlayerParams(showFullscreenButton: true),
                    ),
                    aspectRatio: 16 / 9,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
