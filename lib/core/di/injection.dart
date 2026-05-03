import 'package:get_it/get_it.dart';

import '../../features/movies/data/datasources/favorites_local_data_source.dart';
import '../../features/movies/data/datasources/movies_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/favorites_usecases.dart';
import '../../features/movies/domain/usecases/get_discover_movies_usecase.dart';
import '../../features/movies/domain/usecases/get_home_sections_usecase.dart';
import '../../features/movies/domain/usecases/get_movie_videos_usecase.dart';
import '../../features/movies/domain/usecases/search_movies_usecase.dart';
import '../../features/movies/presentation/detail/cubit/movie_detail_cubit.dart';
import '../../features/movies/presentation/favorites/cubit/favorites_cubit.dart';
import '../../features/movies/presentation/home/cubit/home_movies_cubit.dart';
import '../../features/movies/presentation/search/cubit/search_movies_cubit.dart';
import '../../features/profile/data/profile_local_data_source.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';
import '../network/dio_client.dart';
import '../storage/prefs_manager.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton(() => DioClient.create().dio);
  sl.registerLazySingleton(() => PrefsManager());
  sl.registerLazySingleton(() => SettingsCubit(sl()));
  sl.registerLazySingleton(() => MoviesRemoteDataSource(sl()));
  sl.registerLazySingleton(() => FavoritesLocalDataSource());
  sl.registerLazySingleton(() => ProfileLocalDataSource());

  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(remote: sl(), local: sl()));

  sl.registerLazySingleton(() => GetDiscoverMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetHomeSectionsUseCase(sl()));
  sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieVideosUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoriteMoviesUseCase(sl()));
  sl.registerLazySingleton(() => AddFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => IsFavoriteUseCase(sl()));

  sl.registerFactory(() => HomeMoviesCubit(discoverUseCase: sl(), sectionsUseCase: sl()));
  sl.registerFactory(() => SearchMoviesCubit(sl(), sl()));
  sl.registerFactory(() => FavoritesCubit(getFavorites: sl(), addFavorite: sl(), removeFavorite: sl()));
  sl.registerFactory(() => MovieDetailCubit(getVideos: sl(), isFavoriteUseCase: sl()));
  sl.registerFactory(() => DetailFavoriteCubit(addFavorite: sl(), removeFavorite: sl(), isFavorite: sl()));
}
