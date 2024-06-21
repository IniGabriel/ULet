import 'package:flutter/material.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/pages/qr/qr_generator.dart';
import 'package:ulet_1/pages/user_form/sign_in.dart';
import 'package:ulet_1/utils/snackbar_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

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

  Future<void> _getFullName() async {
    try {
      String fullName = await PhoneAuth().getCurrentUserFullName();
      setState(() {
        _fullName = fullName;
        print('full name adalah : $_fullName');
      });
    } catch (e) {
      print('Error getting full name: $e');
    }
  }

  Future<void> _loadImage(String nama) async {
    try {
      final userRef = FirebaseStorage.instance.refFromURL('gs://ulet-a6713.appspot.com/$nama');
      String downloadUserUrl = await userRef.getDownloadURL();
      print(downloadUserUrl);
      print(userRef);

      setState(() {
        imageUrl = downloadUserUrl;
      });
    } catch (e) {
      print('AdAA ERRRORRRRRR : $e');
      final defaultRef = FirebaseStorage.instance.refFromURL('gs://ulet-a6713.appspot.com/tester.jpg');
      String downloadURL = await defaultRef.getDownloadURL();
      setState(() {
        imageUrl = downloadURL;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPhoneNumber().then((_) {
      if (_phoneNumber != null) {
        _getFullName().then((_) {
          if (_fullName != null) {
            _loadImage(_fullName!);
          }
        });
        print('kelar load image');
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
                    icon: Icons.lock_reset,
                    text: "Change Username",
                    fullName: _fullName!,
                    phoneNumber: _phoneNumber!,
                    loadImage: _loadImage,
                    getFullName: _getFullName,
                    setLoading: _setLoading,
                  ),
                  OpsiProfile(
                    icon: Icons.phone_android,
                    text: "Mobile",
                    fullName: _fullName!,
                    phoneNumber: _phoneNumber!,
                    loadImage: _loadImage,
                    getFullName: _getFullName,
                    setLoading: _setLoading,
                  ),
                  OpsiProfile(
                    icon: Icons.home,
                    text: "Home",
                    fullName: _fullName!,
                    phoneNumber: _phoneNumber!,
                    loadImage: _loadImage,
                    getFullName: _getFullName,
                    setLoading: _setLoading,
                  ),
                ] else ...[
                  Center(child: CircularProgressIndicator())
                ],
                SizedBox(height: 50),
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

  void _changeProfile(String? fullName) async {
    try {
      if (fullName == null) return;

      widget.setLoading(true);

      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      print('${file?.path}');

      if (file == null) {
        widget.setLoading(false);
        return;
      }

      final storageRef = FirebaseStorage.instance.ref();
      final String fileName = fullName;
      final imageRef = storageRef.child(fileName);

      await imageRef.putFile(File(file.path));
      widget.loadImage(fileName);

      widget.setLoading(false);
    } catch (e) {
      print('Error during profile picture upload: $e');
      widget.setLoading(false);
    }
  }

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
                      _changeUsername(newUsername, fullName, phoneNumber);
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

  void _changeUsername(String newUsername, fullName, phoneNumber) async {
    User? user = _auth.currentUser;
    String userId = user!.uid;

    widget.setLoading(true);

    try{
    final oldFileRef = FirebaseStorage.instance.ref().child(fullName);
    final oldFileData = await oldFileRef.getData();
    final Uint8List data = oldFileData!;

    final newFileRef = FirebaseStorage.instance.ref().child(newUsername);
    await newFileRef.putData(data);
    await oldFileRef.delete();
    } catch (e){
      print('Belum pernah ganti gambar!');
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'full_name': newUsername}, SetOptions(merge: true))
        .then((_) {
      print('Full name updated successfully');
    });

    await user.updateDisplayName(newUsername);
    print(user);
    widget.getFullName();

    widget.getFullName();
    // widget.loadImage(newUsername);

    widget.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.text == "Change Profile Picture") {
          _changeProfile(widget.fullName);
        } else if (widget.text == "Change Username") {
          _formUsername(widget.fullName, widget.phoneNumber);
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
