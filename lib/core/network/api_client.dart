import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio _dio;
  
  ApiClient(): _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('Falha na requisição: $e');
    }
  }
} 