import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ulet_1/firebase/check_form.dart';
import 'package:ulet_1/pages/home_page/bottom_navbar.dart';
import 'package:ulet_1/utils/colors.dart';
import 'package:ulet_1/utils/snackbar_alert.dart';

class PINVerification extends StatefulWidget {
  final String phoneNumber;

  const PINVerification({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<PINVerification> createState() => _PINVerificationState();
}

class _PINVerificationState extends State<PINVerification> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verifyPIN() async {
    bool isPINValid = await CheckForm().isPINValid(
      widget.phoneNumber,
      _pinController.text,
    );
    if (mounted) {
      if (isPINValid) {
        // TODO: Navigate to anywhere
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const BottomNavbar(),
        //   ),
        // );
      } else {
        CustomSnackbarAlert().showSnackbarError('Incorrect PIN!', context);
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
                  Icons.pin_rounded,
                  size: 100,
                  color: CustomColors.primaryColor,
                ),
                const SizedBox(height: 25),
                const Text(
                  'PIN',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Input your PIN to continue',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                Pinput(
                  length: 6,
                  controller: _pinController,
                  pinAnimationType: PinAnimationType.slide,
                  defaultPinTheme: defaultPinTheme,
                  showCursor: true,
                  cursor: cursor,
                  preFilledWidget: preFilledWidget,
                  closeKeyboardWhenCompleted: true,
                  obscureText: true,
                  onCompleted: (pin) => _verifyPIN(),
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {},
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
