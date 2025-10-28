import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl;

 ApiService(this.baseUrl, {String? token}) {
  _dio.options.baseUrl = dotenv.env['API_URL']!;
  _dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}

  /// 🟢 GET All
  Future<Response> getAll(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// 🔵 GET by ID
  Future<Response> getById(String endpoint, dynamic id) async {
    try {
      final response = await _dio.get('$endpoint/$id');
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// 🟡 POST (Create)
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// 🟠 PUT (Update)
  Future<Response> put(String endpoint, dynamic id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('$endpoint/$id', data: data);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// 🔴 DELETE
  Future<Response> delete(String endpoint, dynamic id) async {
    try {
      final response = await _dio.delete('$endpoint/$id');
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// ⚙️ Error Handler
  String _handleError(DioException error) {
    if (error.response != null) {
      return 'Error ${error.response?.statusCode}: ${error.response?.data}';
    } else {
      return error.message ?? 'Unknown error occurred';
    }
  }
}
