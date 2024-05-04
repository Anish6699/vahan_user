import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/controllers/login_controllers.dart';
import 'package:vahan_user/mainscreen.dart';
import 'package:vahan_user/screens/forgetpassword.dart';
import 'package:vahan_user/screens/sign_up.dart';
import 'package:vahan_user/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController agentCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginController loginController = LoginController();
  bool isHiddenPassword = true;
  String radioButtonItem = 'ONE';
  int id = 0;
  var data;

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

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
        title: const Text(
          "",
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
                    child: Image.asset(
                      "assets/logo.jpeg",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(left: 20, right: 0, top: 10),
                child: const Text("Log in to your account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),

              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.orange)),
                ),
                child: TextFormField(
                  controller: agentCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Email',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required, please enter Email';
                    }
                  },
                ),
              ),
              //box styling
              //text input
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.orange))),
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
                margin: EdgeInsets.only(top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(ForgotPasswordPage());
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: Text(
                          "Forgot password",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryAppColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // if (_formKey.currentState!.validate()) {
                  //   Get.offAll(HomePage());
                  // }
                  final prefs = await SharedPreferences.getInstance();

                  final isValid = _formKey.currentState!.validate();
                  print("Is Login in Form Current State OK : ${isValid}");
                  if (isValid) {
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
                              print(
                                  'dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                              print(data);
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
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(
                                      'Please Enter Valid Credentials',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ];
                              } else {
                                prefs.setString('token', data['data']['token']);
                                prefs.setInt('userId', data['data']['user_id']);

                                Future.delayed(const Duration(seconds: 2), () {
                                  Get.offAll(() => HomePage());
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
                                      'Signed In Successfully.',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ];
                              }
                            }
                           
                            if (snapshot.error != null) {
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
                                    'InValid Credentials',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ];
                              Future.delayed(
                                Duration(milliseconds: 1000),
                                () {
                                  Get.back();
                                },
                              );
                            }
                           
                            else {
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
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    'Signing In...',
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
                          future: LoginController().login({
                            'email': agentCodeController.text,
                            'password': passwordController.text,
                          }),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
                  height: 50,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: primaryAppColor,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Get.to(SignUp());
                },
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: const Text(
                          "Don't have an account yet?",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 0, top: 10),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryAppColor),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
