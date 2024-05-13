import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vahan_user/controllers/login_controllers.dart';
import 'package:vahan_user/mainscreen.dart';
import 'package:vahan_user/screens/login.dart';
import 'package:vahan_user/utils/colors.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool isHiddenPassword = true;
  int otpFlag = -1;
  String radioButtonItem = 'ONE';
  int id = 0;
  String otpToMatch = "";
  var data;

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

  Future<void> chooseImage(type) async {
    // ignore: prefer_typing_uninitialized_variables
    var image;
    if (type == "camera") {
      image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
    } else {
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 25);
    }
    if (image != null) {
      setState(() {
        final bytes = File(image.path).readAsBytesSync();
        base64Image = base64Encode(bytes);
        print("base64Image_$base64Image");
        // userImage(base64Image);
        // won't have any error now
      });
    }
  }

  String correctOTP = '';

  // Declare TextEditingController instances for each text field
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      // chooseImage('gallery');
                    },
                    child: const CircleAvatar(
                      radius: 50, // Image radius
                      // backgroundImage:
                      //     NetworkImage(imageUrl == "" ? imageUrl : imageUrl1),
                      child: Icon(
                        Icons.person,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.orange)),
              ),
              child: TextFormField(
                controller: _fullNameController, // Assign controller
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required, please enter your Full Name';
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.orange)),
              ),
              child: TextFormField(
                controller: _emailController, // Assign controller
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required, please enter your E-mail';
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              // width: MediaQuery.of(context).size.width * 0.7,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.orange)),
              ),
              child: TextFormField(
                controller: _contactNoController,
                onChanged: (value) {
                  otpController.clear();
                  otpFlag = -1;
                  setState(() {});
                }, // Assign controller
                decoration: InputDecoration(
                  suffix: otpFlag != -1
                      ? null
                      : TextButton(
                          onPressed: _contactNoController.text.isEmpty
                              ? null
                              : () async {
                                  if (_contactNoController.text.length == 10) {
                                    if (otpFlag == -1) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FutureBuilder(
                                            builder: (
                                              BuildContext context,
                                              AsyncSnapshot<
                                                      Map<String, dynamic>>
                                                  snapshot,
                                            ) {
                                              List<Widget> children;
                                              if (snapshot.hasData) {
                                                data = snapshot.data;

                                                if (data['success'] != true) {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    Get.back();
                                                  });
                                                  children = <Widget>[
                                                    const Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                      size: 60,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 16),
                                                      child: Text(
                                                        data['message'],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ];
                                                } else {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    otpFlag = 0;
                                                    setState(() {});
                                                    Get.back();
                                                  });
                                                  children = <Widget>[
                                                    const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      size: 60,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 16),
                                                      child: Text(
                                                        'OTP sent to ${_contactNoController.text}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ];
                                                }
                                              } else if (snapshot.hasError) {
                                                Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000),
                                                  () {
                                                    Get.back();
                                                  },
                                                );
                                                children = <Widget>[
                                                  const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 60,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16),
                                                    child: Text(
                                                      'Some Error Occurred',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ];
                                              } else {
                                                Future.delayed(
                                                    const Duration(seconds: 5),
                                                    () {
                                                  print('data 3');
                                                  print(data);
                                                });
                                                children = <Widget>[
                                                  SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: primaryAppColor,
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16),
                                                    child: Text(
                                                      'Sending OTP...',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                ];
                                              }
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: SizedBox(
                                                  height: 150,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: children,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            future: LoginController().getOTP(
                                                _contactNoController.text),
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(
                                            const Duration(seconds: 2),
                                            () {
                                              Get.back();
                                            },
                                          );
                                          return const AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: SizedBox(
                                              height: 150,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                      size: 60,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 16),
                                                      child: Text(
                                                        'Please enter a valid 10-digit Contact No.',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                          style: TextButton.styleFrom(
                            // foregroundColor: Colors.white,
                            foregroundColor: Colors.orange,
                            splashFactory: NoSplash.splashFactory,
                            alignment: Alignment.center,
                          ),
                          child: const Text(
                            'Send OTP',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                  labelText: 'Contact No.',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required, please enter your Contact No.';
                  } else if (value.length != 10) {
                    return 'Please enter a valid 10-digit Contact No.';
                  }
                },
              ),
            ),
            otpFlag == -1
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    // width: MediaQuery.of(context).size.width * 0.7,
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.orange)),
                    ),
                    child: TextFormField(
                      readOnly: otpFlag == 2,
                      controller: otpController,
                      onChanged: (value) {
                        otpFlag = 0;
                        setState(() {});
                      }, // Assign controller
                      decoration: InputDecoration(
                        suffix: TextButton(
                          onPressed: otpController.text.isEmpty || otpFlag == 2
                              ? null
                              : () async {
                                  if (otpController.text.length == 4) {
                                    if (otpFlag != 2) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FutureBuilder(
                                            builder: (
                                              BuildContext context,
                                              AsyncSnapshot<
                                                      Map<String, dynamic>>
                                                  snapshot,
                                            ) {
                                              List<Widget> children;
                                              if (snapshot.hasData) {
                                                data = snapshot.data;

                                                if (data['success'] != true) {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    otpFlag = 1;
                                                    setState(() {});
                                                    Get.back();
                                                  });
                                                  children = <Widget>[
                                                    const Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                      size: 60,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 16),
                                                      child: Text(
                                                        data['message'],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ];
                                                } else {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 2), () {
                                                    otpFlag = 2;
                                                    setState(() {});
                                                    Get.back();
                                                  });
                                                  children = <Widget>[
                                                    const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      size: 60,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 16),
                                                      child: Text(
                                                        data['message'],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ];
                                                }
                                              } else if (snapshot.hasError) {
                                                Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000),
                                                  () {
                                                    otpFlag = 1;
                                                    setState(() {});
                                                    Get.back();
                                                  },
                                                );
                                                children = <Widget>[
                                                  const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 60,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16),
                                                    child: Text(
                                                      'Some Error Occurred',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ];
                                              } else {
                                                Future.delayed(
                                                    const Duration(seconds: 5),
                                                    () {
                                                  print('data 3');
                                                  print(data);
                                                });
                                                children = <Widget>[
                                                  SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: primaryAppColor,
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16),
                                                    child: Text(
                                                      'Verifying OTP...',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                ];
                                              }
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: SizedBox(
                                                  height: 150,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: children,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            future: LoginController().verifyOTP(
                                                _contactNoController.text,
                                                otpController.text),
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(
                                            const Duration(seconds: 2),
                                            () {
                                              otpFlag = 1;
                                              setState(() {});
                                              Get.back();
                                            },
                                          );
                                          return const AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: SizedBox(
                                              height: 150,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                      size: 60,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 16),
                                                      child: Text(
                                                        'Please enter a valid 4-digit OTP',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                          style: TextButton.styleFrom(
                            // foregroundColor: Colors.white,
                            foregroundColor: Colors.orange,
                            splashFactory: NoSplash.splashFactory,
                            alignment: Alignment.center,
                          ),
                          child: Text(
                            otpFlag != 2 ? 'Verify OTP' : 'Verified',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                        labelText: 'OTP',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please enter your OTP';
                        } else if (value.length != 4) {
                          return 'Please enter a valid 4-digit OTP';
                        }
                      },
                    ),
                  ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.orange))),
              child: TextFormField(
                controller: _passwordController, // Assign controller
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
                  border: Border(bottom: BorderSide(color: Colors.orange))),
              child: TextFormField(
                controller: _confirmPasswordController, // Assign controller
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
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1.Password should have a minimum length of 8 characters.",
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                  Text(
                    "2.Include at least one uppercase letter",
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                  Text(
                    "3.One lowercase letter",
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                  Text(
                    "4.One special symbol,and one number",
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (_passwordController.text ==
                          _confirmPasswordController.text &&
                      otpFlag == 2) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return FutureBuilder(
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot,
                          ) {
                            List<Widget> children;
                            if (snapshot.hasData) {
                              data = snapshot.data;

                              if (data['success'] != true) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Get.back();
                                });
                                children = <Widget>[
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      data['message'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ];
                              } else {
                                Future.delayed(const Duration(seconds: 2), () {
                                  Get.offAll(() => const LoginPage());
                                });
                                children = <Widget>[
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 60,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(
                                      'User Register Successfully.',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ];
                              }
                            } else if (snapshot.hasError) {
                              print(
                                  "Let's Close the Progress, Invalid Credentialssssssssssssssssssssssssssssssssssssssssss");
                              children = <Widget>[
                                const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    'Invalid Data',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ];
                              Future.delayed(
                                const Duration(milliseconds: 1000),
                                () {
                                  Get.back();
                                },
                              );
                            } else {
                              Future.delayed(const Duration(seconds: 5), () {
                                print('data 3');
                                print(data);
                              });
                              children = <Widget>[
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    color: primaryAppColor,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    'Registering User...',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              ];
                            }
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: SizedBox(
                                height: 150,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: children,
                                  ),
                                ),
                              ),
                            );
                          },
                          future: LoginController().signUpUser({
                            'name': _fullNameController.text,
                            'email': _emailController.text,
                            'number': _contactNoController.text,
                            'password': _passwordController.text,
                            'c_password': _confirmPasswordController.text,
                          }),
                        );
                      },
                    );
                  } else if (otpFlag == 2) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              Get.back();
                            },
                          );
                          return const AlertDialog(
                            backgroundColor: Colors.white,
                            content: SizedBox(
                              height: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text(
                                        'Passwords do not match.',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              Get.back();
                            },
                          );
                          return const AlertDialog(
                            backgroundColor: Colors.white,
                            content: SizedBox(
                              height: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text(
                                        'Verify Contact number via OTP',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }
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
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, last}) {
    TextEditingController controller =
        TextEditingController(); // Create a TextEditingController

    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: 50,
      child: AspectRatio(
        aspectRatio: 0.9,
        child: Center(
          child: TextField(
            scrollPadding: const EdgeInsets.all(0),
            autofocus: true,
            controller: controller, // Set the controller for the TextField
            onChanged: (value) {
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && first == false) {
                FocusScope.of(context).previousFocus();
              }

              if (value.isNotEmpty) {
                otpToMatch += value;
              } else if (otpToMatch.isNotEmpty) {
                otpToMatch = otpToMatch.substring(0, otpToMatch.length - 1);
              }
            },
            onEditingComplete: () {},
            showCursor: false,
            readOnly: false,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counter: const Offstage(),
              contentPadding: const EdgeInsets.all(0),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.black12),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: primaryAppColor),
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }
}
