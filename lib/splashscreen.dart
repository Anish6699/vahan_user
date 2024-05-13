// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/mainscreen.dart';
import 'package:vahan_user/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');
        // Get.offAll(HomePage(
        //   preselectedIndex: 0,
        // ));
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          print('taking to login screen');

          if (token == null) {
            Get.offAll(LoginPage());
          } else {
            Get.offAll(() => HomePage(
                  preselectedIndex: 0,
                ));
          }
        } else {
          // show an popup with option to refresh page
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'No Internet Connection',
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      Text('Check your Internet Connection'),
                    ],
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => const SplashScreen());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                                letterSpacing: 1, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: mediaQuery.width * 0.5,
              child: Image.asset(
                'assets/logo.jpeg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
