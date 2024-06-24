import 'package:flutter/material.dart';
import 'package:ulet_1/pages/qr/qr_generator.dart';
import 'package:ulet_1/pages/user_form/sign_in.dart';
import 'package:ulet_1/utils/snackbar_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/firebase/firebase_profile.dart';
import 'package:ulet_1/pages/user_form/otp_verification.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _phoneNumber;
  String? _fullName;
  String? imageUrl;
  bool _isLoading = false; 


  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

// To log out from current account
  void _signOut() async {
    _setLoading(true);
    await PhoneAuth().signOut();
    bool isSignedOut = await PhoneAuth().isSignedOut();
    if (mounted) {
      if (isSignedOut) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignIn(),
          ),
        );
      } else {
        CustomSnackbarAlert().showSnackbarError('Failed to sign out', context);
      }
      _setLoading(false);
    }
  }

// Get phonenumber from phone_auth.dart, to display it in profile page

  Future<void> _getPhoneNumber() async {
    try {
      String phoneNumber = await PhoneAuth().getCurrentUserPhoneNumber();
      setState(() {
        _phoneNumber = phoneNumber;
      });
    } catch (e) {
      print('Error getting phone number: $e');
    }
  }

// Get username from phone_auth.dart, to display it in profile page
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

// To load image for the first time, and it used when _changeProfilePicture is called
  Future<void> _loadImage(String nama) async {
    String downloadUserUrl = await FirebaseProfile().getImageUrl(nama);

    setState(() {
      imageUrl = downloadUserUrl;
    }); 
  }

  @override
  void initState() {
    super.initState();
    _getPhoneNumber().then((_) {
      if (_phoneNumber != null) {
        _getFullName().then((_) {
          if (_fullName != null) {
            _loadImage(_phoneNumber!);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color(0xFFA41724),
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 56),
                  child: Column(
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(imageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imageUrl == null
                                ? Center(child: CircularProgressIndicator())
                                : null,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_fullName != null)
                                Text(
                                  _fullName!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              SizedBox(height: 10),
                              if (_phoneNumber != null)
                                Text(
                                  _phoneNumber!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[300],
                                  ),
                                )
                              else
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => QRGenerator()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.qr_code_2,
                                        color: Colors.grey[300],
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Show QR Code',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                if (_fullName != null) ...[
                  OpsiProfile(
                    icon: Icons.account_circle,
                    text: "Change Profile Picture",
                    fullName: _fullName!,
                    phoneNumber: _phoneNumber!,
                    loadImage: _loadImage,
                    getFullName: _getFullName,
                    setLoading: _setLoading,
                  ),
                  OpsiProfile(
                    icon: Icons.edit,
                    text: "Change Username",
                    fullName: _fullName!,
                    phoneNumber: _phoneNumber!,
                    loadImage: _loadImage,
                    getFullName: _getFullName,
                    setLoading: _setLoading,
                  ),
                  OpsiProfile(
                    icon: Icons.lock_reset,
                    text: "Change Pin",
                    fullName: _fullName!,
                    phoneNumber: _phoneNumber!,
                    loadImage: _loadImage,
                    getFullName: _getFullName,
                    setLoading: _setLoading,
                  ),
                ] else ...[
                  Center(child: CircularProgressIndicator())
                ],
                SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: ElevatedButton(
                    onPressed: _signOut,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFA41724),
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Sign out"),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) // Add this block to show a loading indicator
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class OpsiProfile extends StatefulWidget {
  final IconData icon;
  final String text;
  final String fullName;
  final String phoneNumber;
  final Function(String) loadImage;
  final Future<void> Function() getFullName;
  final Function(bool) setLoading;

  const OpsiProfile({
    Key? key,
    required this.icon,
    required this.text,
    required this.fullName,
    required this.phoneNumber,
    required this.loadImage,
    required this.getFullName,
    required this.setLoading,
  }) : super(key: key);

  @override
  _OpsiProfileState createState() => _OpsiProfileState();
}

class _OpsiProfileState extends State<OpsiProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Change Profile Picture
  void _changeProfile(String? phoneNumber) async {
    if (phoneNumber == null) return;

    widget.setLoading(true);

    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) {
      widget.setLoading(false);
      return;
    }

    FirebaseProfile().changeProfile(phoneNumber, file);
    await Future.delayed(Duration(seconds: 2));
    widget.loadImage(phoneNumber);
    widget.setLoading(false);
  }

  // To give a form for changing username, after that it will go to the _changeUsername function
  void _formUsername(String fullName, String phoneNumber) async {
    try {
      String newUsername = '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Change Username'),
                content: TextField(
                  decoration: InputDecoration(hintText: 'Enter new username'),
                  onChanged: (value) {
                    setState(() {
                      newUsername = value;
                    });
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _changeUsername(newUsername,phoneNumber);
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error');
    }
  }

  // To save the new username
  void _changeUsername(String newUsername, String phoneNumber) async {
    User? user = _auth.currentUser;
    String userId = user!.uid;

    widget.setLoading(true);
    FirebaseProfile().changeUsername(newUsername, userId);

    await user.updateDisplayName(newUsername);
    widget.getFullName();
    widget.setLoading(false);
  }

  // Change Pin
  void _changePin() async {
    String note = "change pin";
    String newNumber = widget.phoneNumber.replaceFirst('+62', '');
    
    await PhoneAuth().sendOTP(newNumber,
      (String verificationId) {
        Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => OTPVerification(
          verificationId: verificationId,
          phoneNumber: newNumber,
          note: note,
          ),
        ),
      );
    });    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.text == "Change Profile Picture") {
          _changeProfile(widget.phoneNumber);
        } else if (widget.text == "Change Username") {
          _formUsername(widget.fullName, widget.phoneNumber);
        } else if (widget.text == "Change Pin") {
            _changePin();
          } else {
          print("${widget.text} Di Tekan!");
        }
      },
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Icon(widget.icon),
        ),
        title: Text(widget.text),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
