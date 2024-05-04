import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/widgets.dart';
import 'package:vahan_user/screens/test_screens/test_home.dart';
import 'package:vahan_user/utils/colors.dart';
import 'package:auto_scroll/auto_scroll.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TipsScreen> {
  final List<String> imageList = [
    'assets/garageimage1.jpg',
    'assets/garageimage2.jpg',
    'assets/garageimage3.jpg',
    // Add more image paths as needed
  ];
  int currentIndex = 0;
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                DotsIndicator(
                  decorator: DotsDecorator(
                      color: Colors.grey, activeColor: primaryAppColor),
                  dotsCount: imageList.length,
                  position: currentIndex,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Image.asset(
                                  'assets/motorcycle_insuarnace.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Insuarance",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Image.asset('assets/wallet.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Wallet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Image.asset('assets/magic-trick.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "AMC Magic\nBox",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Image.asset('assets/conversation.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Why\nVahan\nJunction",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Image.asset('assets/cost.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Refer and Earn",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Image.asset('assets/earn_and_grow.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Earn and Grow",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child:
                                  Image.asset('assets/royalty_club_magic.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Royalty\nClub Magic",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius:
                            BorderRadius.circular(10.0), // Round borders
                      ),
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Image.asset('assets/exclusive_store.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Exclusive\nStore",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.height * 0.13,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
