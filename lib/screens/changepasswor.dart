import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vahan_user/mainscreen.dart';
import 'package:vahan_user/utils/colors.dart';
import 'package:image_picker/image_picker.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController agentCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isHiddenPassword = true;
  String radioButtonItem = 'ONE';
  int id = 0;
  String otpToMatch = "";

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  File? selectedImage;
  String base64Image = "";
  String imageUrl = "";
  String imageUrl1 =
      "https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-No-Background.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Create an account",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.orange))),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(isHiddenPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          border: InputBorder.none),
                      keyboardType: TextInputType.visiblePassword,
                      onFieldSubmitted: (value) {},
                      obscureText: isHiddenPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please enter Password';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.orange))),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(isHiddenPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          border: InputBorder.none),
                      keyboardType: TextInputType.visiblePassword,
                      onFieldSubmitted: (value) {},
                      obscureText: isHiddenPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please enter Password';
                        }
                      },
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // if (_formKey.currentState!.validate()) {
                  //   Get.offAll(HomePage());
                  // }
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  height: 50,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: primaryAppColor,
                  ),
                  child: const Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
