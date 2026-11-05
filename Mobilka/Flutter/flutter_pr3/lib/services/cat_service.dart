import 'package:dio/dio.dart';
import '../models/cat_breed.dart';

class CatService {
  CatService(this._dio);
  final Dio _dio;

  Future<List<CatBreed>> fetchBreeds({String? name}) async {
    final query = (name == null || name.trim().isEmpty) ? 'a' : name.trim();
    try {
      final response = await _dio.get(
        'cats',
        queryParameters: {'name': query},
      );
      final data = response.data;
      if (data is! List) {
        throw const FormatException('API вернул неожиданный формат данных.');
      }
      return data
          .whereType<Map<String, dynamic>>()
          .map(CatBreed.fromJson)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      final apiMessage = body is Map ? body['error']?.toString() : null;

      if (status == 400) {
        throw Exception(
          apiMessage == null
              ? 'API отклонил параметры запроса. Проверьте параметры Cats API.'
              : 'Ошибка API (400): $apiMessage',
        );
      }
      if (status == 401 || status == 403) {
        throw Exception('API-ключ не принят. Проверьте ключ API Ninjas.');
      }
      if (status == 429) {
        throw Exception('Лимит запросов исчерпан. Попробуйте позже.');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Сервер отвечает слишком долго. Проверьте соединение.');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Не удалось подключиться к API. Проверьте интернет-соединение.');
      }
      throw Exception(apiMessage ?? e.message ?? 'Не удалось загрузить породы кошек.');
    }
  }
}
