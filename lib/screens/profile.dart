import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vahan_user/controllers/login_controllers.dart';
import 'package:vahan_user/mainscreen.dart';
import 'package:vahan_user/utils/colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  File? selectedImage;
  String base64Image = "";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    getProfileData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Map<String, dynamic> profileData = {};

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

  getProfileData() async {
    print('in get dataaaaaaaaaaaaaaaaaaaa');
    profileData = await LoginController().getProfileData();

    // Pre-assign data to controllers
    nameController.text = profileData['name'];
    contactController.text = profileData['number'].toString();
    emailController.text = profileData['email'];
    countryController.text = profileData['country'];
    stateController.text = profileData['state'];
    cityController.text = profileData['city'];
    addressController.text = profileData['shop_address'];
    zipController.text = profileData['zip_code'];
  }

  Future<void> chooseImage(type) async {
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              GestureDetector(
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
                        : profileData['profile_image'] != null
                            ? Image.network(profileData['profile_image'])
                            : Text(
                                "Upload Profile Image",
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
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(
                  labelText: 'Contact No',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Current Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: zipController,
                decoration: InputDecoration(
                  labelText: 'Zip Code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your zip code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryAppColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
