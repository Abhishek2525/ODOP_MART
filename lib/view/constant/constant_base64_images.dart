import 'dart:convert';
import 'dart:typed_data';

class Base64Images {
  static Uint8List getDrawerImg() {
    return Base64Decoder().convert(drawerImg);
  }

  static final String drawerImg =
}