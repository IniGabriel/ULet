import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulet_1/firebase/phone_auth.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currentUser;
  String? _fullName;

  Future<void> _getFullName() async {
    try {
      String fullName = await PhoneAuth().getCurrentUserFullName();
      setState(() {
        _fullName = fullName;
      });
    } catch (e) {
      print('Error getting full name: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _getFullName();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: screenHeight * 0.20,
            color: Color(0xFFA41724),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10), // Add spacing between text and other content
                if (_fullName != null)
                  Text(
                    _fullName!,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  )
                else
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
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

                    // Get common transaction details
                    String transactionType = data['transaction_type'];
                    String description = data['description'];
                    String senderName = data['sender_name'];
                    String recipientName = data['recipient_name'];
                    String transactionDirection = data['transaction_direction'];

                    // Determine trailing widget based on transaction type
                    Widget trailingWidget;
                    if (transactionType == 'transfer') {
                      trailingWidget = Text(
                        '-${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(data['amount'])}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      );
                    } else if (transactionType == 'top_up') {
                      trailingWidget = Text(
                        '+${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(data['amount'])}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      );
                    } else if (transactionType == 'receive') {
                      trailingWidget = Text(
                        '+${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(data['amount'])}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      );
                    } else {
                      trailingWidget = Text(
                        'Other Transaction',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      );
                    }


// Determine title and subtitle based on transaction direction
String title;
String subtitle;

if (transactionType == 'top_up') {
    title = 'Sent to $recipientName';
    subtitle = 'Top-up';
} else if (transactionDirection == 'sent') {
    title = 'Sent to $recipientName';
    subtitle = 'Transferred To';
} else if (transactionDirection == 'received') {
    title = 'Received from $senderName';
    subtitle = 'Transferred From';
} else {
    title = 'Unknown';
    subtitle = 'Unknown';
}

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Color(0xFFFCEDEE), // Set background color
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10), // Adjust padding as needed
                          child: ListTile(
                            contentPadding: EdgeInsets.zero, // Remove ListTile padding
                            title: Text(
                              '${DateFormat.yMMMMd().add_jm().format(data['transaction_date'].toDate())}',
                              style: TextStyle(fontSize: 12), // Set font size for title
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transactionType.toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  description,
                                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: trailingWidget,
                          ),
                        ),
                        SizedBox(height: 10), // Add space between containers
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
