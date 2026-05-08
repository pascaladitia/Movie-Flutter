import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/theme/app_theme_extensions.dart';
import '../../../../../core/widgets/app_error_dialog.dart';
import '../../../../../core/widgets/app_loading.dart';
import '../../../../../core/widgets/movie_poster.dart';
import '../../../domain/entities/movie.dart';
import '../../detail/view/movie_detail_page.dart';
import '../cubit/home_movies_cubit.dart';
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
          final colors = Theme.of(context).colorScheme;
          return Scaffold(
            backgroundColor: colors.surface,
            body: RefreshIndicator(
              onRefresh: () => context.read<HomeMoviesCubit>().loadInitial(),
              child: BlocListener<HomeMoviesCubit, HomeMoviesState>(
                listenWhen: (previous, current) => previous.error != current.error && current.error != null,
                listener: (context, state) => showAppErrorDialog(context, message: state.error!),
                child: BlocBuilder<HomeMoviesCubit, HomeMoviesState>(
                  builder: (context, state) {
                    if (state.isLoading) return const AppLoading();
                    if (state.error != null && state.discoverMovies.isEmpty) {
                      return ListView(children: [const SizedBox(height: 180), Center(child: Text(state.error!))]);
                    }

                    return ListView(
                      controller: _scrollController,
                      children: [
                        TopRatedHeroCarousel(
                          movies: state.topRated,
                          onTapMovie: _openDetail,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              SectionTitle(title: l10n.upcomingMovies),
                              HorizontalMovieStrip(movies: state.upcoming, onTapMovie: _openDetail),
                              SectionTitle(title: l10n.popularMovies),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.discoverMovies.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.62,
                                  ),
                                  itemBuilder: (context, index) {
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
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Center(
                            child: state.isLoadingMore
                                ? const CircularProgressIndicator()
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopRatedHeroCarousel extends StatefulWidget {
  final List<Movie> movies;
  final void Function(Movie movie) onTapMovie;

  const TopRatedHeroCarousel({
    super.key,
    required this.movies,
    required this.onTapMovie,
  });

  @override
  State<TopRatedHeroCarousel> createState() => _TopRatedHeroCarouselState();
}

class _TopRatedHeroCarouselState extends State<TopRatedHeroCarousel> {
  late final PageController _pageController;
  Timer? _autoTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.movies.length < 2 || !_pageController.hasClients) return;
      final nextIndex = (_currentPage + 1) % widget.movies.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didUpdateWidget(covariant TopRatedHeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.movies.length != oldWidget.movies.length) {
      _currentPage = 0;
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<AppCustomColors>()!;
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.52,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.movies.length,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              return InkWell(
                onTap: () => widget.onTapMovie(movie),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MoviePoster(
                      path: movie.posterPath,
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 0,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            customColors.imageOverlayTop,
                            customColors.imageOverlayBottom,
                          ],
                          stops: const [0.35, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 26,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: customColors.onImageText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${movie.releaseDate}  •  ⭐ ${movie.voteAverage.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: customColors.onImageSubtleText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: customColors.onImageSubtleText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            right: 20,
            bottom: 14,
            child: Row(
              children: List.generate(
                widget.movies.length > 4 ? 4 : widget.movies.length,
                (dotIndex) {
                  final activeIndex = _currentPage % (widget.movies.length > 4 ? 4 : widget.movies.length);
                  return Container(
                    width: dotIndex == activeIndex ? 22 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: dotIndex == activeIndex
                          ? Theme.of(context).colorScheme.primary
                          : customColors.indicatorInactive,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
