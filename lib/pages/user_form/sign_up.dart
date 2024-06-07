import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/services.dart';

import 'package:ulet_1/utils/colors.dart';
import 'package:ulet_1/utils/font_size.dart';
import 'package:ulet_1/firebase/check_form.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/pages/user_form/otp_verification.dart';
import 'package:ulet_1/pages/user_form/sign_in.dart';
import 'package:ulet_1/utils/snackbar_alert.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isContinueButtonEnabled = false;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _fullNameController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _checkFields() {
    setState(() {
      _isContinueButtonEnabled = _phoneNumberController.text.length >= 10 &&
          _fullNameController.text.isNotEmpty &&
          _pinController.text.length == 6 &&
          _confirmPinController.text.length == 6;
    });
  }

  void _checkPhoneNumberExistsAndPIN() async {
    bool isPhoneNumberExists =
        await CheckForm().isPhoneNumberExists(_phoneNumberController.text);
    if (mounted) {
      if (isPhoneNumberExists) {
        CustomSnackbarAlert()
            .showSnackbarError('Phone number already registered!', context);
      } else {
        if (_pinController.text == _confirmPinController.text) {
          _sendOTP();
        } else {
          CustomSnackbarAlert().showSnackbarError('PINs do not match!', context);
        }
      }
    }
  }

  void _sendOTP() async {
    await PhoneAuth().sendOTP(_phoneNumberController.text,
        (String verificationId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerification(
            verificationId: verificationId,
            fullName: _fullNameController.text,
            phoneNumber: _phoneNumberController.text,
            pin: _pinController.text,
          ),
        ),
      );
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Fill out the form below to get started.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Full Name',
                              style: TextStyle(
                                fontSize: CustomFontSize.primaryFontSize,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              height: 40.0,
                              child: TextField(
                                controller: _fullNameController,
                                onChanged: (_) => _checkFields(),
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]+')),
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Andika Setiawan',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                ),
                                style: const TextStyle(
                                  fontSize: CustomFontSize.primaryFontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0),
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
                                          controller: _phoneNumberController,
                                          onChanged: (_) => _checkFields(),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                14),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          textInputAction: TextInputAction.next,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PIN',
                              style: TextStyle(
                                fontSize: CustomFontSize.primaryFontSize,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              height: 40.0,
                              child: TextField(
                                controller: _pinController,
                                obscureText: true,
                                keyboardType: TextInputType.phone,
                                onChanged: (_) => _checkFields(),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: '******',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                ),
                                style: const TextStyle(
                                  fontSize: CustomFontSize.primaryFontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Confirm PIN',
                              style: TextStyle(
                                fontSize: CustomFontSize.primaryFontSize,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              height: 40.0,
                              child: TextField(
                                controller: _confirmPinController,
                                obscureText: true,
                                keyboardType: TextInputType.phone,
                                onChanged: (_) => _checkFields(),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  labelText: '******',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                ),
                                style: const TextStyle(
                                  fontSize: CustomFontSize.primaryFontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: _isContinueButtonEnabled
                              ? _checkPhoneNumberExistsAndPIN
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
                            'Already have an account? ',
                            style: TextStyle(
                                fontSize: CustomFontSize.primaryFontSize),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignIn(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Sign In',
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
