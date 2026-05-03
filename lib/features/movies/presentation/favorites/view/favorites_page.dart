import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/widgets/app_error_dialog.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../../../../../core/widgets/movie_poster.dart';
import '../../detail/view/movie_detail_page.dart';
import '../bloc/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoritesCubit>()..load(),
      child: Builder(builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(l10n.favorites)),
          body: BlocListener<FavoritesCubit, FavoritesState>(
            listenWhen: (previous, current) => previous.error != current.error && current.error != null,
            listener: (context, state) => showAppErrorDialog(context, message: state.error!),
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                if (state.isLoading) return const AppLoading();
                if (state.movies.isEmpty) return Center(child: Text(l10n.favoriteEmpty));
                return ListView.separated(
                  itemCount: state.movies.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return ListTile(
                      leading: MoviePoster(path: movie.posterPath, width: 50, height: 70),
                      title: Text(movie.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<FavoritesCubit>().toggle(movie),
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie))),
                    );
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
