import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ulet_1/firebase/firebase_service.dart';


class AddNumberPage extends StatefulWidget {
  @override
  _AddNumberPageState createState() => _AddNumberPageState();
}

class _AddNumberPageState extends State<AddNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _addPhoneNumber() async {
    String newPhoneNumber = _normalizePhoneNumber(_phoneNumberController.text.trim());

    // Validasi nomor telepon
    if (newPhoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a phone number')));
      return;
    }

    String currentUserPhoneNumber = await _firebaseService.getCurrentUserPhoneNumber();

    if (newPhoneNumber == currentUserPhoneNumber) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot add your own number')));
      return;
    }

    try {
      await _firebaseService.addPhoneNumber(newPhoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Number Added: $newPhoneNumber')));
      Navigator.pop(context, newPhoneNumber); // Return the new phone number
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  String _normalizePhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '+62' + phoneNumber.substring(1);
    }
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFA41724),
        leading: IconButton(
          icon: SvgPicture.string(
            '''<svg width="30" height="30" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M18.8637 5.74209L9.30587 13.9323C9.15189 14.0643 9.02829 14.2281 8.94355 14.4124C8.85882 14.5967 8.81494 14.7971 8.81494 14.9999C8.81494 15.2027 8.85882 15.4032 8.94355 15.5874C9.02829 15.7717 9.15189 15.9355 9.30587 16.0675L18.8637 24.2577C19.776 25.0394 21.1852 24.3913 21.1852 23.1901V6.80733C21.1852 5.60615 19.776 4.95811 18.8637 5.74209Z" fill="white"/>
</svg>''',
            width: 30,
            height: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Number',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'images/ULET.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFCEDEE), // Warna background
                      borderRadius: BorderRadius.circular(10), // Radius border
                      border: Border.all(color: Color(0xFFFFCED2)), // Warna border
                    ),
                    child: TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Input Number',
                        labelStyle: TextStyle(color: Color(0xFF000000).withOpacity(0.5), fontSize: 19 * 0.8), // Label text color
                        border: InputBorder.none, // Hilangkan border default
                        contentPadding: EdgeInsets.symmetric(horizontal: 15), // Padding konten
                      ),
                      keyboardType: TextInputType.number, // Accept only numbers
                      style: TextStyle(color: Color(0xFFA41724)), // Input text color
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA41724), // Button background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0), // Padding tombol
                    shape: RoundedRectangleBorder( // Menghilangkan sudut tombol
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
