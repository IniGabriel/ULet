import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ulet_1/utils/colors.dart';
import 'package:ulet_1/utils/font_size.dart';

class TopUp extends StatefulWidget {
  const TopUp({super.key});

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  final TextEditingController _amountController = TextEditingController();

  void _setTopUpAmount(String amount) {
    setState(() {
      _amountController.text = amount;
    });
  }

  Widget _buildShortcutButton(String displayText, String actualAmount) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () => _setTopUpAmount(actualAmount),
        child: Text(displayText),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.primaryColor,
          foregroundColor: CustomColors.secondaryColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA41724),
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
          title: Text(
            'Top Up',
            style: TextStyle(
              color: Colors.white, // Ubah warna teks menjadi putih
            ),
          ),
          centerTitle: true, // Menetapkan judul ke tengah Appbar
          titleSpacing:
              0, // Jarak antara judul dengan tombol dan leading widget
        ),
        body: SafeArea(
          child: Center(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: CustomColors.primaryColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: CustomColors.secondaryColor,
                      size: 50,
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(
                            color: CustomColors.secondaryColor,
                            fontSize: CustomFontSize.primaryFontSize,
                          ),
                        ),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            color: CustomColors.secondaryColor,
                            fontSize: CustomFontSize.primaryFontSize,
                          ),
                        ),
                        Text(
                          'Balance',
                          style: TextStyle(
                            color: CustomColors.secondaryColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 30.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: CustomFontSize.primaryFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      controller: _amountController,
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
                  SizedBox(height: 10),
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
            ]),
          ),
        ));
  }
}
