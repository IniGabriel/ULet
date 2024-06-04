// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ulet_1/pages/user_form/sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text('Profile'),
      //   centerTitle: true,
      //   backgroundColor: Colors.red[600],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container for the profile picture
            Container(
              color: Color(0xFFA41724), // Latar belakang merah
              width: double.infinity,
              padding:
                  EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 56),
              child: Column(
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/tester_.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // Spacer between image and text
                      // Column for the name and number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '0821 1234 5678',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              print("Berhasil ditekan!");
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.qr_code_2,
                                    color: Colors.grey[300],
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Show QR Code',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40), // Spacer between image and text
            // Text "Halo"
            OpsiProfile(
              icon: Icons.lock_reset, // Ikon untuk opsi pertama
              text: "Change Password", // Teks untuk opsi pertama
            ),
            OpsiProfile(
              icon: Icons.account_circle, // Ikon untuk opsi kedua
              text: "Profile", // Teks untuk opsi kedua
            ),
            OpsiProfile(
              icon: Icons.phone_android, // Ikon untuk opsi ketiga
              text: "Mobile", // Teks untuk opsi ketiga
            ),
            OpsiProfile(
              icon: Icons.home, // Ikon untuk opsi keempat
              text: "Home", // Teks untuk opsi keempat
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 22), // Tambahkan padding kiri dan kanan
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                    (route) => false,
                  );
                  // print("Button Log Out Di Tekan!");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFA41724),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Log Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpsiProfile extends StatelessWidget {
  final IconData icon;
  final String text;

  const OpsiProfile({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("$text Di Tekan!");
        // Lakukan tindakan sesuai dengan opsi yang dipilih
      },
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Icon(icon),
        ),
        title: Text(text),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
