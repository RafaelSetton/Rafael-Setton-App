import 'dart:math';

// TODO: Real Cryptography
class Cryptography {
  static const String asciiChars =
      r"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%&()";

  static String encrypt(String from) {
    String _new = '';
    int displace = Random().nextInt(70);
    for (int i = 0; i < from.length; i++) {
      _new += asciiChars[
          (asciiChars.indexOf(from[i]) + displace) % asciiChars.length];
    }
    return displace.toStringAsPrecision(2) + _new;
  }

  static String decrypt(String from) {
    String _new = '';
    int displace = int.parse(from.substring(0, 2));
    for (int i = 2; i < from.length; i++) {
      _new += asciiChars[
          (asciiChars.indexOf(from[i]) - displace) % asciiChars.length];
    }
    return _new;
  }
}
