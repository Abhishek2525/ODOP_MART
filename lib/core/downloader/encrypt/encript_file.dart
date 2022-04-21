import 'dart:io';
import 'dart:typed_data';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptData {
  static final _storage = new FlutterSecureStorage();

  static loadKey() async {
    if (_encryptKey == null) {
      _encryptKey = await _storage.read(key: "_encryptKey");
      if (_encryptKey == null || _encryptKey == "") {
        _encryptKey = _generateKey();
        await _storage.write(key: "_encryptKey", value: _encryptKey);
      }
    }
  }

  static String _encryptKey;

  static String _generateKey() {
    return SecureRandom(32).base64.toString();
  }

  static Future<String> encryptFile(String path) async {
    AesCrypt crypt = AesCrypt();

    await loadKey();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    // crypt.setPassword('my cool password');
    crypt.setPassword(_encryptKey);
    String encFilepath;

    try {
      encFilepath = crypt.encryptFileSync(path);
      await Future.delayed(Duration(milliseconds: 10));
      print('The encryption has been completed successfully.');
      print('Encrypted file: $encFilepath');
    } catch (e, t) {
      print(e);
      print(t);
      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The encryption has been completed unsuccessfully.');
        print(e.message);
        print(t);
        return 'ERROR';
      } else {
        return 'ERROR';
      }
    }
    return encFilepath;
  }

  static String decryptFile(String path) {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    // crypt.setPassword('my cool password');
    crypt.setPassword(_encryptKey);
    String decFilepath;
    try {
      decFilepath = crypt.decryptFileSync(path);
      print('The decryption has been completed successfully.');
      print('Decrypted file 1: $decFilepath');
      print('File content: ' + File(decFilepath).path);
    } catch (e) {
      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The decryption has been completed unsuccessfully.');
        print(e.message);
      } else {
        return 'ERROR';
      }
    }
    return decFilepath;
  }

  static Future<Uint8List> decryptDataFromFile(String path) async {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    // crypt.setPassword('my cool password');
    crypt.setPassword(_encryptKey);
    Uint8List decFileData;

    try {
      DateTime now = DateTime.now();
      print("decrypt time $now");
      decFileData = await crypt.decryptDataFromFile(path);
      print("decrypt time ${DateTime.now()}");
      print("decrypt time ${DateTime.now().difference(now).inMilliseconds}");
    } catch (e, t) {
      print(e);
      print(t);
    }

    return decFileData;
  }
}
