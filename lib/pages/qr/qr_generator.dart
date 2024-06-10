import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ulet_1/firebase/phone_auth.dart';
class QRGenerator extends StatefulWidget {
  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  String _phoneNumber = "";
   Future<void> _getPhoneNumber() async {
    try {
      print('hello world');
      String phoneNumber = await PhoneAuth().getCurrentUserPhoneNumber();
      setState(() {
        _phoneNumber = phoneNumber;
      });
    } catch (e) {
      print('Error getting phone number: $e');
    }
  }

  @override
  void initState(){
    super.initState();
    _getPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    const String message = 'Perlihatkan QR';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.white, onPressed: () => Navigator.pop(context),),
          title: const Text(
            'Show QR',
            style: TextStyle(
              color: Colors.white
            ),),
          centerTitle: true,
          backgroundColor: const Color(0xFFA41724),
        ),

      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    child: QrImageView(
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      // NOTE : Change data to proper userData
                      data: _phoneNumber,
                      version: QrVersions.auto,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                      embeddedImage: AssetImage('images/ULET.png'),
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size.square(40),
                        // color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                    .copyWith(bottom: 40),
                child: Text(message),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
