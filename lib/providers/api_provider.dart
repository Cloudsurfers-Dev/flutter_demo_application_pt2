import 'package:demo_application/models/auth_request.dart';
import 'package:demo_application/models/auth_response.dart';
import 'package:demo_application/models/item_response.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'auth_provider.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'http://api.demo';

  ApiProvider() {
    addInterceptors();
  }

  addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) => requestInterceptor(options, handler),
        onResponse: (response, handler) =>
            responseInterceptor(response, handler),
        onError: (dioError, handler) => errorInterceptor(dioError, handler)));
  }

  dynamic requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = GetIt.I<AuthProvider>().token;
    if (token != null) {
      options.headers.addAll({
        'token': token,
      });
    }
    handler.next(options);
  }

  dynamic responseInterceptor(
      Response response, ResponseInterceptorHandler handler) async {
    handler.next(response);
  }

  dynamic errorInterceptor(
      DioError error, ErrorInterceptorHandler handler) async {
    handler.next(error);
  }

  Future<AuthResponse?> auth(AuthRequest request) async {
    try {
      Response response = await _dio.post('$_url/api/auth', data: request);
      return AuthResponse.fromJson(response.data);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<ItemResponse>?> items() async {
    try {
      Response response = await _dio.get('$_url/api/items');
      return List<ItemResponse>.from(
          response.data?.map((data) => ItemResponse.fromJson(data)));
    } catch (error) {
      print(error);
      return null;
    }
  }
}
