import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .doc(_currentUser.uid)
              .collection('history')
              .orderBy('transaction_date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No transaction history found.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];

                // Determine the transaction type
                String transactionType = data['transaction_type'];
                Widget trailingWidget;

                if (transactionType == 'transfer') {
                  trailingWidget = Text(
                    'Transferred to ${data['recipient_name']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                } else if (transactionType == 'top_up') {
                  trailingWidget = Text(
                    'Top-up from ${data['description']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                } else {
                  // If there are other types of transactions, handle them here
                  trailingWidget = Text(
                    'Other Transaction',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }

                return ListTile(
                  title: Text(
                    '${DateFormat.yMMMMd().add_jm().format(data['transaction_date'].toDate())}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactionType.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      trailingWidget,
                    ],
                  ),
                  trailing: Text(
                    '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(data['amount'])}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
