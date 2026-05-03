import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/widgets/app_error_dialog.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../../../../../core/widgets/movie_poster.dart';
import '../../detail/view/movie_detail_page.dart';
import '../cubit/search_movies_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchMoviesCubit>()..loadInitialMovies(),
      child: Builder(builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(l10n.search)),
          body: BlocListener<SearchMoviesCubit, SearchMoviesState>(
            listenWhen: (previous, current) => previous.error != current.error && current.error != null,
            listener: (context, state) => showAppErrorDialog(context, message: state.error!),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l10n.searchHint),
                    onChanged: (v) => context.read<SearchMoviesCubit>().search(v),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SearchMoviesCubit, SearchMoviesState>(
                    builder: (context, state) {
                      if (state.isLoading) return const AppLoading();
                      if (state.movies.isEmpty) {
                        return Center(child: Text(state.isSearchMode ? l10n.noResult : l10n.popularMovies));
                      }
                      return ListView.separated(
                        itemCount: state.movies.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return ListTile(
                            leading: MoviePoster(path: movie.posterPath, width: 50, height: 70),
                            title: Text(movie.title),
                            subtitle: Text('⭐ ${movie.voteAverage.toStringAsFixed(1)}'),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie))),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
