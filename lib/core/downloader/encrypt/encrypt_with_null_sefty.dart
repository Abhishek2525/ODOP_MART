import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppEncrypt {
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

  static String _generateKey() {
    return SecureRandom(32).base64.toString();
  }

  static String _encryptKey;

  static Future<String> encryptFile(String filePath) async {
    try {
      await loadKey();
      if (filePath == null || filePath == "") return null;
      File inFile = new File(filePath ?? "");

      String outPutPath = (filePath ?? "") + ".asc";

      File outFile = new File(outPutPath ?? "");

      bool outFileExists = await outFile.exists();

      if (!outFileExists) {
        await outFile.create();
      }

      final String videoFileContents =
          inFile.readAsStringSync(encoding: latin1);

      // final key = Key.fromUtf8('my 32 length key................');
      final key = Key.fromBase64(_encryptKey);
      final iv = IV.fromLength(16);

      final Encrypter encrypter = Encrypter(AES(key));

      final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
      await outFile.writeAsBytes(encrypted.bytes);

      return outPutPath;
    } catch (e, t) {
      print(e);
      print(t);
      return null;
    }
  }

  static Future<String> decryptFile(String filePath) async {
    File inFile = new File(filePath);
    String outPutPath = filePath.replaceAll(".asc", '.mp4');
    File outFile = new File(outPutPath);

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    }

    final videoFileContents = inFile.readAsBytesSync();

    // final key = Key.fromUtf8('my 32 length key................');
    final key = Key.fromBase64(_encryptKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encryptedFile = Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

    final Uint8List decryptedBytes = latin1.encode(decrypted);
    await outFile.writeAsBytes(decryptedBytes);
    return outPutPath;

    //return File.fromRawPath(decryptedBytes);
  }
}
