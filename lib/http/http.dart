import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/utils/server_config.dart';
import 'package:http_parser/http_parser.dart';

// Singleton class to ensure only once http client is working on the application

class HttpClient {
  HttpClient._privateConstructor();

  static final HttpClient _instance = HttpClient._privateConstructor();

  factory HttpClient() {
    return _instance;
  }

  Future<Map<String, dynamic>> get({
    required String path,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, dynamic>> post({
    required String path,
    required dynamic body,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: await _getHeaders(),
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, dynamic>> put({
    required String path,
    required dynamic body,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.put(
      url,
      body: jsonEncode(body),
      headers: await _getHeaders(),
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, dynamic>> delete({
    required String path,
  }) async {
    var url = Uri.parse(serverUrl + path);
    var response = await http.delete(
      url,
      headers: await _getHeaders(),
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
    };
  }

  Future<Map<String, dynamic>> multipartPost({
    required String path,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    var url = Uri.parse(serverUrl + path);

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add fields to the request
    request.fields
        .addAll(data.map((key, value) => MapEntry(key, value.toString())));

    // Add the image file to the request
    if (imageFile != null) {
      request.files.add(
        http.MultipartFile(
          'bike_image',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: 'bike_image.jpg',
          contentType: MediaType('image', 'jpg'),
        ),
      );
    }

    // Get headers
    var headers = await _getHeaders();

    // Add headers to the request
    request.headers.addAll(headers);

    try {
      // Send the request
      var response = await request.send();

      // Read response
      var responseBody = await response.stream.bytesToString();

      // Check the response
      if (response.statusCode == 200) {
        // Parse the response body
        var body = json.decode(responseBody) as Map<String, dynamic>;
        return {'statusCode': response.statusCode, 'body': body};
      } else {
        // Handle error
        print('Error adding bike. Status code: ${response.statusCode}');
        return {'statusCode': response.statusCode, 'body': responseBody};
      }
    } catch (e) {
      // Handle error
      print('Error adding bike: $e');
      return {'statusCode': -1, 'body': 'Failed to add bike. $e'};
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
      'Access-Control-Allow-Origin': serverUrl
    };
  }
}
