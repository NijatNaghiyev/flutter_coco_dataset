import 'package:dio/dio.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkService {
  NetworkService();

  /// DIO Service
  Future<Dio> _createDioService(
    HttpMethodName method, {
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType = ResponseType.json,
  }) async {
    return Dio(
        BaseOptions(
          responseType: responseType,
          baseUrl: baseUrl ?? '',
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
          contentType: Headers.jsonContentType,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          method: method.value,
          queryParameters: queryParameters,
        ),
      )
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          maxWidth: 150,
        ),
      );
  }

  /// Request method
  Future<Response<dynamic>> _request(
    HttpMethodName method, {
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic postData,
    Options? options,
    String? savePath,
    ResponseType? responseType,
  }) async {
    final dio = await _createDioService(
      HttpMethodName.get,
      responseType: responseType,
      baseUrl: baseUrl,
    );



    if (headers != null) {
      dio.options.headers.addAll(headers);
    }

    if (options != null) {
      if (options.headers != null) {
        options.headers!.addAll(headers ?? {});
      } else {
        options.headers = headers;
      }
    } else {
      options = Options(headers: headers);
    }

    switch (method) {
      case HttpMethodName.get:
        return dio.get(
          path,
          queryParameters: queryParameters,
          data: postData,
          options: options,
        );
      case HttpMethodName.post:
        return dio.post(
          path,
          queryParameters: queryParameters,
          data: postData,
          options: options,
        );
      case HttpMethodName.put:
        return dio.put(
          path,
          queryParameters: queryParameters,
          data: postData,
          options: options,
        );
      case HttpMethodName.patch:
        return dio.patch(
          path,
          queryParameters: queryParameters,
          data: postData,
          options: options,
        );
      case HttpMethodName.delete:
        return dio.delete(
          path,
          queryParameters: queryParameters,
          data: postData,
          options: options,
        );
      case HttpMethodName.download:
        return dio.download(
          path,
          savePath ?? '',
          queryParameters: queryParameters,
          data: postData,
          options: options,
        );
    }
  }

  ///? HTTP GET
  Future<Response<dynamic>> get({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? postData,
    Options? options,
    ResponseType? responseType,
  }) {
    return _request(
      HttpMethodName.get,
      path: path,
      baseUrl: baseUrl,
      queryParameters: queryParameters,
      headers: headers,
      postData: postData,
      options: options,
      responseType: responseType,
    );
  }

  ///? HTTP POST
  Future<Response<dynamic>> post({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic postData,
    Options? options,
    ResponseType? responseType,
  }) {
    return _request(
      HttpMethodName.post,
      path: path,
      baseUrl: baseUrl,
      queryParameters: queryParameters,
      headers: headers,
      postData: postData,
      options: options,
      responseType: responseType,
    );
  }

  ///? HTTP PUT
  Future<Response<dynamic>> put({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? postData,
    Options? options,
    ResponseType? responseType,
  }) {
    return _request(
      HttpMethodName.put,
      path: path,
      baseUrl: baseUrl,
      queryParameters: queryParameters,
      headers: headers,
      postData: postData,
      options: options,
      responseType: responseType,
    );
  }

  ///? HTTP PATCH
  Future<Response<dynamic>> patch({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic postData,
    Options? options,
    ResponseType? responseType,
  }) {
    return _request(
      HttpMethodName.patch,
      path: path,
      baseUrl: baseUrl,
      queryParameters: queryParameters,
      headers: headers,
      postData: postData,
      options: options,
      responseType: responseType,
    );
  }

  ///? HTTP DELETE
  Future<Response<dynamic>> delete({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? postData,
    Options? options,
    ResponseType? responseType,
  }) {
    return _request(
      HttpMethodName.delete,
      path: path,
      baseUrl: baseUrl,
      queryParameters: queryParameters,
      headers: headers,
      postData: postData,
      options: options,
      responseType: responseType,
    );
  }

  ///? HTTP DOWNLOAD
  Future<Response<dynamic>> download({
    required String path,
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? postData,
    Options? options,
    String? savePath,
    ResponseType? responseType,
  }) {
    return _request(
      HttpMethodName.download,
      path: path,
      savePath: savePath,
      baseUrl: baseUrl,
      queryParameters: queryParameters,
      headers: headers,
      postData: postData,
      options: options,
      responseType: responseType,
    );
  }
}

enum HttpMethodName {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  download('DOWNLOAD');

  final String value;

  const HttpMethodName(this.value);
}
