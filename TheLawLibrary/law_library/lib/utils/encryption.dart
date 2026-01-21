import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionUtil {
  // Generate SHA-256 hash for password
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Verify a password against a hash
  static bool verifyPassword(String password, String hash) {
    final hashedPassword = hashPassword(password);
    return hashedPassword == hash;
  }
}