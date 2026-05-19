import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import '../routes/app_routes.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class ApiClient {
  static const String baseUrl = 'http://192.168.137.1:5000';
  static const String accessTokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';

  final Dio _dio;
  final FlutterSecureStorage _storage;
  bool _isRefreshing = false;
  final List<Completer<void>> _refreshQueue = [];

  ApiClient({Dio? dio, FlutterSecureStorage? storage})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 10),
            ),
          ),
      _storage = storage ?? const FlutterSecureStorage() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;
          final isAuthRequest =
              path.startsWith('/auth/login') ||
              path.startsWith('/auth/register') ||
              path.startsWith('/auth/refresh');

          if (!isAuthRequest) {
            try {
              final token = await _storage.read(key: accessTokenKey);
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            } catch (_) {
              // Skip auth header if storage is unavailable.
            }
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final options = error.requestOptions;

          if (statusCode == 401 && options.extra['isRetry'] != true) {
            final refreshToken = await _storage.read(key: refreshTokenKey);
            if (refreshToken == null || refreshToken.isEmpty) {
              handler.next(error);
              return;
            }

            try {
              if (_isRefreshing) {
                final completer = Completer<void>();
                _refreshQueue.add(completer);
                await completer.future;
              } else {
                _isRefreshing = true;
                final tokens = await _refreshTokens(refreshToken);
                await setTokens(
                  accessToken: tokens.accessToken,
                  refreshToken: tokens.refreshToken,
                );
                for (final completer in _refreshQueue) {
                  completer.complete();
                }
                _refreshQueue.clear();
                _isRefreshing = false;
              }

              final newAccessToken = await _storage.read(key: accessTokenKey);
              if (newAccessToken == null || newAccessToken.isEmpty) {
                handler.next(error);
                return;
              }

              options.headers['Authorization'] = 'Bearer $newAccessToken';
              options.extra['isRetry'] = true;
              final response = await _dio.fetch(options);
              handler.resolve(response);
              return;
            } catch (_) {
              await clearTokens();
              Get.offAllNamed(AppRoutes.login);
              handler.next(error);
              return;
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: accessTokenKey, value: accessToken);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  ApiException _handleDioException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final message =
        _extractErrorMessage(response?.data) ??
        error.message ??
        'Request failed';

    switch (statusCode) {
      case 400:
        return ApiException(message, statusCode: 400);
      case 401:
        return ApiException(message, statusCode: 401);
      case 403:
        return ApiException(message, statusCode: 403);
      case 404:
        return ApiException(message, statusCode: 404);
      case 409:
        return ApiException(message, statusCode: 409);
      case 500:
        return ApiException(message, statusCode: 500);
      default:
        return ApiException(message, statusCode: statusCode);
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
    return null;
  }

  Future<_TokenPair> _refreshTokens(String refreshToken) async {
    final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
    final response = await refreshDio.post<Map<String, dynamic>>(
      '/auth/refresh',
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );

    final data = response.data ?? const {};
    final accessToken = data['token'];
    final newRefreshToken = data['refreshToken'] ?? refreshToken;

    if (accessToken is! String || accessToken.isEmpty) {
      throw ApiException('Invalid refresh response', statusCode: 401);
    }
    if (newRefreshToken is! String || newRefreshToken.isEmpty) {
      throw ApiException('Invalid refresh response', statusCode: 401);
    }

    return _TokenPair(accessToken: accessToken, refreshToken: newRefreshToken);
  }
}

class _TokenPair {
  final String accessToken;
  final String refreshToken;

  const _TokenPair({required this.accessToken, required this.refreshToken});
}
