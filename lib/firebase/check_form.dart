import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulet_1/security/hashing.dart';

class CheckForm {
  // check if provided phone number exists
  Future<bool> isPhoneNumberExists(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone_number', isEqualTo: '+62$phoneNumber')
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking phone number: $e');
      return false;
    }
  }

  // check if entered PIN is valid with the stored hashed PIN
  Future<bool> isPINValid(String phoneNumber, String pin) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone_number', isEqualTo: phoneNumber)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        String hashedPin = querySnapshot.docs.first.get('pin');
        bool isValid = Security().comparePins(pin, hashedPin);
        return isValid;
      }
      return false;
    } catch (e) {
      print('Error comparing PIN: $e');
      return false;
    }
  }
}
