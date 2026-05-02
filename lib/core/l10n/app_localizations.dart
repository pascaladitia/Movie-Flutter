import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('id')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'home': 'Home', 'search': 'Search', 'favorites': 'Favorites', 'settings': 'Settings',
      'popularMovies': 'Popular Movies', 'topRatedMovies': 'Top Rated Movies', 'upcomingMovies': 'Upcoming Movies',
      'retry': 'Retry', 'overview': 'Overview', 'trailers': 'Trailers', 'noTrailer': 'No trailer available',
      'searchHint': 'Search movie title...', 'noResult': 'No result found',
      'theme': 'Theme', 'language': 'Language', 'system': 'System', 'light': 'Light', 'dark': 'Dark',
      'addedToFavorite': 'Added to favorite', 'removedFromFavorite': 'Removed from favorite',
      'favoriteEmpty': 'No favorite movie yet',
    },
    'id': {
      'home': 'Beranda', 'search': 'Cari', 'favorites': 'Favorit', 'settings': 'Pengaturan',
      'popularMovies': 'Film Populer', 'topRatedMovies': 'Film Rating Tinggi', 'upcomingMovies': 'Film Mendatang',
      'retry': 'Coba Lagi', 'overview': 'Ringkasan', 'trailers': 'Trailer', 'noTrailer': 'Trailer tidak tersedia',
      'searchHint': 'Cari judul film...', 'noResult': 'Tidak ada hasil',
      'theme': 'Tema', 'language': 'Bahasa', 'system': 'Sistem', 'light': 'Terang', 'dark': 'Gelap',
      'addedToFavorite': 'Ditambahkan ke favorit', 'removedFromFavorite': 'Dihapus dari favorit',
      'favoriteEmpty': 'Belum ada film favorit',
    },
  };

  String _t(String key) => _localizedValues[locale.languageCode]![key] ?? key;

  String get home => _t('home');
  String get search => _t('search');
  String get favorites => _t('favorites');
  String get settings => _t('settings');
  String get popularMovies => _t('popularMovies');
  String get topRatedMovies => _t('topRatedMovies');
  String get upcomingMovies => _t('upcomingMovies');
  String get retry => _t('retry');
  String get overview => _t('overview');
  String get trailers => _t('trailers');
  String get noTrailer => _t('noTrailer');
  String get searchHint => _t('searchHint');
  String get noResult => _t('noResult');
  String get theme => _t('theme');
  String get language => _t('language');
  String get system => _t('system');
  String get light => _t('light');
  String get dark => _t('dark');
  String get addedToFavorite => _t('addedToFavorite');
  String get removedFromFavorite => _t('removedFromFavorite');
  String get favoriteEmpty => _t('favoriteEmpty');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
