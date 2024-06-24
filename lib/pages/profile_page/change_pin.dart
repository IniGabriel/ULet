import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulet_1/security/hashing.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _repeatPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _pinController.dispose();
    _repeatPinController.dispose();
    super.dispose();
  }

// Save pin to firebase
  void _savePin() {
    if (_formKey.currentState!.validate()) {
      // Save the PIN
      String hashedPin = Security().hashPin(_pinController.text);

      User? user = _auth.currentUser;
      String userId = user!.uid;

      FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'pin': hashedPin}, SetOptions(merge: true))
        .then((_) {
      print('Pin updated successfully');
    });
      Navigator.pop(context, _pinController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA41724), // Warna merah
        foregroundColor: Colors.white,
        title: Text(
          'Change PIN',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center( // Menempatkan konten di tengah layar
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Memposisikan column ke tengah
              children: [
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'New PIN',
                  ),
                  obscureText: true,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new PIN';
                    }
                    if (value.length != 6) {
                      return 'PIN must be 6 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _repeatPinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Repeat PIN',
                  ),
                  obscureText: true,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please repeat your new PIN';
                    }
                    if (value != _pinController.text) {
                      return 'PINs do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _savePin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA41724), // Warna merah
                        foregroundColor: Colors.white, // Warna teks putih
                      ),
                      child: const Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Warna putih
                        foregroundColor: Colors.black, // Warna teks hitam
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
