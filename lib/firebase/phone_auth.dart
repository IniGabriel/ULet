import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ulet_1/security/hashing.dart';

class PhoneAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // to send OTP Code to phone number
  Future<void> sendOTP(String phoneNumber, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+62$phoneNumber',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print('Error sending OTP: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // to verify OTP and store user credential if user first time creating account
  Future<bool> isOTPVerified({
    required String verificationId,
    String? fullName,
    String? pin,
    required String otp,
  }) async {
    try {
      final PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(authCredential);
      if (fullName != null && pin != null) {
        await storeUserCredential(
            fullName, userCredential.user!.phoneNumber!, pin);
        return true;
      } else if (userCredential.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

// store user credential to firestore
  Future<void> storeUserCredential(
      String fullName, String phoneNumber, String pin) async {
    try {
      User? user = _auth.currentUser;
      String userId = user!.uid;
      String hashedPin = Security().hashPin(pin);
      await _firestore.collection('users').doc(userId).set({
        'full_name': fullName,
        'phone_number': phoneNumber,
        'pin': hashedPin,
      });
    } catch (e) {
      print('Error storing user credential: $e');
    }
  }

  // sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // check if user is signed out
  Future<bool> isSignedOut() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error signing out: $e');
      return false;
    }
  }

  Future<String> getCurrentUserPhoneNumber() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print(user.phoneNumber.toString());
        return user.phoneNumber.toString();
      }
      return 'Not Found';
    } catch (e) {
      print('Error getting current user phone number: $e');
      return 'Error';
    }
  }
Future<String> getCurrentUserFullName(String phoneNumber) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone_number', isEqualTo: phoneNumber)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String userName = querySnapshot.docs.first.get('full_name');
      print(userName);
      return userName;
    } else {
      print('No user found with the given phone number.');
      return 'Not Found';
    }
  } catch (e) {
    print('Error getting full name: $e');
    return 'Error';
  }
}

}
