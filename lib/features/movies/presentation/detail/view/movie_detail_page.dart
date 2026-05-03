import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/widgets/app_error_dialog.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../../../../../core/widgets/movie_poster.dart';
import '../../../domain/entities/movie.dart';
import '../../favorites/bloc/favorites_cubit.dart';
import '../bloc/movie_detail_cubit.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  YoutubePlayerController? _youtubeController;
  String? _activeTrailerKey;

  void _syncTrailerController(String? trailerKey) {
    if (trailerKey == null || trailerKey == _activeTrailerKey) return;
    _youtubeController?.close();
    _activeTrailerKey = trailerKey;
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: trailerKey,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MovieDetailCubit>()..load(widget.movie.id)),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..load()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(widget.movie.title)),
        body: BlocListener<MovieDetailCubit, MovieDetailState>(
          listenWhen: (previous, current) => previous.error != current.error && current.error != null,
          listener: (context, state) => showAppErrorDialog(context, message: state.error!),
          child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
            builder: (context, detailState) {
              if (detailState.isLoading) return const AppLoading();

              final trailer = detailState.videos.where((e) => e.site.toLowerCase() == 'youtube').toList();
              final trailerKey = trailer.isNotEmpty ? trailer.first.key : null;
              _syncTrailerController(trailerKey);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(child: MoviePoster(path: widget.movie.posterPath, width: 180, height: 260)),
                  const SizedBox(height: 16),
                  Text('⭐ ${widget.movie.voteAverage.toStringAsFixed(1)}   ${widget.movie.releaseDate}'),
                  const SizedBox(height: 12),
                  Text(l10n.overview, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(widget.movie.overview),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.read<FavoritesCubit>().toggle(widget.movie),
                    icon: const Icon(Icons.favorite),
                    label: Text(l10n.favorites),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.trailers, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (trailerKey == null || _youtubeController == null)
                    Text(l10n.noTrailer)
                  else
                    YoutubePlayer(controller: _youtubeController!, aspectRatio: 16 / 9),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
