// import 'package:flutter/material.dart';
// import 'package:vahan_user/screens/bike/bookservices.dart';
// import 'package:vahan_user/screens/cart.dart';
// import 'package:vahan_user/screens/homescreen.dart';
// import 'package:vahan_user/screens/order.dart';
// import 'package:vahan_user/screens/profile.dart';
// import 'package:vahan_user/screens/test_screens/test_home.dart';
// import 'package:vahan_user/screens/tips.dart';
// import 'package:vahan_user/utils/colors.dart';
// import 'package:vahan_user/widgets/drawer.dart';

// class AnimatedBottomNavigationBar extends StatefulWidget {
//   const AnimatedBottomNavigationBar({Key? key, this.initialIndex = 0})
//       : super(key: key);

//   final int initialIndex;

//   @override
//   _AnimatedBottomNavigationBarState createState() =>
//       _AnimatedBottomNavigationBarState();
// }

// class _AnimatedBottomNavigationBarState
//     extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
//   late int _selectedIndex;
//   late List<AnimationController> _animationControllers;
//   late List<Animation<double>> _animations;

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//     _initAnimations();
//   }

//   @override
//   void dispose() {
//     for (var controller in _animationControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _initAnimations() {
//     _animationControllers = List.generate(
//         5,
//         (index) => AnimationController(
//               vsync: this,
//               duration: Duration(milliseconds: 300),
//             ));
//     _animations = _animationControllers
//         .map((controller) =>
//             controller.drive(Tween<double>(begin: 0.9, end: 1.0)))
//         .toList();
//     _animationControllers[_selectedIndex].forward();
//   }

//   void _onItemTapped(int index) {
//     if (index != _selectedIndex) {
//       _animationControllers[_selectedIndex].reverse();
//       _animationControllers[index].forward();
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: CustomizeDrawerScreen(),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text(
//           _getAppBarTitle(_selectedIndex),
//           style: const TextStyle(
//             color: Colors.black,
//             letterSpacing: 1,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           const HomeScreen(),
//           const CartScreen(),
//           const TipsScreen(),
//           const OrderHistoryScreen(),
//           const Profile(),
//         ],
//       ),
//       bottomNavigationBar: SizedBox(
//         height: kBottomNavigationBarHeight * 1.5,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(5, (index) {
//             return GestureDetector(
//               onTap: () => _onItemTapped(index),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: ScaleTransition(
//                   scale: _animations[index],
//                   child: Icon(
//                     _getIconData(index),
//                     color: index == _selectedIndex
//                         ? primaryAppColor
//                         : Colors.grey[500],
//                     size: 28, // Adjust the size of the icons
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   IconData _getIconData(int index) {
//     switch (index) {
//       case 0:
//         return Icons.home;
//       case 1:
//         return Icons.shopping_cart;
//       case 2:
//         return Icons.lightbulb_outline;
//       case 3:
//         return Icons.assignment;
//       case 4:
//         return Icons.person;
//       default:
//         return Icons.menu;
//     }
//   }

//   String _getAppBarTitle(int index) {
//     switch (index) {
//       case 0:
//         return 'Dashboard';
//       case 1:
//         return 'Cart';
//       case 2:
//         return 'Tips';
//       case 3:
//         return 'Order Details';
//       case 4:
//         return 'Profile';
//       default:
//         return 'Menu';
//     }
//   }
// }

// // Usage:
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBottomNavigationBar(initialIndex: 0);
//   }
// }

import 'package:flutter/material.dart';
import 'package:vahan_user/screens/bike/bookservices.dart';
import 'package:vahan_user/screens/cart.dart';
import 'package:vahan_user/screens/homescreen.dart';
import 'package:vahan_user/screens/order.dart';
import 'package:vahan_user/screens/profile.dart';
import 'package:vahan_user/screens/tips.dart';
import 'package:vahan_user/utils/colors.dart';
import 'package:vahan_user/widgets/drawer.dart';

class AnimatedBottomNavigationBar extends StatefulWidget {
  const AnimatedBottomNavigationBar({Key? key, this.initialIndex = 0})
      : super(key: key);

  final int initialIndex;

  @override
  _AnimatedBottomNavigationBarState createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomizeDrawerScreen(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          _getAppBarTitle(_selectedIndex),
          style: const TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable swipe between pages
        children: [
          if (_selectedIndex == 0) const HomeScreen(),
          if (_selectedIndex == 1) const CartScreen(),
          if (_selectedIndex == 2) const TipsScreen(),
          if (_selectedIndex == 3) const OrderHistoryScreen(),
          if (_selectedIndex == 4) const Profile(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight * 1.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  _getIconData(index),
                  color: index == _selectedIndex
                      ? primaryAppColor
                      : Colors.grey[500],
                  size: 28, // Adjust the size of the icons
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.shopping_cart;
      case 2:
        return Icons.lightbulb_outline;
      case 3:
        return Icons.assignment;
      case 4:
        return Icons.person;
      default:
        return Icons.menu;
    }
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Cart';
      case 2:
        return 'Tips';
      case 3:
        return 'Order Details';
      case 4:
        return 'Profile';
      default:
        return 'Menu';
    }
  }
}

// Usage:
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(initialIndex: 0);
  }
}
