// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ulet_1/halaman/home_page/home_page.dart';
import 'package:ulet_1/halaman/profile_page/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavbar(),
    );
  }
}

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedItem = 0;
  var _pages = [const HomePage(), ProfileScreen()];
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _selectedItem = index;
              });
            },
            controller: _pageController,
          ),
          Positioned(
            height: 65,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType
                    .fixed, // Ensure labels are always shown
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Icon(
                        Icons.compare_arrows,
                        size: 30,
                      ),
                    ),
                    label: 'Transfer',
                  ),
                  const BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.history_outlined,
                        size: 30,
                      ),
                    ),
                    label: 'History',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedItem,
                selectedItemColor: const Color.fromARGB(
                    255, 255, 37, 37), // Set your desired selected item color
                unselectedItemColor:
                    Color(0xFFA41724), // Set your desired unselected item color
                onTap: (index) {
                  setState(() {
                    _selectedItem = index;
                    _pageController.animateToPage(_selectedItem,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear);
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 25, // Adjust the position as needed
            left: MediaQuery.of(context).size.width / 2 -
                30, // Adjust to center the button
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedItem =
                      2; // Assuming the QR code scanner is at index 2
                  _pageController.animateToPage(_selectedItem,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear);
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFA41724), // Set your desired background color
                  borderRadius:
                      BorderRadius.circular(15), // Partial rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
