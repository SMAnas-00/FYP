import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:newui/Screens/AtmCardScreen.dart';
import 'package:newui/Screens/Cart.dart';
import 'package:newui/Screens/HomeScreen.dart';
import 'package:newui/Screens/MapScreen.dart';
import 'package:newui/Screens/Profile.dart';
import 'package:newui/Screens/TODO/TodoListScreen.dart';
import 'package:newui/Screens/TODO/note.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _pageController = PageController(initialPage: 2);

  int maxCount = 5;

  /// widget list
  final List<Widget> bottomBarPages = [
    MapView(),
    ToDoScreen(),
    HomeScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              pageController: _pageController,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              bottomBarItems: [
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_work,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.map_outlined,
                    color: Colors.teal,
                  ),
                  itemLabel: 'Map',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.list,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.list,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Todo',
                ),

                ///svg example
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  itemLabel: 'Home',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.pink,
                  ),
                  itemLabel: 'Cart',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Profile',
                ),
              ],
              onTap: (index) {
                /// control your animation using page controller
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
            )
          : null,
    );
  }
}
