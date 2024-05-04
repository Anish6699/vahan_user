import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/http/http.dart';
import 'package:vahan_user/screens/login.dart';

final HttpClient _httpClient = HttpClient();

class LoginController extends GetxController {
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    print(data);
    var response = await _httpClient.post(path: 'user/user-login', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }
   Future<Map<String, dynamic>> signUpUser(Map<String, dynamic> data) async {
    print(data);
    var response = await _httpClient.post(path: 'user/register', body: data);
    print(response['body']);
    var body = json.decode(response['body']) as Map<String, dynamic>;

    return body;
  }

  logout() async {
    var response = await _httpClient.get(path: 'user/logout');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.to(() => LoginPage());
  }

  Future getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');
    var response =
        await _httpClient.get(path: 'user/get-user-profile?user_id=${userId}');
    var a = jsonDecode(response['body']);
    Map body = a['data'] as Map;

    return body;
  }
}
