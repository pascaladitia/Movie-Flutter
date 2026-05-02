import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {
  final Dio dio;

  DioClient._(this.dio);

  factory DioClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.tmdbBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters.addAll({'api_key': ApiConstants.apiKey});
          handler.next(options);
        },
      ),
    );

    return DioClient._(dio);
  }
}
