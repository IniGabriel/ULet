import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class Security {
  String hashPin(String pin) {
    List<String> salts = List.generate(3, (_) => _generateSalt());
    String combined = pin;

    for (int i = 0; i < 3; i++) {
      combined = _hashWithSalt(combined, salts[i]);
    }

    String hashedPinWithSalts = combined + ':' + salts.join(':');
    return hashedPinWithSalts;
  }

  String _generateSalt() {
    final Random random = Random.secure();
    final List<int> saltBytes = List.generate(16, (_) => random.nextInt(256));
    return saltBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join('');
  }

  String _hashWithSalt(String data, String salt) {
    final bytes = utf8.encode(data + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool comparePins(String originalPin, String hashedPinWithSalts) {
    List<String> parts = hashedPinWithSalts.split(':');
    if (parts.length != 4) {
      return false;
    }

    String hashedPin = parts[0];
    List<String> salts = parts.sublist(1);

    String rehashedPin = originalPin;
    for (int i = 0; i < 3; i++) {
      rehashedPin = _hashWithSalt(rehashedPin, salts[i]);
    }

    return rehashedPin == hashedPin;
  }
}
