import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:vahan_user/controllers/action_controllers.dart';
import 'package:vahan_user/utils/colors.dart';

class ChatScreen extends StatefulWidget {
  int orderID;

  ChatScreen({super.key, required this.orderID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [
    "Hello there!",
    "Hey! How can I help you?",
    "I'm looking for some assistance with my order.",
    "Sure, I'm here to help. What seems to be the problem?",
  ];
  List allMessageList = [
    {
      'message_type': 'approval_product',
      'product': {
        'product_name': "Silencer",
        'product_price': 2000,
        'product_type': 'oem',
       'labor_service_id':23
      },
    },
    {
      'message_type': 'text',
       'text': 'Hello',
    },
     {
      'message_type': 'image',
       'image': 'Image data',
    },
     {
      'message_type': 'approval_labor_service',
      'labor': {
       
      },
    },
  ];

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add(_textController.text);
        _textController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllMessages();
  }

  getAllMessages() async {
    allMessageList = await ActionCOntrollers().getAllMessages(widget.orderID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: index % 2 == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          index % 2 == 0 ? Colors.grey[200] : primaryAppColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        color: index % 2 == 0 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
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
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: primaryAppColor,
                  iconSize: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
