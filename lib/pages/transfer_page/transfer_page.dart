import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ulet_1/pages/history_page/history_page.dart';
import 'package:ulet_1/pages/transfer_page/add_number_page.dart';
import 'package:ulet_1/firebase/firebase_service.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/pages/top_up/top_up.dart';
import 'package:intl/intl.dart';



class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {

  String? _phoneNumber;
  String? _fullName;
  List<String> _addedNumbers = [];
  final FirebaseService _firebaseService = FirebaseService();
  String _searchQuery = '';
  double? _balance;
  

Future<void> _getPhoneNumber() async {
  try {
    String phoneNumber = await PhoneAuth().getCurrentUserPhoneNumber();
    setState(() {
      _phoneNumber = phoneNumber;
    });
    print('Phone number: $_phoneNumber');
    if (_phoneNumber != null) {
      _getWalletBalance();
    }
  } catch (e) {
    print('Error getting phone number: $e');
  }
}

Future<void> _getWalletBalance() async {
  try {
    double balance = await PhoneAuth().getWalletBalanceCurrentUser();
    setState(() {
      _balance = balance;
    });
    print('Wallet balance: $_balance');
  } catch (e) {
    print('Error getting wallet balance: $e');
  }
}

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

  Future<void> _loadContactList() async {
    try {
      List<String> contactList = await _firebaseService.getContactList();
      setState(() {
        _addedNumbers = contactList;
      });
    } catch (e) {
      print('Error loading contact list: $e');
    }
  }

@override
void initState() {
  super.initState();
  _getPhoneNumber().then((_) {
    if (_phoneNumber != null) {
      _getFullName().then((_) {
        _loadContactList();
        _getWalletBalance();
      });
    }
  });
}

@override
Widget build(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    body: Column(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight * 0.41,
          color: Color(0xFFA41724),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_fullName != null)
                        Text(
                          _fullName!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        )
                      else
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 5),
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
  _balance != null
      ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 2)
          .format(_balance)
      : 'Loading...',
  style: TextStyle(
    color: Colors.white,
    fontSize: 28,
  ),
),

                    ],
                  ),
                ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: screenWidth * 0.36,
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              onTap: () async {
                                final addedNumber = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddNumberPage()),
                                );
                                if (addedNumber != null) {
                                  setState(() {
                                    _addedNumbers.add(addedNumber);
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.string(
                                    '''<svg width="31" height="31" viewBox="0 0 31 31" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15.5 5.16659C21.1975 5.16659 25.8333 9.80238 25.8333 15.4999C25.8333 21.1975 21.1975 25.8333 15.5 25.8333C9.80244 25.8333 5.16665 21.1975 5.16665 15.4999C5.16665 9.80238 9.80244 5.16659 15.5 5.16659ZM15.5 2.58325C8.3661 2.58325 2.58331 8.36604 2.58331 15.4999C2.58331 22.6338 8.3661 28.4166 15.5 28.4166C22.6339 28.4166 28.4166 22.6338 28.4166 15.4999C28.4166 8.36604 22.6339 2.58325 15.5 2.58325ZM21.9583 14.2083H16.7916V9.04158H14.2083V14.2083H9.04165V16.7916H14.2083V21.9583H16.7916V16.7916H21.9583V14.2083Z" fill="#0B0B0B"/></svg>''',
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Add Number',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: screenWidth * 0.36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HistoryPage()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.string(
                                      '''<svg width="31" height="26" viewBox="0 0 31 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M17.4167 0.25C14.0352 0.25 10.7922 1.5933 8.40107 3.98439C6.00999 6.37548 4.66669 9.61849 4.66669 13H0.416687L5.92752 18.5108L6.02669 18.7092L11.75 13H7.50002C7.50002 7.5175 11.9342 3.08333 17.4167 3.08333C22.8992 3.08333 27.3334 7.5175 27.3334 13C27.3334 18.4825 22.8992 22.9167 17.4167 22.9167C14.9118 22.9167 12.5479 21.9269 10.7909 20.1699L8.78661 22.1741C10.967 24.3546 13.962 25.75 17.4167 25.75C20.7982 25.7521 24.0412 24.4067 26.4323 22.0156C28.8234 19.6245 30.1667 16.3815 30.1667 13C30.1667 9.61849 28.8234 6.37548 26.4323 3.98439C24.0412 1.5933 20.7982 0.25 17.4167 0.25ZM16 7.33333V14.4167L22.0209 17.9867L23.1117 16.1592L18.125 13.1983V7.33333H16Z" fill="black"/>
                                      </svg>
                                      ''',
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'History',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: screenWidth * 0.36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TopUp()),
                            ).then((_) {
                              _getWalletBalance();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.atm_rounded,
                                  color: Colors.black,
                                  size: 35.0,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Top Up',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: 370.0, // Fixed width for the Container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Find Account',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFFCED2),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFFCED2),
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFFCED2),
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
  itemCount: _addedNumbers.length,
  itemBuilder: (context, index) {
    final phoneNumber = _addedNumbers[index];
    return FutureBuilder(
      future: _firebaseService.getContactName(phoneNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final contactName = snapshot.data as String? ?? phoneNumber;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 252, 237, 238),
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contactName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 5),
                    Text(phoneNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showConfirmationDialog(phoneNumber),
                ),
              ],
            ),
          );
        }
      },
    );
  },
),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50.0,)
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog(String phoneNumber) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this number from contacts?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deletePhoneNumber(phoneNumber); // Delete the number after confirmation
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePhoneNumber(String phoneNumber) async {
    try {
      await _firebaseService.deletePhoneNumber(phoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Number Deleted: $phoneNumber')));
      setState(() {
        _addedNumbers.remove(phoneNumber);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
