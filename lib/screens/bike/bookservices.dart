import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/controllers/bikes_controller.dart';
import 'package:vahan_user/controllers/order_controller.dart';
import 'package:vahan_user/mainscreen.dart';
import 'package:vahan_user/utils/colors.dart';

class BookServices extends StatefulWidget {
  const BookServices({Key? key}) : super(key: key);

  @override
  _BookServicesPageState createState() => _BookServicesPageState();
}

class _BookServicesPageState extends State<BookServices> {
  final List<String> imageList = [
    'assets/garageimage1.jpg',
    'assets/garageimage2.jpg',
    'assets/garageimage3.jpg'
  ];
  BikesController bikesController = BikesController();

  Map<int, Set<int>> _selectedServices = {};
  List<int> _selectedChipIds = []; // List to store selected chip ids
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List bikeList = [];
  var selectedBike;
  bool isloading = true;
  List oilList = [];
  var data;

  getAllBikes() async {
    bikeList = await BikesController().getAllBikes();
    oilList = await OrderController().getAllOilList();
    selectedBike = bikeList.first;
    print('get All bikes');
    print(bikeList);
    getALLCategoriesAndSubCategories(selectedBike['id']);
  }

  @override
  void initState() {
    getAllBikes();
    super.initState();
  }

  getALLCategoriesAndSubCategories(bikeid) async {
    serviceDescriptionList =
        await OrderController().getAllCategoriesBikeWise(bikeid);
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Book Services",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: Colors.red,
                          style: BorderStyle.solid,
                          width: 0.80,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        value: selectedBike,
                        items: bikeList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item['vehicle_number']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedBike = value;
                          });
                        },
                        decoration: const InputDecoration(
                            hintText: 'Select Bike', border: InputBorder.none),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: Colors.red,
                          style: BorderStyle.solid,
                          width: 0.80,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${selectedBike?['bike_cc'] ?? ''} CC',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CarouselSlider(
              options: CarouselOptions(
                onPageChanged: (index, reason) {},
                autoPlay: false,
                aspectRatio: 16 / 3,
                enlargeCenterPage: true,
              ),
              items: imageList.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            isloading == true
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animation/takeAwaybike.json'),
                      ],
                    ),
                  )
                : Expanded(
                    child: Container(
                      color: Colors.blueAccent.shade100.withOpacity(0.2),
                      // height: MediaQuery.of(context).size.height * 0.64,
                      child: ListView.builder(
                        itemCount: serviceDescriptionList.length,
                        itemBuilder: (context, index) {
                          final service = serviceDescriptionList[index];
                          final serviceId = service['id'] as int;
                          final isSelected =
                              _selectedServices.containsKey(serviceId);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: Colors.red,
                                  style: BorderStyle.solid,
                                  width: 0.80,
                                ),
                              ),
                              child: ExpansionTile(
                                title: Text(
                                    '${service['category_name']}  ${selectedBike?['bike_cc'] ?? ''} CC'),
                                // subtitle: Text('Price: ${service['price']}'),
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    if (expanded) {
                                      _selectedServices[serviceId] = {};
                                      // Preselect the only sub chip item if there's only one
                                      if ((service['services'] as List)
                                              .length ==
                                          1) {
                                        final desc =
                                            (service['services'] as List).first;
                                        final descId =
                                            desc['service_id'] as int;
                                        _selectedServices[serviceId]!
                                            .add(descId);

                                        _selectedChipIds.add(
                                            descId); // Add id to selected list
                                      }
                                    }
                                    if (_selectedServices
                                        .containsKey(serviceId)) {
                                      _selectedChipIds.removeWhere((chipId) =>
                                          _selectedServices[serviceId]!
                                              .contains(chipId));
                                      _selectedServices.remove(serviceId);
                                    }
                                  });
                                },
                                initiallyExpanded: isSelected,
                                trailing: isSelected
                                    ? const Icon(Icons.check_box)
                                    : const Icon(Icons.check_box_outline_blank),
                                children: [
                                  Wrap(
                                    spacing: 8.0,
                                    children: (service['services'] as List)
                                        .map((desc) {
                                      final descId = desc['service_id'] as int;
                                      final isSelected = _selectedServices
                                              .containsKey(serviceId) &&
                                          _selectedServices[serviceId]!
                                              .contains(descId);
                                      return ActionChip(
                                        label: Text(
                                            '${desc['service_name']} - ${desc['price']} Rs'),
                                        onPressed: () {
                                          setState(() {
                                            if (!isSelected) {
                                              _selectedServices.update(
                                                serviceId,
                                                (value) => value!..add(descId),
                                                ifAbsent: () => {descId},
                                              );
                                              _selectedChipIds.add(
                                                  descId); // Add id to selected list
                                            } else {
                                              _selectedServices[serviceId]!
                                                  .remove(descId);
                                              print(
                                                  'removing id from _selectedChipIds');
                                              print(descId);
                                              print(_selectedChipIds);
                                              _selectedChipIds.remove(
                                                  descId); // Remove id from selected list
                                              if (_selectedServices[serviceId]!
                                                  .isEmpty) {
                                                _selectedServices
                                                    .remove(serviceId);
                                              }
                                            }
                                          });
                                          print('selected services');
                                          print(_selectedServices);
                                          print('selected chip ids');
                                          print(_selectedChipIds);
                                        },
                                        backgroundColor:
                                            isSelected ? primaryAppColor : null,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            _selectedChipIds.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {
                      _showAddToCartDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAppColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Add To Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _showAddToCartDialog(BuildContext context) {
    var selectedOil; // Default value for dropdown
    bool isYesSelected = true; // Default selection for radio button

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Add to Cart")),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 24.0), // Add horizontal padding
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Select Oil:"),
                  DropdownButtonFormField(
                    value: selectedOil,
                    onChanged: (newValue) {
                      setState(() {
                        selectedOil = newValue!;
                      });
                    },
                    items: oilList.map<DropdownMenuItem>((item) {
                      return DropdownMenuItem(
                        value: item['id'],
                        child: Text(item['name']),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text("Select Oil Type:"),
                  Column(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: isYesSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                isYesSelected = true;
                              });
                            },
                          ),
                          const Text("Synthetic"),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: false,
                            groupValue: isYesSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                isYesSelected = false;
                              });
                            },
                          ),
                          const Text("Semi-Synthetic"),
                        ],
                      )
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var userId = prefs.getInt('userId');
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

                              if (data['status'] != 200) {
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
                                      'Failed to Add to Cart',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ];
                              } else {
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
                                      'Added to Cart Successfully.',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ];
                              }
                            }
                            if (snapshot.error != null) {
                              children = <Widget>[
                                const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    'InValid Data',
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
                              Future.delayed(const Duration(seconds: 5), () {});
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
                                    'Adding to Cart...',
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
                          future: OrderController().addToCart({
                            "service_id": _selectedChipIds,
                            "user_id": userId,
                            "bike_id": selectedBike['id'],
                            "engine_oil": selectedOil,
                            "oil_type": isYesSelected == true ? 1 : 0
                          }),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAppColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Proceed",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  List serviceDescriptionList = [];
}
