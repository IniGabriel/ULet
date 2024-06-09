import 'package:flutter/material.dart';
import 'package:ulet_1/pages/home_page/home_page.dart';
import 'dart:math';

import 'package:ulet_1/pages/profile_page/profile_page.dart';
import 'package:ulet_1/pages/transfer_page/transfer_page.dart';

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
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransferPage()),
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
    );
  }
}

void main() {
  runApp(const MyApp());
}
