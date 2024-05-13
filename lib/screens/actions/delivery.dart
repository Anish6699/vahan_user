import 'package:flutter/material.dart';
import 'package:vahan_user/utils/colors.dart';

class DelhiveryScreen extends StatefulWidget {
  const DelhiveryScreen({Key? key}) : super(key: key);

  @override
  _DelhiveryScreenState createState() => _DelhiveryScreenState();
}

class _DelhiveryScreenState extends State<DelhiveryScreen> {
  String? enteredCode;
  String correctCode = "1234"; // Replace with your correct code
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primaryAppColor, // Updated app bar color
        title: const Text(
          'Delivery Details',
          style: TextStyle(
            color: Colors.white, // Updated app bar text color
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200], // Updated background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Pickup Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailRow("ID", "Value"),
              _buildDivider(),
              _buildDetailRow("Name", "Value"),
              _buildDivider(),
              _buildDetailRow("Email", "Value"),
              _buildDivider(),
              _buildDetailRow("Mobile", "Value"),
              _buildDivider(),
              _buildDetailRow("Message", "Value"),
              _buildDivider(),
              const SizedBox(height: 40),
              _buildDetailRow("Total Kms", "Value"),
              const SizedBox(height: 20),
              _buildCodeInput(),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: isVerified == false ? null : () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    backgroundColor: primaryAppColor,
                    // Updated button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Deliver',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: primaryAppColor, // Updated text color
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 2,
      color: primaryAppColor.withOpacity(0.5), // Updated divider color
    );
  }

  Widget _buildCodeInput() {
    return Column(
      children: [
        const Text(
          "To ensure your Bike is in Safe Hand ,Please Enter 4 digit Code from Pickup Vendor",
          style: TextStyle(
            fontSize: 17,
            color: Color.fromARGB(221, 58, 58, 58),
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Code",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(221, 89, 88, 88),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    enteredCode = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "XXXX",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isVerified == false) {
                  if (enteredCode == correctCode) {
                    setState(() {
                      isVerified = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Code matched successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Code mismatched"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isVerified
                    ? Colors.green
                    : primaryAppColor, // Updated button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isVerified ? "Verified" : "Verify",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
