import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/controllers/order_controller.dart';
import 'package:vahan_user/utils/colors.dart';
import 'package:vahan_user/widgets/futureDailogBox.dart';
import 'package:vahan_user/widgets/optionpopup.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  String? _selectedDate; // Changed to nullable
  String? _selectedTime; // Changed to nullable
  String? _pickUpOption; // Variable to store pick-up option

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime.format(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCartList();
  }

  Future<Map> fetchDataFromApi(data) async {
    print('datataaaa');
    print(data);
    var a = await OrderController().placeOrder(data);
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(a);
    return a;
  }

  void _showOptionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OptionsPopup(
          onOptionSelected: (String option) async {
            print('Selected option: $option');
            if (option == 'Auto') {
              Map autoVendor = await OrderController().getVendorByTypeAuto();

              SharedPreferences prefs = await SharedPreferences.getInstance();
              var userId = prefs.getInt('userId');

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ApiDialog(
                    apiResponse: fetchDataFromApi({
                      "user_id": userId,
                      "time_slot": _selectedTime,
                      "date": _selectedDate,
                      "vendorId": autoVendor['data']['user_id'],
                      "bike_id": cartList.first['bike_id']
                    }),
                  );
                },
              );
            }
            if (option == 'Manual') {
              print('in manuall');
              vendors = await OrderController().getVendorByTypeManual();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      content: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Select Vendor',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: primaryAppColor,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            _buildVendorList(context),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        );
      },
    );
  }

  List cartList = [];
  getCartList() async {
    cartList = await OrderController().getCartList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                          width: 0.80,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _selectedDate ?? 'Select Date',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                          width: 0.80,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _selectedTime ?? 'Select Time',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Service:     ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        cartList[index]['service_name'],
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Price:     ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        cartList[index]['price'],
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Cubic Capacity:     ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        cartList[index]['bike_cc'],
                                        style: TextStyle(
                                          color: primaryAppColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            cartList.isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed:
                          (_selectedTime == null || _selectedDate == null)
                              ? null
                              : () {
                                  _showOptionsPopup(context);
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryAppColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Place Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  List vendors = [];
  Widget _buildVendorList(BuildContext context) {
    // Dummy vendor data
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: vendors.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildVendorTile(
            name: vendors[index]['vendor_name'] ?? '',
            shop: vendors[index]['shop_name'] ?? '',
            address: vendors[index]['shop_address'] ?? '',
            vendorId: vendors[index]['user_id'] ?? '',
          );
        },
      ),
    );
  }

  Widget _buildVendorTile(
      {required String name,
      required String shop,
      required String address,
      required vendorId}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var userId = prefs.getInt('userId');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ApiDialog(
                apiResponse: fetchDataFromApi({
                  "user_id": userId,
                  "time_slot": _selectedTime,
                  "date": _selectedDate,
                  "vendorId": vendorId,
                  "bike_id": cartList.first['bike_id']
                }),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: primaryAppColor,
                child: const Icon(
                  Icons.store,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      shop,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
