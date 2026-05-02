import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/widgets/movie_poster.dart';
import '../../../domain/entities/movie.dart';
import '../../detail/view/movie_detail_page.dart';
import '../bloc/home_movies_cubit.dart';
import '../widgets/horizontal_movie_strip.dart';
import '../widgets/section_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 500) {
      context.read<HomeMoviesCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _openDetail(Movie movie) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeMoviesCubit>()..loadInitial(),
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () => context.read<HomeMoviesCubit>().loadInitial(),
              child: BlocBuilder<HomeMoviesCubit, HomeMoviesState>(
                builder: (context, state) {
                  if (state.isLoading) return const Center(child: CircularProgressIndicator());
                  if (state.error != null && state.discoverMovies.isEmpty) {
                    return ListView(children: [const SizedBox(height: 180), Center(child: Text(state.error!))]);
                  }

                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar.large(
                        pinned: true,
                        title: const Text('Movie App'),
                        flexibleSpace: FlexibleSpaceBar(
                          background: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primaryContainer,
                                  Theme.of(context).colorScheme.surface,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SectionTitle(title: l10n.topRatedMovies)),
                      SliverToBoxAdapter(
                        child: HorizontalMovieStrip(movies: state.topRated, onTapMovie: _openDetail),
                      ),
                      SliverToBoxAdapter(child: SectionTitle(title: l10n.upcomingMovies)),
                      SliverToBoxAdapter(
                        child: HorizontalMovieStrip(movies: state.upcoming, onTapMovie: _openDetail),
                      ),
                      SliverToBoxAdapter(child: SectionTitle(title: l10n.popularMovies)),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final movie = state.discoverMovies[index];
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _openDetail(movie),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SizedBox.expand(
                                        child: MoviePoster(path: movie.posterPath, width: double.infinity, height: double.infinity),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, childCount: state.discoverMovies.length),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.62,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Center(child: state.isLoadingMore ? const CircularProgressIndicator() : const SizedBox.shrink()),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
