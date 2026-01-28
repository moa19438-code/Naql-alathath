import 'package:dio/dio.dart';
import '../result/app_error.dart';
import '../result/result.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    String? token,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {
              if (token != null) 'Authorization': 'Bearer $token',
            },
          ),
        );

  Dio get dio => _dio;

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic data)? map,
  }) async {
    try {
      final r = await _dio.get(path, queryParameters: query);
      final data = map != null ? map(r.data) : r.data as T;
      return Ok<T>(data);
    } on DioException catch (e) {
      return Err<T>(_mapDioError(e));
    } catch (e) {
      return Err<T>(AppError('Unexpected error', cause: e));
    }
  }

  AppError _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    final msg = switch (status) {
      400 => 'Bad request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not found',
      500 => 'Server error',
      _ => 'Network error',
    };
    return AppError(msg, code: status?.toString(), cause: e);
  }
}
