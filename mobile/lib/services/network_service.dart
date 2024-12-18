import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/services/secure_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NetworkService {
  final JsonDecoder _decoder = const JsonDecoder();
  final JsonEncoder _encoder = const JsonEncoder();

  Map<String, String> headers = {"content-type": "application/json"};
  Map<String, String> cookies = {};

  static final NetworkService _instance = NetworkService();

  static void setToken(String token) {
    _instance.headers["Authorization"] = "Bearer $token";
  }

  static Future<dynamic> get(String url,
      {Map<String, String>? customHeaders}) async {
    if (await isTokenExpired()) {
      renewToken();
    }
    final allHeaders = {..._instance.headers, ...?customHeaders};
    return http
        .get(Uri.parse(url), headers: allHeaders)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print('Response body: $res');

      _updateCookie(response);
      if (statusCode == 403) {
        SecureStorageService.deleteAll();
        throw Exception("Unauthorized access (403)");
      }

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data $statusCode");
      }
      return _instance._decoder.convert(res);
    });
  }

  static Future<dynamic> postMultipart(
    String url, {
    Map<String, String>? customHeaders,
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    if (await isTokenExpired()) {
      renewToken();
    }

    final allHeaders = {..._instance.headers, ...?customHeaders};

    try {
      // Buat multipart request
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(allHeaders);

      // Tambahkan fields (data lain selain file)
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Tambahkan file
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key, // Nama field sesuai backend
              entry.value.path,
            ),
          );
        }
      }

      // Kirim request dan dapatkan respons
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 20));
      final response = await http.Response.fromStream(streamedResponse);

      final String res = response.body;
      final int statusCode = response.statusCode;
      print('Response body: $res');

      _updateCookie(response);

      // Tangani status kode
      if (statusCode == 403) {
        SecureStorageService.deleteAll();
        throw Exception("Unauthorized access (403)");
      }

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data $statusCode");
      }

      // Decode respons JSON
      return _instance._decoder.convert(res);
    } catch (e) {
      throw Exception("Multipart request failed: $e");
    }
  }

  static Future<dynamic> post(String url,
      {body, encoding, Map<String, String>? customHeaders}) async {
    if (await isTokenExpired()) {
      renewToken();
    }
    final allHeaders = {..._instance.headers, ...?customHeaders};
    return http
        .post(Uri.parse(url),
            body: _instance._encoder.convert(body),
            headers: allHeaders,
            encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);
      print(res);

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return _instance._decoder.convert(res);
    });
  }

  static Future<dynamic> delete(String url,
      {Map<String, String>? customHeaders}) async {
    if (await isTokenExpired()) {
      renewToken();
    }
    final allHeaders = {..._instance.headers, ...?customHeaders};
    return http
        .delete(Uri.parse(url), headers: allHeaders)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return _instance._decoder.convert(res);
    });
  }

  static Future<dynamic> patch(String url,
      {body, encoding, Map<String, String>? customHeaders}) async {
    if (await isTokenExpired()) {
      renewToken();
    }
    final allHeaders = {..._instance.headers, ...?customHeaders};
    return http
        .patch(Uri.parse(url),
            body: _instance._encoder.convert(body),
            headers: allHeaders,
            encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);
      print('Response body: $res');

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while patching data");
      }
      return _instance._decoder.convert(res);
    });
  }

  static Future<bool> isTokenExpired() async {
    final authorization = _instance.headers["Authorization"];
    final token = await SecureStorageService.read("jwt_token");
    final refreshToken = await SecureStorageService.read("jwt_refresh_token");
    if (authorization != null && token != null && refreshToken != null) {
      final token = authorization.split(" ")[1];
      return JwtDecoder.isExpired(token);
    } else {
      return false;
    }
  }

  static void renewToken() async {
    final uri = Uri.http(ipAddress, "api/renew-token");
    final token_refresh = await SecureStorageService.read("jwt_refresh_token");
    final res = await http.post(uri, body: {
      'refres_token': token_refresh,
    });

    if (res.statusCode == 403) {
      throw Exception("Unauthorized access (403)");
    }

    if (res.statusCode < 200 || res.statusCode > 400) {
      throw Exception("Error while patching data");
    }

    final body = _instance._decoder.convert(res.body);
    if (body['success']) {
      final token = body['data']['token'];
      final refreshToken = body['data']['token_refresh'];
      SecureStorageService.write("jwt_token", token);
      SecureStorageService.write("jwt_refresh_token", refreshToken);
      _instance.headers["Authorization"] = "Bearer $token";
    } else {
      print("Failed to renew token: ${body['message']}");
    }
  }

  static void _updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      _instance.headers['cookie'] = _generateCookieHeader();
    }
  }

  static void _setCookie(String? rawCookie) {
    if (rawCookie != null) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        _instance.cookies[key] = value;
      }
    }
  }

  static String _generateCookieHeader() {
    String cookie = "";

    for (var key in _instance.cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";
      //cookie += key + "=" + cookies[key]!;
      cookie += "$key = ${_instance.cookies[key]}";
    }

    return cookie;
  }
}
