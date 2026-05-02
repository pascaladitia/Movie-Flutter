import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
}
