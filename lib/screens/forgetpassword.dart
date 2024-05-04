import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:vahan_user/screens/login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isHiddenPassword = true;
  String radioButtonItem = 'ONE';
  int id = 0;

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
          "Forgot password",
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

              Container(
                width: 300,
                margin: const EdgeInsets.only(left: 20, right: 0, top: 10),
                child: const Text(
                    "You will receive a link to change the password on provided e-mail address",
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
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required, please enter email';
                    }
                  },
                ),
              ),
              //box styling
              //text input

              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // resetPassword(emailController.text);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
                  height: 50,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orange,
                  ),
                  child: const Text(
                    "Submit",
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
                  Get.to(LoginPage());
                },
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: const Text(
                          "For login page",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 0, top: 10),
                        child: const Text(
                          "click here",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
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

//   void resetPassword(email) async {
//     //  var userId = await SharedPrefHelper().get("userId");
//     await EasyLoading.show(
//       status: 'loading...',
//       maskType: EasyLoadingMaskType.black,
//     );
//     var data = {
//       "email": email,
//     };
//     Dio dio = Dio();
//     try {
//       var response =
//           await dio.post(ApiUrl.resetPassword, queryParameters: data);
//       if (response.statusCode == 200) {
//         print("resetPassword_${response.data}");
//         await EasyLoading.dismiss();
//         var status = response.data["status"];
//         print(status);
//         if (status != false) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(const SnackBar(content: Text("Check your mail")));
//           Navigator.of(context).pushNamed("/loginPage");
//         } else {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(response.data["message"])));
//         }
//       } else {
//         print(response.statusCode);
//         await EasyLoading.dismiss();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
}
