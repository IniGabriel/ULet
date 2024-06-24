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

    // Store transfer history for the sender
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
      'transaction_direction': 'sent',
    });

    // Retrieve recipient's data
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore
            .collection('users')
            .where('phone_number', isEqualTo: recipientName)
            .limit(1)
            .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        querySnapshot.docs;

    if (docs.isNotEmpty) {
      final Map<String, dynamic>? userData = docs.first.data();
      if (userData != null) {
        // Store receive history for the recipient
        await _firestore
            .collection('users')
            .doc(docs.first.id)
            .collection('history')
            .doc(transId)
            .set({
          'transaction_type': 'receive',
          'transaction_date': timestamp,
          'sender_name': senderName,
          'recipient_name': recipientName,
          'description': description,
          'amount': amount,
          'transaction_direction': 'received',
        });
      }
    }
  } catch (e) {
    print('Error storing transfer history: $e');
  }
}

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
        'description': 'Top up from PAY.TUNGKUAPI',
        'amount': amount,
        'transaction_direction': 'top_up',
      });
    } catch (e) {
      print('Error storing top up history: $e');
    }
  }
}
