import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// A class responsible for handling API requests using the Dio package.
class DataProvider {
  // BaseOptions allows us to configure Dio globally.
  static final BaseOptions _options = BaseOptions(
    sendTimeout: const Duration(milliseconds: 30000),// Set send timeout to 30 seconds
    receiveTimeout: const Duration(milliseconds: 30000),// Set receive timeout to 30 seconds
  );

  // Dio instance for making HTTP requests.
  final Dio _dio;

  /// Constructor: Initializes Dio with base options and handles certificate validation for non-web platforms.
  DataProvider() : _dio = Dio(_options) {
    //TODO: comment off interceptors if you don't want to log dio requests
    // _dio.interceptors.add(LogInterceptor(responseBody: true));
    //TODO: interceptor ends here
    if (!kIsWeb) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final HttpClient client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
  }


  /// A method to fetch data from an API.
  ///
  /// Parameters:
  /// - [method]: The HTTP method (GET, POST, PUT, DELETE, etc.).
  /// - [url]: The API endpoint to call.
  /// - [data]: Optional request body (for POST/PUT requests).
  /// - [query]: Optional query parameters.
  /// - [header]: Optional custom headers.
  ///
  /// Returns:
  /// - A `Response` object if the request is successful.
  /// - A `null` value or an error response if the request fails.
  Future<Response<dynamic>?> fetchData(
      String method,
      String url, {
        dynamic data,
        dynamic query,
        dynamic header,
      }) async {
    try {
      DateTime startTime = DateTime.now();
      Response response = await _dio.request(
        url,
        data: data,
        queryParameters: query,
        options: Options(
          headers: header,
          method: method.toUpperCase(),
        ),
      );


      DateTime endTime = DateTime.now();
      Duration diff = endTime.difference(startTime);

      if (kDebugMode) {
        print("$url: ${diff.inMilliseconds} Milliseconds");
      }

      return response;
    } on DioException catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
      return exception.response;
    }
  }
}