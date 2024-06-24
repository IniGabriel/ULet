import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/security/hashing.dart';

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
  List<TextEditingController> _pinControllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> _pinFocusNodes = List.generate(6, (index) => FocusNode());
  bool _isAmountFilled = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _pinControllers.forEach((controller) => controller.dispose());
    _pinFocusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  Future<String> _verifyPin(String enteredPin) async {
    try {
      String phoneNumber = await PhoneAuth().getCurrentUserPhoneNumber();

      if (phoneNumber == 'Not Found' || phoneNumber == 'Error') {
        return 'Error';
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone_number', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs;

      if (docs.isNotEmpty) {
        Map<String, dynamic>? userData = docs.first.data();
        if (userData != null && userData.containsKey('pin')) {
          String storedPinWithSalts = userData['pin'];
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

  Future<void> _processPin() async {
  String enteredPin = _pinControllers.map((controller) => controller.text).join();
  String hashedEnteredPin = Security().hashPin(enteredPin);

  String pinVerificationResult = await _verifyPin(enteredPin);

    if (pinVerificationResult == 'Success') {
      String amount = _amountController.text.trim();
      String description = _descriptionController.text.trim();

      if (!isNumeric(amount)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Amount should be a number')),
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

      if (response == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$response Transferring $amount to ${widget.phoneNumber}')),
        );

        await Future.delayed(Duration(seconds: 0));


        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer failed: $response')),
        );
      }
    } else {
      // Clear all PIN input fields
      _pinControllers.forEach((controller) {
        controller.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$pinVerificationResult. Please try again.')),
      );
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double pinBoxSize = screenWidth * 0.09;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Amount', 
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 164, 23, 36),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _isAmountFilled = value.isNotEmpty;
                });
              },
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
              onPressed: _isAmountFilled
                  ? () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Enter PIN'),
                            content: SizedBox(
                              width: pinBoxSize * 10,
                              height: pinBoxSize,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  6,
                                  (index) => Container(
                                    width: pinBoxSize,
                                    height: pinBoxSize,
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    child: TextFormField(
                                      controller: _pinControllers[index],
                                      focusNode: _pinFocusNodes[index],
                                      obscureText: true,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          // Handle deletion of characters
                                          if (index > 0) {
                                            // Move focus to previous field
                                            FocusScope.of(context).requestFocus(_pinFocusNodes[index - 1]);
                                          }
                                        } else {
                                          // Move focus to next field or process PIN
                                          if (index < 5) {
                                            FocusScope.of(context).requestFocus(_pinFocusNodes[index + 1]);
                                          } else {
                                            _processPin();
                                            Navigator.of(context).pop(); // Close the dialog
                                          }
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        counterText: '',
                                      ),
                                      maxLength: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('Cancel', style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  : null,
              child: Text('Transfer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 164, 23, 36),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
