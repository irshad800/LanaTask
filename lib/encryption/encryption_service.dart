import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  final _key = encrypt.Key.fromUtf8('32-byte-long-key-for-encryption!');
  final _iv = encrypt.IV.fromLength(16);

  String encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedData, iv: _iv);
    return decrypted;
  }
}
