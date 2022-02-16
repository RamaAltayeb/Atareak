import 'dart:convert';
import 'package:atareak/controllers/internet_connection_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';

class NetworkHandler {
  // Server URL
  final String _baseURL = 'http://xxx.xxx.xx.xx';
  static final _logger = Logger();
  final timeOutDuration = const Duration(seconds: 60);
  final noInternetResponse = http.Response('No Internet Connection', 500);
  final timeOutResponse = http.Response('Connection Time Out', 500);

  final InternetConnectionController _internetConnectionController =
      Get.put(InternetConnectionController());

  Future<http.Response> get(String url,
      [Map<String, dynamic> queryParameters = const {}]) async {
    if (!await _internetConnectionController.checkInternetConnection()) {
      return noInternetResponse;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String queryString = Uri(queryParameters: queryParameters).query;
    if (queryString.isNotEmpty) {
      url += '?$queryString';
    }
    final response = await http.get(
      _urlParser(url),
      headers: {
        'Authorization': 'Bearer ${prefs.getString(PrefKeys.userToken)}'
      },
    ).timeout(
      timeOutDuration,
      onTimeout: () {
        return timeOutResponse;
      },
    );

    loggerResponsePrinter(response);

    return response;
  }

  Future<http.Response> delete(String url,
      [Map<String, dynamic> body = const {}]) async {
    if (!await _internetConnectionController.checkInternetConnection()) {
      return noInternetResponse;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http
        .delete(
      _urlParser(url),
      headers: {
        'Authorization': 'Bearer ${prefs.getString(PrefKeys.userToken)}'
      },
      body: json.encode(body),
    )
        .timeout(
      timeOutDuration,
      onTimeout: () {
        return timeOutResponse;
      },
    );

    loggerResponsePrinter(response);

    return response;
  }

  Future<http.Response> post(String url,
      [Map<String, dynamic> body = const {}]) async {
    if (!await _internetConnectionController.checkInternetConnection()) {
      return noInternetResponse;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http
        .post(
      _urlParser(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString(PrefKeys.userToken)}'
      },
      body: json.encode(body),
    )
        .timeout(
      timeOutDuration,
      onTimeout: () {
        return timeOutResponse;
      },
    );

    loggerResponsePrinter(response);

    return response;
  }

  Future<dynamic> multiPartRequestPost(String url, Map<String, String> fields,
      Map<String, dynamic> multi) async {
    if (!await _internetConnectionController.checkInternetConnection()) {
      return noInternetResponse;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final request = http.MultipartRequest('POST', _urlParser(url));
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Authorization': 'Bearer ${prefs.getString(PrefKeys.userToken)}'
    });
    request.fields.addAll(fields);
    for (final String key in multi.keys) {
      if (multi[key] != null) {
        request.files.add(await http.MultipartFile.fromPath(key, multi[key]));
      }
    }
    final http.Response response =
        await http.Response.fromStream(await request.send()).timeout(
      timeOutDuration,
      onTimeout: () {
        return timeOutResponse;
      },
    );

    loggerResponsePrinter(response);

    return response;
  }

  Uri _urlParser(String url) {
    _logger.i('Uri: ${Uri.parse(_baseURL + url)}');
    return Uri.parse(_baseURL + url);
  }

  static void loggerResponsePrinter(http.Response response) {
    final String result =
        'statusCode: ${response.statusCode} \nreasonPhrase: ${response.reasonPhrase} \nbody: ${response.body}';
    if (response.statusCode == 200 || response.statusCode == 201) {
      _logger.i(result);
    } else {
      _logger.w(result);
    }
  }
}
