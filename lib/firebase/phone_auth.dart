import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulet_1/api/wallet.dart';

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
    String? email,
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
      if (fullName != null && email != null && pin != null) {
        await Wallet().postRegisterWallet(email, fullName);
        String walletID = await Wallet().getWalletID(email);
        await userCredential.user!.updateDisplayName(fullName);
        await storeUserCredential(
            fullName, walletID, email, userCredential.user!.phoneNumber!, pin);
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
  Future<void> storeUserCredential(String fullName, String walletID,
      String email, String phoneNumber, String pin) async {
    try {
      User? user = _auth.currentUser;
      String userId = user!.uid;
      String hashedPin = Security().hashPin(pin);
      await _firestore.collection('users').doc(userId).set({
        'wallet_id': walletID,
        'full_name': fullName,
        'email': email,
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

  // get current user's phone number
  Future<String> getCurrentUserPhoneNumber() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // print(user.phoneNumber.toString());
        return user.phoneNumber.toString();
      }
      return 'Not Found';
    } catch (e) {
      print('Error getting current user phone number: $e');
      return 'Error';
    }
  }

  // get current user's full name
  Future<String> getCurrentUserFullName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print(user.displayName.toString());
        print(user);
        return user.displayName.toString();
      }
      return 'Not Found';
      print('anehhhhhhhhhhhhhhhhhhhhhhhh');
    } catch (e) {
      print('Error getting current user dislay name: $e');
      return 'Error';
    }
  }

  // get current user's walletID
  Future<String> getWalletIDCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? phoneNumber = user.phoneNumber;
      if (phoneNumber != null) {
        final QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .where('phone_number', isEqualTo: phoneNumber)
                .limit(1)
                .get();

        final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
            querySnapshot.docs;
        if (docs.isNotEmpty) {
          final Map<String, dynamic>? userData = docs.first.data();
          if (userData != null) {
            return userData['wallet_id'] as String;
          }
        }
      }
    }
    return 'Not Found';
  }

Future<double> getWalletBalanceCurrentUser() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final String? phoneNumber = user.phoneNumber;
    if (phoneNumber != null) {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phone_number', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          querySnapshot.docs;
      if (docs.isNotEmpty) {
        final Map<String, dynamic>? userData = docs.first.data();
        if (userData != null) {
          double balance = await Wallet().getWalletBalance(userData['email']);
          return balance;
        }
      }
    }
  }
  return 0.0;
}

}