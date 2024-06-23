import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ulet_1/utils/colors.dart';

import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/utils/snackbar_alert.dart';
import 'package:ulet_1/pages/home_page/bottom_navbar.dart';
import 'package:ulet_1/pages/profile_page/change_pin.dart';

class OTPVerification extends StatefulWidget {
  final String verificationId;
  final String? fullName;
  final String? email;
  final String phoneNumber;
  final String? pin;
  final String? note;

  const OTPVerification({
    super.key,
    required this.verificationId,
    this.fullName,
    this.email,
    required this.phoneNumber,
    this.pin,
    this.note,
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOTP() async {
    bool isOTPVerified = await PhoneAuth().isOTPVerified(
      verificationId: widget.verificationId,
      fullName: widget.fullName,
      email: widget.email,
      pin: widget.pin,
      otp: _otpController.text,
    );
    if (mounted) {
      if (isOTPVerified) {
        if (widget.note!="change pin"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavbar(),
          ),
        );
        } else if (widget.note=="change pin"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangePinPage(),
            ),
          );
        }
      } else {
        CustomSnackbarAlert().showSnackbarError('Incorrect OTP Code!', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.grey,
      ))),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 4,
          decoration: BoxDecoration(
            color: CustomColors.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.verified_rounded,
                  size: 100,
                  color: CustomColors.primaryColor,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'OTP Code sent to +62${widget.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  'Enter the OTP code sent to your number.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                Pinput(
                  length: 6,
                  pinAnimationType: PinAnimationType.slide,
                  controller: _otpController,
                  defaultPinTheme: defaultPinTheme,
                  showCursor: true,
                  cursor: cursor,
                  preFilledWidget: preFilledWidget,
                  closeKeyboardWhenCompleted: true,
                  onCompleted: (pin) => _verifyOTP(),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
