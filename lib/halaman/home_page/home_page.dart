// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ulet_1/halaman/profile_page/profile_page.dart';

void main() {
  runApp(MyApp());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHidden = false; // Variabel untuk melacak status visibilitas
  // int _selectedIndex = 0; // Indeks item yang dipilih

  // void _onItemTapped(int index) {
  //   if (index == 4) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => ProfileScreen()),
  //     );
  //   } else {
  //     setState(() {
  //       _selectedIndex = index; // Update indeks saat item dipilih
  //     });
  //   }
  // }

  // var _pageController = PageContoller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFFF6F6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Image.asset(
                    'gambar_/ULET2.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Text(
                    "Hello, Username",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 360,
              height: 140,
              decoration: BoxDecoration(
                color: Color(0xFFA41724),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Text(
                      "Your Balance",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isHidden
                              ? "Rp. xxx.xxx.xxx"
                              : "Rp. 100.000.000", // Tampilan berdasarkan status visibilitas
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isHidden = !isHidden; // Toggle status visibilitas
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Username", // Ganti dengan nominal saldo yang sesuai
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Tindakan ketika kotak pertama ditekan
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.compare_arrows,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Transfer',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Tindakan ketika kotak kedua ditekan
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pay QR',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40), // Jarak antara baris pertama dan kedua
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Tindakan ketika kotak ketiga ditekan
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.history,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'History',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Tindakan ketika kotak keempat ditekan
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.qr_code_2,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Show QR',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
