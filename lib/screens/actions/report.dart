import 'package:flutter/material.dart';
import 'package:vahan_user/utils/colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [
    "Report 1 The stars twinkled like diamonds in the velvet sky",
    "Report 2 The stars twinkled like diamonds in the velvet sky",
    "Report 3 The stars twinkled like diamonds in the velvet sky",
    "Report 4 The stars twinkled like diamonds in the velvet sky",
    "Report 1 The stars twinkled like diamonds in the velvet sky",
    "Report 2 The stars twinkled like diamonds in the velvet sky",
    "Report 3 The stars twinkled like diamonds in the velvet sky",
    "Report 4 The stars twinkled like diamonds in the velvet sky",
    "Report 1 The stars twinkled like diamonds in the velvet sky",
    "Report 2 The stars twinkled like diamonds in the velvet sky",
    "Report 3 The stars twinkled like diamonds in the velvet sky",
    "Report 4 The stars twinkled like diamonds in the velvet sky",
  ];

  Set<int> _selectedIndexes = {};
  // Function to handle item selection
  void _handleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Report',
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
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndexes.contains(index)
                        ? primaryAppColor
                        : (index % 2 == 0 ? Colors.grey[200] : primaryAppColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Add Checkbox for selection
                      Checkbox(
                        value: _selectedIndexes.contains(index),
                        onChanged: (value) => _handleSelection(index),
                      ),
                      Expanded(
                        child: Text(
                          _messages[index],
                          style: TextStyle(
                            color: _selectedIndexes.contains(index)
                                ? Colors.white
                                : (index % 2 == 0
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ],
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
                  child: Column(
                    children: [
                      TextField(
                        maxLines: 5,
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Comment Here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add logic to handle selected messages here (e.g., print selected indexes)
                          print("Selected messages: $_selectedIndexes");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          backgroundColor:
                              primaryAppColor, // Updated button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
