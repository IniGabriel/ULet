import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> addPhoneNumber(String newPhoneNumber) async {
  User? user = _auth.currentUser;
  if (user != null) {
    DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot userDoc = await transaction.get(userDocRef);

      if (!userDoc.exists) {
        // Create the user document if it does not exist
        transaction.set(userDocRef, {'contactList': []});
      }

      List<dynamic> contactList = [];
      var userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('contactList')) {
        contactList = List.from(userData['contactList']);
      }

      bool isPhoneNumberExists = await _phoneNumberExists(newPhoneNumber);

      if (isPhoneNumberExists) {
        if (contactList.contains(newPhoneNumber)) {
          throw Exception("Number already exists in contact list");
        } else {
          contactList.add(newPhoneNumber);
          transaction.update(userDocRef, {'contactList': contactList});
        }
      } else {
        throw Exception("Number isn't registered in Firebase");
      }
    });
  } else {
    throw Exception("No user is signed in!");
  }
}

Future<bool> _phoneNumberExists(String phoneNumber) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('users')
      .where('phone_number', isEqualTo: phoneNumber)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

  Future<List<String>> getContactList() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('contactList')) {
          return List<String>.from(userData['contactList']);
        }
      }
    }
    return [];
  }

  Future<String?> getContactName(String phoneNumber) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('users')
      .where('phone_number', isEqualTo: phoneNumber)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.get('full_name') as String?;
  } else {
    return null;
  }
}

  Future<void> deletePhoneNumber(String phoneNumber) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(userDocRef);

        if (!userDoc.exists) {
          throw Exception("User document does not exist");
        }

        List<dynamic> contactList = [];
        var userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('contactList')) {
          contactList = List.from(userData['contactList']);
        }

        if (!contactList.contains(phoneNumber)) {
          throw Exception("Number does not exist in contact list");
        } else {
          contactList.remove(phoneNumber);
          transaction.update(userDocRef, {'contactList': contactList});
        }
      });
    } else {
      throw Exception("No user is signed in!");
    }
  }
}
