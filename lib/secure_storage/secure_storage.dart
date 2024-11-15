import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = FlutterSecureStorage();

  Future<void> storeData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> retrieveData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
  }
}
