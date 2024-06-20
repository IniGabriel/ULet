import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Wallet {
  final String baseURL = dotenv.env['API_BASE_URL']!;
  final String authorizationToken = dotenv.env['API_AUTH']!;
  final String appID = dotenv.env['API_APPID']!;
  final String appKey = dotenv.env['API_APPKEY']!;

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

      return walletId;
    } else {
      print('Failed to make request. Status code: ${response.statusCode}');
      return 'null';
    }
  }
}
