import 'package:flutter/material.dart';
import 'package:vahan_user/utils/colors.dart';

class OptionsPopup extends StatelessWidget {
  final Function(String)
      onOptionSelected; // Callback function to handle option selection

  OptionsPopup({required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Nearby Vendor',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: primaryAppColor,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionItem(
                  icon: Icons.auto_awesome,
                  label: 'Auto',
                  onTap: () {
                    onOptionSelected('Auto');
                  },
                ),
                _buildOptionItem(
                  icon: Icons.manage_search_outlined,
                  label: 'Manual',
                  onTap: () {
                    onOptionSelected('Manual');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
      {required IconData icon,
      required String label,
      required Function onTap}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: primaryAppColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.0,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
