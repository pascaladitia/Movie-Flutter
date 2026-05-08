import 'package:flutter/material.dart';

import '../../../../../core/widgets/movie_poster.dart';
import '../../../domain/entities/movie.dart';

class HorizontalMovieStrip extends StatelessWidget {
  final List<Movie> movies;
  final void Function(Movie movie) onTapMovie;

  const HorizontalMovieStrip({super.key, required this.movies, required this.onTapMovie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return SizedBox(
            width: 140,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onTapMovie(movie),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoviePoster(path: movie.posterPath, width: 140, height: 190),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount: movies.length,
      ),
    );
  }
}
