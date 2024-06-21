import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulet_1/firebase/check_form.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/security/hashing.dart';

class ChangePhoneNumberPage extends StatefulWidget {
  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CheckForm _checkForm = CheckForm();
  final PhoneAuth _phoneAuth = PhoneAuth();
  bool _isLoading = false;

  void _changePhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String newPhoneNumber = '+62${_phoneController.text}';
      String pin = _pinController.text;

      // Check if new phone number already exists
      bool phoneExists = await _checkForm.isPhoneNumberExists(newPhoneNumber);
      if (phoneExists) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number already exists')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Validate PIN
      User? user = _auth.currentUser;
      if (user != null) {
        String currentPhoneNumber = user.phoneNumber!;
        bool isPinValid = await _checkForm.isPINValid(currentPhoneNumber, pin);
        if (!isPinValid) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Invalid PIN')));
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Update phone number
        await _phoneAuth.updatePhoneNumber(user.uid, newPhoneNumber);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number updated successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: const Text('User not found')));
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: 'New Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: 'PIN'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your PIN';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _changePhoneNumber,
                      child: const Text('Change Phone Number'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
