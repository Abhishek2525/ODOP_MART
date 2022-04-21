import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// This [HttpHelper] class is designed for Utilizing
/// and making convenient to use of [Flutter] [http] package.
class HttpHelper {
  /// This method allow to perform [http.get(url)] operation and
  /// returns the response body as [Map]
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic> body,
    Map<String, String> headers,
  }) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(url), headers: headers);

      String s = String.fromCharCodes(response.bodyBytes);

      return json.decode(s);
    } catch (e, t) {
      print(e);
      print(t);
      return null;
    }
  }

  /// This method allow to perform [http.post(url)] operation
  /// and return the response body as a [Map]
  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic> body,
    Map<String, String> headers,
  }) async {
    http.Response response;
    Map<String, String> defaultHeaders = new Map();
    defaultHeaders['Content-Type'] = "application/json";
    defaultHeaders['Accept'] = "application/json";
    if (headers != null) defaultHeaders?.addAll(headers);

    String bodyString = body != null ? json.encode(body) : null;
    try {
      // print(body);

      response = await http.post(
        Uri.parse(url),
        headers: defaultHeaders,
        body: bodyString,
      );
      String s = String.fromCharCodes(response.bodyBytes);

      return json.decode(s);
    } catch (e, t) {
      print(e);
      print(t);
      return null;
    }
  }

  /// This method allow uploading files to the server by using the [Dio] package
  static uploadFile(
    String url, {
    Map<String, dynamic> body,
    Map<String, String> headers,
    File avater,
    File signature,
  }) async {
    Response response;
    Dio dio = new Dio();

    if (headers != null) dio.options.headers.addAll(headers);

    try {
      body = body ?? new Map<String, dynamic>();

      if (avater != null)
        body['img'] = await MultipartFile.fromFile(
          avater?.path,
          filename: avater?.path?.split('/')?.last,
          contentType: MediaType('image', '${avater?.path?.split('.')?.last}'),
        );

      if (signature != null)
        body['signature'] = await MultipartFile.fromFile(
          signature?.path,
          filename: signature?.path?.split('/')?.last,
          contentType:
              MediaType('image', '${signature?.path?.split('.')?.last}'),
        );

      FormData formData = FormData.fromMap(body ?? {});
      response = await dio.post(url, data: formData);

      return response.data;
    } catch (e, t) {
      print(e);
      print(t);
      return null;
    }
  }
}
