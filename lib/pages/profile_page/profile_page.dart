import 'package:flutter/material.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/pages/changenumber_page/change_phone_number.dart';
import 'package:ulet_1/pages/qr/qr_generator.dart';
import 'package:ulet_1/pages/user_form/sign_in.dart';
import 'package:ulet_1/utils/snackbar_alert.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _phoneNumber;
  String? _fullName;

  void _signOut() async {
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

  Future<void> _getFullName(String phoneNumber) async {
    try {
      String fullName = await PhoneAuth().getCurrentUserFullName(phoneNumber);
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
    _getPhoneNumber().then((_) {
      if (_phoneNumber != null) {
        _getFullName(_phoneNumber!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFFA41724),
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 22, right: 22, top: 15, bottom: 56),
              child: Column(
                children: [
                  const Text(
                    "Profile",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/tester_.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_fullName != null)
                            Text(
                              _fullName!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          else
                            const Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      QRGenerator()));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
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
                                  const SizedBox(width: 5),
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
            const SizedBox(height: 40),
            const OpsiProfile(
              icon: Icons.lock_reset,
              text: "Change Password",
            ),
            const OpsiProfile(
              icon: Icons.account_circle,
              text: "Profile",
            ),
            OpsiProfile(
              icon: Icons.phone_android,
              text: "Change Phone Number",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangePhoneNumberPage()));
              },
            ),
            const OpsiProfile(
              icon: Icons.lock_reset,
              text: "Change Pin",
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFA41724),
                  textStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Sign out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpsiProfile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback?
      onTap; // Tambahkan tanda tanya (?) untuk membuatnya opsional

  const OpsiProfile({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap, // Tandai sebagai opsional dengan menggunakan tanda tanya
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap, // Gunakan onTap sesuai dengan nilai yang diberikan atau null jika tidak ada
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: Icon(icon),
        ),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}



// class OpsiProfile extends StatelessWidget {
//   final IconData icon;
//   final String text;

//   const OpsiProfile({Key? key, required this.icon, required this.text})
//       : super(key: key);
// @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print("$text Di Tekan!");
//       },
//       child: ListTile(
//         leading: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//             color: Colors.grey.withOpacity(0.1),
//           ),
//           child: Icon(icon),
//         ),
//         title: Text(text),
//         trailing: const Icon(Icons.arrow_forward_ios),
//       ),
//     );
//   }
// }

  