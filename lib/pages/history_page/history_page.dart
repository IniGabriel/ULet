import 'package:flutter/material.dart';
import 'package:ulet_1/pages/home_page/home_page.dart';
import 'dart:math';

import 'package:ulet_1/pages/profile_page/profile_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HistoryPage(),
    );
  }
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 3; // Index default untuk "History" page

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index; // Update indeks saat item dipilih
      });
    }
  }

  List<String> _randomAmounts = [];

  @override
  void initState() {
    super.initState();
    _generateRandomAmounts();
  }

  void _generateRandomAmounts() {
    final random = Random();
    _randomAmounts = List.generate(
      12,
      (index) {
        int amount = 500000 + random.nextInt(1500000);
        return 'Rp. ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.18,
            color: Color(0xFFA41724),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    color: Color.fromARGB(40, 253, 173, 173),
                    width: double.infinity,
                    height: screenHeight * 0.10,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(index + 1).toString().padLeft(2, '0')}/06/2024',
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                'Transfer To Ipsum Lorem',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            _randomAmounts[index],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        clipBehavior:
            Clip.none, // Mengizinkan widget untuk melewati batas Stack
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Lebih gelap sedikit
                  spreadRadius: 2,
                  blurRadius: 50,
                  offset: Offset(0, 0), // Shadow di atas BottomNavigationBar
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 32,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.compare_arrows,
                    size: 32,
                  ),
                  label: 'Transfer',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(), // Tempat untuk ikon QR code scanner
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history,
                    size: 32,
                  ),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 32,
                  ),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              unselectedItemColor: Color(0xFFA41724),
              onTap: _onItemTapped,
            ),
          ),
          Positioned(
            top: -30, // Sesuaikan dengan berapa jauh ikon menonjol ke atas
            left: MediaQuery.of(context).size.width / 2 -
                31.5, // Tengah-tengah layar
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Color(0xFFA41724),
                borderRadius:
                    BorderRadius.circular(10), // Membuat lingkaran penuh
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0,
                        3), // Ubah offset agar shadow berada di bawah bottom nav
                  ),
                ],
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
