import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class History {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // store top up to history
  Future<void> storeTopUpHistory(
      String transId, String transDate, int amount) async {
    try {
      User? user = _auth.currentUser;
      String userID = user!.uid;
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('history')
          .doc(transId)
          .set({
        'transaction_type': 'top_up',
        'transaction_date': transDate,
        'user_id': '',
        'description': 'Top up from PAY.TUNGKUAPI',
        'amount': amount,
      });
    } catch (e) {
      print('Error storing top up history: $e');
    }
  }
}
