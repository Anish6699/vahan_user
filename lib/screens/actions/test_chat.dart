import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_user/controllers/action_controllers.dart';
import 'package:vahan_user/utils/colors.dart';

class ChatScreen extends StatefulWidget {
  final int orderID;

  ChatScreen({Key? key, required this.orderID}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  final ScrollController _messageScrollController = ScrollController();
  var selectedProductType;
  var selectedLabourService;
  List laborServiceList = [];
  List allMessageList = [];
  bool isLoading = false;
  var userId;
  Timer? _timer;

  @override
  initState() {
    super.initState();
    _startTimer();
    getAllMessages();
  }

  @override
  void dispose() {
    // Dispose the timer when the page is disposed
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    // Start a timer that fires every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 100), (timer) {
      // Execute your function here
      getAllMessages();
    });
  }

  void _stopTimer() {
    // Stop the timer
    _timer?.cancel();
  }

  getAllMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');

    var a = await ActionCOntrollers().getAllMessages(widget.orderID);
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(a);
    allMessageList = a['data'];
    laborServiceList = a['labourservice'];

    isLoading = false;
    setState(() {});
  }

  getServiceName(laborId, serviceList) {
    for (var service in serviceList) {
      if (service["id"].toString() == laborId.toString()) {
        return service["name"];
      }
    }
    return "Service not found"; // Return this if the labor ID is not found in the list
  }

  getServicePrice(laborId, serviceList) {
    for (var service in serviceList) {
      if (service["id"].toString() == laborId.toString()) {
        return service["price"];
      }
    }
    return "Service not found"; // Return this if the labor ID is not found in the list
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var a = await ActionCOntrollers().sendProductForApproval({
        'type': '0',
        'message': _textController.text,
        'order_id': widget.orderID,
        'send_by': userId
      }).then((value) async {
        _textController.clear();
        await getAllMessages();
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      var a = await ActionCOntrollers()
          .sendImage(widget.orderID.toString(), pickedFile, userId)
          .then((value) async {
        await getAllMessages();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Order Chat',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true, // Set reverse property to true
              controller: _messageScrollController,
              itemCount: allMessageList.length,
              itemBuilder: (BuildContext context, int index) {
                final message = allMessageList[index];
                return Align(
                  alignment: message['send_by'] == userId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message['send_by'] == userId
                          ? Colors.grey[200]
                          : primaryAppColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: message['message_type'] == '0'
                        ? Text(
                            message['comment'].toString(),
                            style: TextStyle(
                              color: message['message_type'] == '0'
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          )
                        : message['message_type'] == '1'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Product: ${message['product_name']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Price: ${message['product_price']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Labor Service: ${message['product_name']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Price: ${message['product_price']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  message['approve_status'] == 0
                                      ? Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // Implement decline action
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: const Text(
                                                'Decline',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Implement approve action
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              child: const Text(
                                                'Approve',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        )
                                      : message['approve_status'] == 2
                                          ? ElevatedButton(
                                              onPressed: () {
                                                // Implement decline action
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: const Text(
                                                'Declined',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                // Implement approve action
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              child: const Text(
                                                'Approved',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                ],
                              )
                            : message['message_type'] == '2'
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Lobour Service: ${message['product_name']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Price: ${message['product_price']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      message['approve_status'] == 0
                                          ? Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Implement decline action
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  child: const Text(
                                                    'Decline',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Implement approve action
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                  child: const Text(
                                                    'Approve',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : message['approve_status'] == 2
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    // Implement decline action
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  child: const Text(
                                                    'Declined',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    // Implement approve action
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                  child: const Text(
                                                    'Approved',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                    ],
                                  )
                                : message['message_type'] == '3'
                                    ? InkWell(
                                        onTap: () {
                                          // Implement opening image in full screen
                                        },
                                        child: Image.network(
                                          message['image'],
                                          width: 200,
                                          height: 200,
                                        ),
                                      )
                                    : const SizedBox(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                isLoading == true
                    ? CircularProgressIndicator()
                    : Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 120,
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(Icons.camera),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            _getImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            _getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _sendMessage,
                            color: primaryAppColor,
                            iconSize: 28,
                          ),
                        ],
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
