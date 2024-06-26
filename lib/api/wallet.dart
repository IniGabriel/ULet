import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ulet_1/firebase/history.dart';

class Wallet {
  final String baseURL = dotenv.env['API_BASE_URL']!;
  final String authorizationToken = dotenv.env['API_AUTH']!;
  final String appID = dotenv.env['API_APPID']!;
  final String appKey = dotenv.env['API_APPKEY']!;

  // register wallet id to API
  Future<void> postRegisterWallet(String email, String displayName) async {
    final Uri url = Uri.parse(baseURL).replace(
      path: 'PAY-API/API/RegisterWallet',
    );

    final Map<String, String> headers = {
      'Authorization': authorizationToken,
      'Content-Type': 'application/json',
      'X-AppId': appID,
      'X-AppKey': appKey,
    };

    final Map<String, String> body = {
      'Email': email,
      'DisplayName': displayName,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
    } else {
      print('Failed to make request. Status code: ${response.statusCode}');
    }
  }

  // top up balance
  Future<String> postTopUpBalance(int amount, String walletId) async {
    final Uri url = Uri.parse(baseURL).replace(
      path: 'PAY-API/API/TopUp',
    );

    final Map<String, String> headers = {
      'Authorization': authorizationToken,
      'Content-Type': 'application/json',
      'X-AppId': appID,
      'X-AppKey': appKey,
      'X-WalletId': walletId,
    };

    final Map<String, int> body = {
      'Amount': amount,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Parse JSON response to Dart object
      final Map<String, dynamic> data = json.decode(response.body);

      print('Response data: ${response.body}');

      // Extract transId and transDate from the response
      final String transId = data['TransId'];
      final String transDateString = data['TransDate'];

      final DateTime transDate = DateTime.parse(transDateString);
      await History().storeTopUpHistory(transId, transDate, amount);

      return 'success';
    } else {
      print('Failed to make request. Status code: ${response.statusCode}');
      return 'failed';
    }
  }

  // get wallet ID from API
  Future<String> getWalletID(String email) async {
    final Uri url = Uri.parse(baseURL).replace(
      path: 'PAY-API/API/FindWallet',
      queryParameters: {'email': email},
    );

    final Map<String, String> headers = {
      'Authorization': authorizationToken,
      'X-AppId': appID,
      'X-AppKey': appKey,
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Parse JSON response to Dart object
      final Map<String, dynamic> data = json.decode(response.body);

      // Extract WalletId from the response
      final String walletId = data['WalletId'];
      print('Response data: ${response.body}');
      return walletId;
    } else {
      print('Failed to make request. Status code: ${response.statusCode}');
      return 'null';
    }
  }

  // Get Wallet Balance
Future<double> getWalletBalance(String email) async {
  final Uri url = Uri.parse(baseURL).replace(
    path: 'PAY-API/API/FindWallet',
    queryParameters: {'email': email},
  );

  final Map<String, String> headers = {
    'Authorization': authorizationToken,
    'X-AppId': appID,
    'X-AppKey': appKey,
  };

  final response = await http.get(
    url,
    headers: headers,
  );

  if (response.statusCode == 200) {
    // Parse JSON response to Dart object
    final Map<String, dynamic> data = json.decode(response.body);

    final double walletBalance = (data['Balance'] as num).toDouble();
    print('Response data: ${response.body}');
    return walletBalance;
  } else {
    print('Failed to make request. Status code: ${response.statusCode}');
    return 0.0;
  }
}

  Future<String> postBill(String walletId, int amount, String transInfo) async {
    final Uri url = Uri.parse(baseURL).replace(
      path: 'PAY-API/API/CreateBill',
    );

    final Map<String, String> headers = {
      'Authorization': authorizationToken,
      'Content-Type': 'application/json',
      'X-AppId': appID,
      'X-AppKey': appKey,
      'X-WalletId': walletId,
    };

    final Map<String, String> body = {
      "MerchantTransId": "",
      "Amount": amount.toString(),
      "ExpireMinutes": "60",
      "TransInfo" : transInfo,
      "itemsInfo" : ""
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Parse the response body JSON
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Extract the TransId from the response
      String transId = responseBody['TransId'];

      // Print or use the TransId as needed
      print('==========================================================================================TransId: $transId');
      // print('Response data: ${response.body}');
      return transId;
    } else {
      print('Failed to make request. Status code: ${response.statusCode}');
      return 'failed';
    }
  }

  Future<String> payBill(String walletId, String transId) async {
    final Uri url = Uri.parse(baseURL).replace(
      path: 'PAY-API/API/Pay',
    );

    final Map<String, String> headers = {
      'Authorization': authorizationToken,
      'Content-Type': 'application/json',
      'X-AppId': appID,
      'X-AppKey': appKey,
      'X-WalletId': walletId,
    };

    final Map<String, String> body = {
      "TransId": transId,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      return 'success';
    } else {
      print('Failed to make request. Status code: ${response.statusCode}');
      return 'failed';
    }
  }
}


