import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
            color: Color(0xFFA41724),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: SvgPicture.string(
                      '''<svg width="14" height="20" viewBox="0 0 14 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M10.8637 0.742092L1.30587 8.93233C1.15189 9.06434 1.02829 9.22811 0.943554 9.41238C0.858815 9.59666 0.814941 9.79708 0.814941 9.9999C0.814941 10.2027 0.858815 10.4032 0.943554 10.5874C1.02829 10.7717 1.15189 10.9355 1.30587 11.0675L10.8637 19.2577C11.776 20.0394 13.1852 19.3913 13.1852 18.1901V1.80733C13.1852 0.606154 11.776 -0.0418927 10.8637 0.742092Z" fill="white"/></svg>''',
                      width: 14,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Number',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  // image: AssetImage('images/ULET.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Input Number',
                      labelStyle: TextStyle(color: Color(0xFFFCEDEE)), // Warna teks label
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFCED2)), // Warna border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFCED2)), // Warna border saat aktif
                      ),
                    ),
                    keyboardType: TextInputType.number, // Hanya menerima angka
                    style: TextStyle(color: Color(0xFFFCEDEE)), // Warna teks input
                  ),
                  // Tambahan Widget lainnya di sini
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
