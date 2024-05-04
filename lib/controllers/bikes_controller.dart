import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/http/http.dart';
import 'package:vahan_user/screens/login.dart';

final HttpClient _httpClient = HttpClient();

class BikesController extends GetxController {
  Future<Map<String, dynamic>> addBike(
      Map<String, dynamic> bikeData, File? imageFile) async {
    final httpClient = HttpClient();

    try {
      // Send the POST request with the data and image file
      final response = await httpClient.multipartPost(
        path: 'user/add-bike',
        data: bikeData,
        imageFile: imageFile,
      );

      // Return the response
      return response;
    } catch (e) {
      // Handle any errors
      print('Error adding bike: $e');
      return {'error': 'Failed to add bike. $e'};
    }
  }

  Future<Map<String, dynamic>> editBikeImage(
      Map<String, dynamic> bikeData, File? imageFile) async {
    final serverUrl = 'YOUR_SERVER_URL';
    final httpClient = HttpClient(); // Initialize your HttpClient instance

    try {
      final response = await httpClient.multipartPost(
        path: 'user/update-bike',
        data: bikeData,
        imageFile: imageFile,
      );

      // Return the response
      return response;
    } catch (e) {
      // Handle any errors
      print('Error adding bike: $e');
      return {'error': 'Failed to add bike. $e'};
    }
  }

  Future<Map<String, dynamic>> editBike(Map<String, dynamic> bikeData) async {
    try {
      final response = await _httpClient.post(
        path: 'user/update-bike',
        body: bikeData,
      );

      // Return the response
      return response;
    } catch (e) {
      print('Error adding bike: $e');
      return {'error': 'Failed to add bike. $e'};
    }
  }

  Future<List> getAllBikes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    var response =
        await _httpClient.get(path: 'user/bike-list?user_id=${userId}');
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }
}
