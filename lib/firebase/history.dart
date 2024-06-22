import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class History {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> storeTransferHistory({
    required String transId,
    required DateTime transDate,
    required double amount,
    required String senderName,
    required String recipientName,
    required String description,
  }) async {
    try {
      User? user = _auth.currentUser;
      String userID = user!.uid;
      Timestamp timestamp = Timestamp.fromDate(transDate);
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('history')
          .doc(transId)
          .set({
        'transaction_type': 'transfer',
        'transaction_date': timestamp,
        'sender_name': senderName,
        'recipient_name': recipientName,
        'description': description,
        'amount': amount,
      });
    } catch (e) {
      print('Error storing transfer history: $e');
    }
  }

  // store top up to history
  Future<void> storeTopUpHistory(
      String transId, DateTime transDate, int amount) async {
    try {
      User? user = _auth.currentUser;
      String userID = user!.uid;
      Timestamp timestamp = Timestamp.fromDate(transDate);
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('history')
          .doc(transId)
          .set({
        'transaction_type': 'top_up',
        'transaction_date': timestamp,
        'user_id': '',
        'description': 'Top up from PAY.TUNGKUAPI',
        'amount': amount,
      });
    } catch (e) {
      print('Error storing top up history: $e');
    }
  }
}
