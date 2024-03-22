import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/store.dart';

class ApiClient {
  late Dio dio;
  final UserManager userManager = UserManager();

  ApiClient() {
    dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    dio.options.headers['Content-Type'] = 'application/json';
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final jwtToken = await userManager.jwtToken;

      if (jwtToken != null) {
        options.headers["Authorization"] = "Bearer $jwtToken";
      }
      return handler.next(options);
    }));
  }

// GET 요청
  Future<Response> get(String path, {dynamic queryParameters}) async {
    return dio.get(path, queryParameters: queryParameters);
  }

  // POST 요청
  Future<Response> post(String path, {dynamic data}) async {
    return dio.post(path, data: data);
  }

  // PUT 요청
  Future<Response> put(String path, {dynamic data}) async {
    return dio.put(path, data: data);
  }

  // DELETE 요청
  Future<Response> delete(String path, {dynamic data}) async {
    return dio.delete(path, data: data);
  }
}
