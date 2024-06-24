import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
class TransferAmountPage extends StatefulWidget {
  final String phoneNumber;
  final String contactName;

  const TransferAmountPage({
    Key? key,
    required this.phoneNumber,
    required this.contactName,
  }) : super(key: key);

  @override
  _TransferAmountPageState createState() => _TransferAmountPageState();
}

class _TransferAmountPageState extends State<TransferAmountPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Amount'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfer to:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.contactName,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              widget.phoneNumber,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
ElevatedButton(
  onPressed: () async {
    String amount = _amountController.text;
    String description = _descriptionController.text;

    if (amount.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    int amountValue = int.tryParse(amount) ?? 0;

    if (amountValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid amount')),
      );
      return;
    }

    String response = await PhoneAuth().transferBalance(
      widget.phoneNumber,
      amountValue,
      description,
    );

    if (response == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$response Transferring $amount to ${widget.phoneNumber}')),
      );
      // Optionally, navigate back to previous screen or perform other actions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer failed: $response')),
      );
    }
  },
  child: Text('Transfer'),
),

          ],
        ),
      ),
    );
  }
}
