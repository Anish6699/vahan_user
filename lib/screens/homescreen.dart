import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:vahan_user/screens/bike/bookservices.dart';
import 'package:vahan_user/utils/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageList = [
    'assets/garageimage1.jpg',
    'assets/garageimage2.jpg',
    'assets/garageimage3.jpg',
    // Add more image paths as needed
  ];
  int currentIndex = 0;
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: 200,
          child: Lottie.asset(
            'assets/animation/background1.json', // Replace with your Lottie animation file
            fit: BoxFit.fitWidth,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                  ),
                  items: imageList.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DotsIndicator(
                        decorator: DotsDecorator(
                          color: Colors.grey,
                          activeColor: primaryAppColor,
                          activeSize: const Size(10, 10),
                          spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                        ),
                        dotsCount: imageList.length,
                        position: currentIndex,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Services',
                        style: TextStyle(
                          color: black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: Lottie.asset(
                          'assets/animation/most_recommended.json', // Replace with your Lottie animation file
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const BookServices());
                  },
                  child: _buildServiceCard(
                    'General Services',
                    'Trending Service',
                    'assets/technical-support.png',
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const BookServices());
                  },
                  child: _buildServiceCard(
                    'Major Services',
                    'Most Recommended Service',
                    'assets/motorcycle.png',
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'All Services',
                    style: TextStyle(
                      color: black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildServiceCard('General\nServices', 'Trending Service',
                        'assets/technical-support.png'),
                    const SizedBox(height: 10),
                    _buildServiceCard('Major\nServices',
                        'Most Recommended Service', 'assets/motorcycle.png'),
                    const SizedBox(height: 10),
                    _buildServiceCard('Engine\nWork',
                        'Full Engine/Half Engine Works', 'assets/motor.png'),
                    const SizedBox(height: 10),
                    _buildServiceCard(
                        'Labor\nServices',
                        'Additional Product or Labor you may required',
                        'assets/motorcycle.png'),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, String subTitle, String iconPath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: green.withOpacity(0.5),
            radius: 25,
            child: Image.asset(iconPath, height: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: black.withOpacity(0.7),
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(String title, String iconPath) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryAppColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          height: 100,
          width: 100,
          child: Center(
            child: CircleAvatar(
              backgroundColor: green.withOpacity(0.5),
              radius: 30,
              child: Image.asset(iconPath, height: 28),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 100,
          child: AutoSizeText(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
