import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vahan_user/mainscreen.dart';

class ApiDialog extends StatelessWidget {
  final Future<Map> apiResponse;

  ApiDialog({required this.apiResponse});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: apiResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!['status'] != 200) {
          return AlertDialog(
            title: const Text('Order Status'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  size: 60.0,
                  color: Colors.red,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Oops! Something went wrong.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Failed to Place. Please try again later.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        } else {
          return DialogContent(apiResponse: snapshot.data!['message']);
        }
      },
    );
  }
}

class DialogContent extends StatelessWidget {
  final String apiResponse;

  DialogContent({required this.apiResponse});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Order Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 60.0,
            color: Colors.green,
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Congratulations!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Order Placed Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            apiResponse,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.offAll(() => HomePage(
                  preselectedIndex: 3,
                ));
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
