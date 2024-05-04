import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vahan_user/controllers/order_controller.dart';
import 'package:vahan_user/screens/actions/chat.dart';
import 'package:vahan_user/screens/actions/delivery.dart';
import 'package:vahan_user/screens/actions/invoice.dart';
import 'package:vahan_user/screens/actions/report.dart';
import 'package:vahan_user/utils/colors.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getOrderHistory();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Function to map status values to their labels and icons
  String getStatusLabel(String status) {
    switch (status) {
      case "0":
        return 'Pending';
      case "1":
        return 'Assigned';
      case "2":
        return 'On Going';
      case "3":
        return 'Picked Up';
      case "4":
        return 'Completed';
      case "5":
        return 'Rejected';
      case "6":
        return 'Dispute';
      case '7':
        return 'Accept Cancel Order';
      default:
        return 'Unknown';
    }
  }

  String getStatusCodeLabel(String status) {
    switch (status) {
      case 'Pending':
        return "0";
      case 'Assigned':
        return "1";
      case 'On Going':
        return "2";
      case 'Picked Up':
        return "3";
      case 'Completed':
        return "4";
      case 'Rejected':
        return "5";
      case 'Dispute':
        return "6";
      case 'Accept Cancel Order':
        return "7";
      case 'All':
        return '-1';
      default:
        return "-1"; // Return an unknown value
    }
  }

  // Function to map status values to their respective icons
  IconData getStatusIcon(String status) {
    switch (status) {
      case "0":
        return Icons.pending_actions;
      case "1":
        return Icons.assignment_ind;
      case "2":
        return Icons.directions_car;
      case "3":
        return Icons.local_shipping;
      case "4":
        return Icons.done;
      case "5":
        return Icons.close;
      case "6":
        return Icons.report;
      case "7":
        return Icons.cancel;
      default:
        return Icons.error;
    }
  }

  String selectedStatus = 'All';
  getOrderHistory() async {
    print('in get order history');
    orderDummyData = await OrderController().getOrderHistory();
    setState(() {});
  }

  List orderDummyData = [];

  String formatTime(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    String formattedTime = DateFormat('dd MMMM, hh:mm a').format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.red,
                      style: BorderStyle.solid,
                      width: 0.80,
                    ),
                  ),
                  child: DropdownButton(
                    value: selectedStatus,
                    items: [
                      'All',
                      'Pending',
                      'Assigned',
                      'On Going',
                      'Picked Up',
                      'Completed',
                      'Rejected',
                      'Dispute',
                      'Accept Cancel Order'
                    ]
                        .map((data) => DropdownMenuItem(
                              value: data,
                              child: Text(data),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value.toString();
                      });
                    },
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: orderDummyData.length,
                    itemBuilder: (BuildContext context, index) {
                      if (getStatusCodeLabel(selectedStatus) != '-1' &&
                          orderDummyData[index]['status'] !=
                              getStatusCodeLabel(selectedStatus)) {
                        return SizedBox.shrink(); // Skip this item
                      }
                      return Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Order ID : ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(orderDummyData[index]
                                                    ['order_id']
                                                .toString()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Vendor ID : ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(orderDummyData[index]['vendor']
                                                .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    getStatusLabel(orderDummyData[index]
                                            ['status']
                                        .toString()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Vendor Name",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(orderDummyData[index]
                                                          ['v_name']),
                                                      const Text(
                                                        "Scheduled Time",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(formatTime(
                                                          orderDummyData[index][
                                                              'scheduled_time'])),
                                                    ],
                                                  ),
                                                  const VerticalDivider(
                                                    color: Colors.black,
                                                    thickness: 0.5,
                                                  ),
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Vendor Contact",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(orderDummyData[index]
                                                              ['v_number']
                                                          .toString()),
                                                      const Text(
                                                        "Price",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(orderDummyData[index]
                                                          ['order_price']),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SizedBox(
                                              child: Divider(
                                                color: Colors.black,
                                                thickness: 0.1,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Current Address",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(orderDummyData[index][
                                                            'current_addresses'] ??
                                                        ''),
                                                    const Text(
                                                      "Requested Service",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: Text(orderDummyData[
                                                                  index][
                                                              'service_names'] ??
                                                          ''),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Set your desired border radius here
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith((states) =>
                                                              primaryAppColor),
                                                  foregroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .white)),
                                              onPressed: () {
                                                Get.to(() => ChatScreen(
                                                      orderID:
                                                          orderDummyData[index]
                                                              ['order_id'],
                                                    ));
                                              },
                                              child: const Text(
                                                'Chat',
                                                style: TextStyle(fontSize: 10),
                                              )),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Set your desired border radius here
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith((states) =>
                                                              primaryAppColor),
                                                  foregroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .white)),
                                              onPressed: () {
                                                Get.to(() =>
                                                    const DelhiveryScreen());
                                              },
                                              child: const Text(
                                                'Delivery',
                                                style: TextStyle(fontSize: 10),
                                              )),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Set your desired border radius here
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith((states) =>
                                                              primaryAppColor),
                                                  foregroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .white)),
                                              onPressed: () {
                                                Get.to(() =>
                                                    const InvoiceDetailScreen());
                                              },
                                              child: const Text(
                                                'Invoice',
                                                style: TextStyle(fontSize: 10),
                                              )),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Set your desired border radius here
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith((states) =>
                                                              primaryAppColor),
                                                  foregroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .white)),
                                              onPressed: () {
                                                Get.to(
                                                    () => const ReportScreen());
                                              },
                                              child: const Text(
                                                'Report',
                                                style: TextStyle(fontSize: 10),
                                              ))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 24.0,
                                backgroundColor: Colors.blue,
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(getStatusIcon(
                                      orderDummyData[index]['status']
                                          .toString())),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
