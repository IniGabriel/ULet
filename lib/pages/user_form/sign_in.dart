import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../utils/colors.dart';
import '../../utils/font_size.dart';

import 'package:ulet_1/pages/user_form/sign_up.dart';
import 'package:ulet_1/pages/user_form/pin_verification.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _phoneNumberLengthController =
      TextEditingController();
  bool _isContinueButtonEnabled = false;

  @override
  void dispose() {
    _phoneNumberLengthController.dispose();
    super.dispose();
  }

  void _checkPhoneNumberLength() {
    setState(() {
      _isContinueButtonEnabled =
          _phoneNumberLengthController.text.length >= 10 &&
              _phoneNumberLengthController.text.length <= 14;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                    child: Image.asset(
                      'images/ULET.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Welcome to ULet!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Sign in or create an account to get started.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phone Number',
                              style: TextStyle(
                                fontSize: CustomFontSize.primaryFontSize,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                CountryFlag.fromCountryCode(
                                  'ID',
                                  height: 20,
                                  width: 20,
                                  borderRadius: 5,
                                ),
                                const SizedBox(width: 5.0),
                                const Text(
                                  '+62',
                                  style: TextStyle(
                                    fontSize: CustomFontSize.primaryFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40.0,
                                        child: TextField(
                                          keyboardType: TextInputType.phone,
                                          controller:
                                              _phoneNumberLengthController,
                                          onChanged: (_) =>
                                              _checkPhoneNumberLength(),
                                          decoration: const InputDecoration(
                                            labelText: '812-1234-XXXX',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: CustomColors
                                                      .primaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: CustomColors
                                                      .primaryColor),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                          ),
                                          style: const TextStyle(
                                              fontSize: CustomFontSize
                                                  .primaryFontSize),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: _isContinueButtonEnabled
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PINVerification(),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 0),
                            backgroundColor: CustomColors.primaryColor,
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                                fontSize: CustomFontSize.primaryFontSize),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: CustomFontSize.primaryFontSize,
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
          ),
        ),
      ),
    );
  }
}
