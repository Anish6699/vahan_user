import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/controllers/bikes_controller.dart';
import 'package:vahan_user/screens/bike/allbikes.dart';
import 'package:vahan_user/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class EditBike extends StatefulWidget {
  EditBike({Key? key, required this.bikeData}) : super(key: key);

  Map bikeData;
  @override
  _EditBikePageState createState() => _EditBikePageState();
}

class _EditBikePageState extends State<EditBike> {
  final _formKey = GlobalKey<FormState>();
  final vehicleNoController = TextEditingController();
  final variantController = TextEditingController();
  final licenceNoController = TextEditingController();
  final modelController = TextEditingController();
  final lastServiceController = TextEditingController();
  var selectedCC;
  var bikeId;
  BikesController bikesController = BikesController();
  List ccList = ['125', '180', '220', '440'];
  bool isloading = true;

  File? selectedImage;
  String base64Image = "";
  String imageUrl = "";
  String imageUrl1 =
      "https://www.pngall.com/wp-content/uploads/12/Avatar-EditBike-Vector-No-Background.png";

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
        selectedImage = File(image.path);
        final bytes = File(image.path).readAsBytesSync();
        base64Image = base64Encode(bytes);
        print("base64Image_$base64Image");
        // userImage(base64Image);
        // won't have any error now
      });
    }
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        lastServiceController.text =
            DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setPreData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  setPreData() {
    bikeId = widget.bikeData['id'];
    selectedCC = widget.bikeData['bike_cc'];
    vehicleNoController.text = widget.bikeData['vehicle_number'];
    variantController.text = widget.bikeData['variant'];
    lastServiceController.text = widget.bikeData['last_service'];
    modelController.text = widget.bikeData['model'];
    licenceNoController.text = widget.bikeData['licence_number'];
    licenceNoController.text = widget.bikeData['licence_number'];
    setState(() {
      isloading = false;
    });
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  chooseImage('camera');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  chooseImage('gallery');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bike"),
      ),
      backgroundColor: Colors.white,
      body: isloading == true
          ? Lottie.asset('assets/animation/takeAwaybike.json')
          : Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: [10, 10],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: GestureDetector(
                          onTap: () {
                            _showOptions();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,

                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Center(
                              child: base64Image != ''
                                  ? Image.memory(
                                      base64Decode(base64Image),
                                      fit: BoxFit
                                          .cover, // Adjust the fit property as needed
                                    )
                                  : widget.bikeData['bike_image'] != null
                                      ? Image.network(
                                          widget.bikeData['bike_image'])
                                      : Text(
                                          "Upload Bike Image",
                                          style: TextStyle(
                                              color: primaryAppColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                            ),
                            // radius: 50, // Image radius
                            // backgroundImage:
                            //     NetworkImage(imageUrl == "" ? imageUrl : imageUrl1),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      controller: vehicleNoController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle No',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please enter email';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      controller: variantController,
                      decoration: const InputDecoration(
                        labelText: 'Variant',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please enter email';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      controller: licenceNoController,
                      decoration: const InputDecoration(
                        labelText: 'Licence no',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please enter email';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please enter email';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextFormField(
                      controller: lastServiceController,
                      readOnly:
                          true, // Set readOnly to true to make it read-only
                      decoration: InputDecoration(
                        labelText: '   Last Service',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required, please select date';
                        }
                        return null;
                      },
                      onTap: () {
                        _selectDate(context); // Open date picker on tap
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black), // Add border
                    ),
                    child: DropdownButtonFormField(
                      value: selectedCC, // Provide the selected value
                      onChanged: (value) {
                        setState(() {
                          selectedCC = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0), // Adjust padding
                        border: InputBorder.none, // Remove border
                        labelText: 'Bike CC',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      items: ccList.map((cc) {
                        return DropdownMenuItem(
                          value: cc,
                          child: Text('$cc CC'),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'This field is required, please select CC';
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var userId = prefs.getInt('userId');
                      var data;
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
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      Get.offAll(() => const AllBikesScreen());
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
                                          'Please Enter Valid Details',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ];
                                  } else {
                                    children = <Widget>[
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 60,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Text(
                                          'Bike Added Successfully.',
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
                                        'InValid Details',
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
                                        'Adding Bike...',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: children,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              future: selectedImage == null
                                  ? BikesController().editBike({
                                      'id': bikeId,
                                      'user_id': userId,
                                      'vehicle_number':
                                          vehicleNoController.text,
                                      'variant': variantController.text,
                                      'model': modelController.text,
                                      'bike_cc': selectedCC,
                                      'last_service':
                                          lastServiceController.text,
                                    })
                                  : BikesController().editBikeImage({
                                      'id': bikeId,
                                      'user_id': userId,
                                      'vehicle_number':
                                          vehicleNoController.text,
                                      'variant': variantController.text,
                                      'model': modelController.text,
                                      'bike_cc': selectedCC,
                                      'last_service':
                                          lastServiceController.text,
                                    }, selectedImage),
                            );
                          },
                        );
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
                        "Edit Bike",
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
