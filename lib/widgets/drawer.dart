import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vahan_user/screens/bike/allbikes.dart';
import 'package:vahan_user/screens/changepasswor.dart';
import 'package:vahan_user/screens/login.dart';
import 'package:vahan_user/utils/colors.dart';

class CustomizeDrawerScreen extends StatelessWidget {
  const CustomizeDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header of the Drawer
            Material(
              color: primaryAppColor,
              child: InkWell(
                onTap: () {
                  // Close Navigation drawer before
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    bottom: 24,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Sophia',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@sophia.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Header Menu items
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text('Home'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text('My Bikes'),
                  onTap: () {
                    Get.to(() => AllBikesScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('Change Password'),
                  onTap: () {
                    Get.to(() => ChangePassword());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.policy_outlined),
                  title: Text('Privacy Policy'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About Us'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Help'),
                  onTap: () {},
                ),
                const Divider(
                  color: Colors.black45,
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Get.offAll(LoginPage());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
