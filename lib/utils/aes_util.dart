import 'dart:convert';

import 'package:encrypt/encrypt.dart';

///
/// AES加解密封装
///
class AESUtil {
  Key _key;
  IV _iv;
  Encrypter _encrypter;

  AESUtil(String key) {
    this._key = Key.fromUtf8(key);
    this._iv = IV.fromUtf8(key);
    this._encrypter =
        Encrypter(AES(this._key, mode: AESMode.cbc, padding: null));
  }

  /// 加密
  String encrypt(String str) {
    return str;
    if (str.length % 16 != 0) {
      str =
          str.padLeft(str.length + 16 - str.length % 16, ascii.decode([0x00]));
    }
    return this._encrypter.encrypt(str, iv: this._iv).base64;
  }

  /// 解密
  String decrypt(String base64) {
    return base64;
    return this
        ._encrypter
        .decrypt(
          Encrypted.fromBase64(base64),
          iv: this._iv,
        )
        .replaceAll(ascii.decode([0x00]), '');
  }
}
