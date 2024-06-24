import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulet_1/api/wallet.dart';
import 'package:ulet_1/firebase/history.dart';
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

  Future<void> updatePhoneNumber(String uid, String newPhoneNumber) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'phone_number': newPhoneNumber,
      });
      print('Phone number updated successfully.');
    } catch (e) {
      print('Error updating phone number: $e');
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

  Future<String> transferBalance(String toNumber, int amount, String info) async {
    try {
      // Step 1: Find walletId associated with toNumber
      String otherWalletId = await findWalletId(toNumber);

      if (otherWalletId == "Not Found") {
        return "Phone Number Not Found";
      }

      // Step 2: Post bill to the recipient's wallet
      String transId = await Wallet().postBill(otherWalletId, amount, info);

      // Step 3: Retrieve current user's data
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
              String senderWallet = userData['wallet_id'] as String;

              // Step 4: Pay the bill from sender's wallet
              await Wallet().payBill(senderWallet, transId);

              // Step 5: Determine transaction direction
              String transactionDirection;
              if (toNumber == user.phoneNumber) {
                transactionDirection = 'top_up'; // Self top-up
              } else {
                transactionDirection = 'transfer';
              }

              // Step 6: Store transaction history
              if (transactionDirection == 'transfer') {
                await History().storeTransferHistory(
                  transId: transId,
                  transDate: DateTime.now(),
                  amount: amount.toDouble(),
                  senderName: userData['phone_number'],
                  recipientName: toNumber,
                  description: info,
                );
              } else if (transactionDirection == 'top_up') {
                await History().storeTopUpHistory(transId, DateTime.now(), amount);
              }

              return "Success";
            }
          }
        }
      }

      return "Error: User data not found";
    } catch (e) {
      print("Error in transferBalance: $e");
      return "Error: Something went wrong";
    }
  }

  Future<String> findWalletId(String otherPhoneNumber) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phone_number', isEqualTo: otherPhoneNumber)
              .limit(1)
              .get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          querySnapshot.docs;

      if (docs.isNotEmpty) {
        final Map<String, dynamic>? userData = docs.first.data();
        if (userData != null && userData.containsKey('wallet_id')) {
          return userData['wallet_id'] as String;
        } else {
          return 'Wallet ID Not Found';
        }
      } else {
        return 'User Not Found';
      }
    } catch (e) {
      print('Error finding wallet ID: $e');
      return 'Error';
    }
  }



  Future<String> _verifyPin(String enteredPin) async {
    try {
      String phoneNumber = await getCurrentUserPhoneNumber();

      if (phoneNumber == 'Not Found' || phoneNumber == 'Error') {
        return 'Error';
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phone_number', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs;

      if (docs.isNotEmpty) {
        Map<String, dynamic>? userData = docs.first.data();
        if (userData != null && userData.containsKey('pin')) {
          String storedPinWithSalts = userData['pin'];

          // Gunakan Security untuk memverifikasi PIN
          Security security = Security();
          bool isPinCorrect = security.comparePins(enteredPin, storedPinWithSalts);

          if (isPinCorrect) {
            return 'Success';
          } else {
            return 'Wrong PIN';
          }
        } else {
          return 'PIN not set';
        }
      } else {
        return 'User data not found';
      }
    } catch (e) {
      print('Error verifying PIN: $e');
      return 'Error';
    }
  }
}