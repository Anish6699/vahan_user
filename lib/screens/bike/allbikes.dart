import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vahan_user/controllers/bikes_controller.dart';
import 'package:vahan_user/screens/bike/addbike.dart';
import 'package:vahan_user/screens/bike/editBike.dart';
import 'package:vahan_user/utils/colors.dart';

class AllBikesScreen extends StatefulWidget {
  const AllBikesScreen({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<AllBikesScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController agentCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  File? selectedImage;
  String base64Image = "";
  String imageUrl = "";
  String imageUrl1 =
      "https://www.pngall.com/wp-content/uploads/13/Avatar-AllBikesScreen-Vector-No-Background.png";
  List data = [];
  getAllBikes() async {
    data = await BikesController().getAllBikes();
    print('bbbbbbbbbbbbbb');
    print(data);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllBikes();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bikes'),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const AddBike());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  "+ Add Bike",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryAppColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var bike = data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Vehicle No: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      bike['vehicle_number'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      "Variant: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      bike['variant'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      "Model: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      bike['model'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Licence Number: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  bike['licence_number'],
                                  style: TextStyle(
                                    color: primaryAppColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  bike['bike_image'],
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Handle delete action
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.to(() => EditBike(
                                              bikeData: bike,
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: primaryAppColor,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
