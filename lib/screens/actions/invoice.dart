import 'package:flutter/material.dart';
import 'package:vahan_user/utils/colors.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor, // Updated app bar color
        title: Text(
          'Invoice Details',
          style: TextStyle(
            color: Colors.white, // Updated app bar text color
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200], // Updated background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Invoice Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow("Service Date", "Value"),
            _buildDivider(),
            _buildDetailRow("Srvices", "Value"),
            _buildDivider(),
            _buildDetailRow("Lubegrade", "Value"),
            _buildDivider(),
            _buildDetailRow("Lubegrade Price", "Value"),
            _buildDivider(),
            _buildDetailRow("Sub Total", "Value"),
            _buildDivider(),
            _buildDetailRow("GST", "Value"),
            _buildDivider(),
            SizedBox(height: 40),
            _buildDetailRow("Total Ammount", "Value"),
            SizedBox(height: 40),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: primaryAppColor, // Updated button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
          style: TextStyle(
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
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 2,
      color: primaryAppColor.withOpacity(0.5), // Updated divider color
    );
  }
}
