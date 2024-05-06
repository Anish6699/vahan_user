import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/http/http.dart' as hhtp10;
import 'package:http/http.dart' as http5;
import 'package:vahan_user/utils/server_config.dart';

final hhtp10.HttpClient _httpClient = hhtp10.HttpClient();

class ActionCOntrollers extends GetxController {
  Future<Map> getAllMessages(orderId) async {
    var response = await _httpClient.get(
        path: 'user/single-order-chat-list?order_id=$orderId');
    var a = jsonDecode(response['body']);
    Map body = a as Map;

    return body;
  }

  Future<Map<String, dynamic>> sendProductForApproval(
      Map<String, dynamic> data) async {
    print('in approval');
    print(data);
    var response =
        await _httpClient.post(path: 'user/send-user-message', body: data);
    print(response);
    var body = json.decode(response['body']) as Map<String, dynamic>;
    print(body);

    return body;
  }

  Future<Map<String, dynamic>> sendImage(
      String orderId, XFile imageFile, vendorID) async {
    var request = http5.MultipartRequest(
        'POST', Uri.parse('${serverUrl}user/send-user-message'));

    // Add order ID
    request.fields['order_id'] = orderId;
    request.fields['type'] = '3';
    request.fields['send_by'] = vendorID.toString();

    // Convert XFile to File
    var file = File(imageFile.path);

    // Attach image file
    var image = await http5.MultipartFile.fromPath('images', file.path);
    request.files.add(image);

    // Send request
    var response = await request.send();

    // Get response
    var responseData = await response.stream.bytesToString();
    print(responseData);

    // Parse response
    var body = json.decode(responseData) as Map<String, dynamic>;
    print(body);

    return body;
  }
}
