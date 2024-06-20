import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ulet_1/api/wallet.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
import 'package:ulet_1/utils/colors.dart';
import 'package:ulet_1/utils/font_size.dart';
import 'package:ulet_1/utils/snackbar_alert.dart';

class TopUp extends StatefulWidget {
  const TopUp({super.key});

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  final TextEditingController _amountController = TextEditingController();
  bool _isContinueButtonEnabled = false;

  // set the amount from shortcut
  void _setTopUpAmount(String amount) {
    setState(() {
      _amountController.text = amount;
      _checkFields();
    });
  }

  // check the amount of top up (>=10000)
  void _checkFields() {
    setState(() {
      _isContinueButtonEnabled = _amountController.text.isNotEmpty &&
          int.parse(_amountController.text) >= 10000;
    });
  }

  // verify amount of top up
  void _verifyAmount() async {
    FocusScope.of(context).unfocus();
    String walletId = await PhoneAuth().getWalletIDCurrentUser();
    print(walletId);
    if (walletId == 'Not found') {
      if (mounted) {
        CustomSnackbarAlert()
            .showSnackbarError('Something went wrong', context);
        return;
      }
    }
    String result = await Wallet()
        .postTopUpBalance(int.parse(_amountController.text), walletId);
    if (mounted) {
      if (result == 'success') {
        _amountController.clear();
        _isContinueButtonEnabled = false;
        CustomSnackbarAlert().showSnackbarSuccess('Top up successful', context);
      } else {
        _amountController.clear();
        _isContinueButtonEnabled = false;
        CustomSnackbarAlert()
            .showSnackbarError('Something went wrong', context);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Widget _buildShortcutButton(String displayText, String actualAmount) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () => _setTopUpAmount(actualAmount),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.primaryColor,
          foregroundColor: CustomColors.secondaryColor,
        ),
        child: Text(displayText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: CustomColors.primaryColor,
          leading: IconButton(
            icon: SvgPicture.string(
              '''<svg width="30" height="30" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M18.8637 5.74209L9.30587 13.9323C9.15189 14.0643 9.02829 14.2281 8.94355 14.4124C8.85882 14.5967 8.81494 14.7971 8.81494 14.9999C8.81494 15.2027 8.85882 15.4032 8.94355 15.5874C9.02829 15.7717 9.15189 15.9355 9.30587 16.0675L18.8637 24.2577C19.776 25.0394 21.1852 24.3913 21.1852 23.1901V6.80733C21.1852 5.60615 19.776 4.95811 18.8637 5.74209Z" fill="white"/>
</svg>''',
              width: 30,
              height: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Top Up',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true, // Menetapkan judul ke tengah Appbar
          titleSpacing:
              0, // Jarak antara judul dengan tombol dan leading widget
        ),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount (Minimum Rp 10.000)',
                      style: TextStyle(
                        fontSize: CustomFontSize.primaryFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      controller: _amountController,
                      onChanged: (_) => _checkFields(),
                      decoration: const InputDecoration(
                        labelText: 'Enter Amount',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        CustomAmountFormatter(),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShortcutButton('20k', '20000'),
                      _buildShortcutButton('50k', '50000'),
                      _buildShortcutButton('100k', '100000'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShortcutButton('200k', '200000'),
                      _buildShortcutButton('300k', '300000'),
                      _buildShortcutButton('500k', '500000'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: _isContinueButtonEnabled ? _verifyAmount : null,
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
            ]),
          ),
        ));
  }
}

class CustomAmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith('0') && newValue.text.isNotEmpty) {
      return oldValue;
    }
    return newValue;
  }
}
