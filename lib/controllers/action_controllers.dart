import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/http/http.dart';

final HttpClient _httpClient = HttpClient();

class ActionCOntrollers extends GetxController {
  Future<Map<String, dynamic>> addBike(
      Map<String, dynamic> bikeData, File? imageFile) async {
    final httpClient = HttpClient();

    try {
      final response = await httpClient.multipartPost(
        path: 'user/add-bike',
        data: bikeData,
        imageFile: imageFile,
      );
      return response;
    } catch (e) {
      return {'error': 'Failed to add bike. $e'};
    }
  }

  Future<List> getAllMessages(orderId) async {
    var response = await _httpClient.get(
        path: 'user/single-order-chat-list?order_id=$orderId');
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;

    return body;
  }

  Future<List> getAllOilList() async {
    var response = await _httpClient.get(path: 'get-engine-oil');
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;
    return body;
  }

  Future<List> getCartList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    var response = await _httpClient
        .post(path: 'user/get-cart-list', body: {"user_id": userId});
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;
    return body;
  }

  Future<Map<String, dynamic>> addToCart(Map<String, dynamic> data) async {
    var response = await _httpClient.post(path: 'user/add-to-card', body: data);
    var body = json.decode(response['body']) as Map<String, dynamic>;
    return body;
  }

  Future<Map<String, dynamic>> getVendorByTypeAuto() async {
    var response = await _httpClient
        .post(path: 'user/get-vendor-by-type', body: {"type": "auto"});
    var body = json.decode(response['body']) as Map<String, dynamic>;
    return body;
  }

  Future<List> getVendorByTypeManual() async {
    var response = await _httpClient
        .post(path: 'user/get-vendor-by-type', body: {"type": "manual"});
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;
    return body;
  }

  Future<Map> placeOrder(Map data) async {
    var response = await _httpClient.post(path: 'user/place-order', body: data);
    var a = jsonDecode(response['body']);

    return a;
  }

  Future<List> getOrderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    var response =
        await _httpClient.get(path: 'user/get-order-list?user_id=$userId');
    var a = jsonDecode(response['body']);
    List body = a['data'] as List;
    return body;
  }
}
