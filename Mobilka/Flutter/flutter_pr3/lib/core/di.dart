import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';
import 'token_interceptor.dart';
import '../services/cat_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);

  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 15),
    responseType: ResponseType.json,
    headers: {'Accept': 'application/json'},
  ));

  dio.interceptors.add(TokenInterceptor(token: ApiConfig.apiKey));
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: false,
    responseHeader: false,
    responseBody: true,
    error: true,
    compact: true,
    maxWidth: 100,
  ));

  getIt.registerSingleton<Dio>(dio);
  getIt.registerLazySingleton<CatService>(() => CatService(getIt<Dio>()));
}
