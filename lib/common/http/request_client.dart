import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'header_interceptor.dart';
import 'network_config.dart';

class RequestClient {
  late Dio _dio;
  static final RequestClient _singletonRequestClient = RequestClient._internal();

  factory RequestClient() {
    return _singletonRequestClient;
  }

  RequestClient._internal() {
    ///初始化 dio 配置
    var options = BaseOptions(
        baseUrl: 'NetWorkConfig.baseUrl',
        connectTimeout: const Duration(milliseconds: NetWorkConfig.connectTimeOut),
        receiveTimeout: const Duration(milliseconds: NetWorkConfig.readTimeOut),
        sendTimeout: const Duration(milliseconds: NetWorkConfig.writeTimeOut));
    _dio = Dio(options);
    _dio.interceptors.add(HeaderInterceptor());
    _dio.interceptors.add(PrettyDioLogger(
      // 添加日志格式化工具类
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
  }

  /// dio 本身提供了get 、post 、put 、delete 等一系列 http 请求方法,最终都是调用request,直接封装request就行
  Future<T?> request<T>(
    String url, {
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      Options options = Options()
        ..method = method
        ..headers = headers;

      data = _convertRequestData(data);
      Response response = await _dio.request(url, queryParameters: queryParameters, data: data, options: options, cancelToken: cancelToken);
      print('request===catch====${response.data}');
      // TODO 拿到数据后如何处理！待定
    } catch (e) {
      String errorMsg = '';
      print('request===catch====$errorMsg');
    }
    return null;
  }

  ///将请求 data 数据先使用 jsonEncode 转换为字符串，再使用 jsonDecode 方法将字符串转换为 Map。
  _convertRequestData(data) {
    if (data != null) {
      data = jsonDecode(jsonEncode(data));
    }
    return data;
  }

  Future<T?> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool? showLoading,
    Function(T)? onSuccess,
    CancelToken? cancelToken,
  }) {
    return request(url, method: "Get", queryParameters: queryParameters, headers: headers, cancelToken: cancelToken);
  }

  Future<T?> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool? showLoading = true,
  }) {
    return request(url, method: "POST", queryParameters: queryParameters, data: data, headers: headers);
  }

  Future<T?> delete<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
  }) {
    return request(
      url,
      method: "DELETE",
      queryParameters: queryParameters,
      data: data,
      headers: headers,
    );
  }

  Future<T?> put<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
  }) {
    return request(
      url,
      method: "PUT",
      queryParameters: queryParameters,
      data: data,
      headers: headers,
    );
  }
}

class RawData {
  dynamic value;
}
