import 'package:flutter/material.dart';
import 'package:ulet_1/api/wallet.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/pages/profile_page/profile_page.dart';
import 'package:ulet_1/pages/history_page/history_page.dart';
import 'package:ulet_1/pages/qr/qr_generator.dart';
import 'package:ulet_1/pages/qr/qr_scanner.dart';
import 'package:ulet_1/pages/transfer_page/transfer_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _phoneNumber;
  String? _fullName;
  double? _balance;
  bool isHidden = false; // Variabel untuk melacak status visibilitas
  int _selectedIndex = 0; // Indeks item yang dipilih

  @override
  void initState() {
    super.initState();
    _getPhoneNumber().then((_) {
      if (_phoneNumber != null) {
        _getFullName(_phoneNumber!);
        _getWalletBalance();
      }
    });
  }

  Future<void> _getPhoneNumber() async {
    try {
      String phoneNumber = await PhoneAuth().getCurrentUserPhoneNumber();
      setState(() {
        _phoneNumber = phoneNumber;
      });
    } catch (e) {
      print('Error getting phone number: $e');
    }
  }

  Future<void> _getFullName(String phoneNumber) async {
    try {
      String fullName = await PhoneAuth().getCurrentUserFullName();
      setState(() {
        _fullName = fullName;
      });
    } catch (e) {
      print('Error getting full name: $e');
    }
  }

  Future<void> _getWalletBalance() async {
    try {
      double balance = await PhoneAuth().getWalletBalanceCurrentUser();
      setState(() {
        _balance = balance;
      });
      print('Wallet balance: $_balance');
    } catch (e) {
      print('Error getting wallet balance: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TransferPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index; // Update indeks saat item dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color(0xFFFFF6F6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Image.asset(
                    'images/ULET2.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Text(
                    "Hello, $_fullName",
                    style: const TextStyle(
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
                color: const Color(0xFFA41724),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
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
                              : 'Rp. ${NumberFormat.decimalPattern('id_ID').format(_balance ?? 0)}',
                          style: const TextStyle(
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
                        "$_fullName", // Ganti dengan nominal saldo yang sesuai
                        style: const TextStyle(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const TransferPage()));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.compare_arrows,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const QRScanner()));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
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
                  const SizedBox(height: 40), // Jarak antara baris
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  QRGenerator()));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Receive',
                              style: const TextStyle(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  HistoryPage()));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA41724),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.history,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFA41724),
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
