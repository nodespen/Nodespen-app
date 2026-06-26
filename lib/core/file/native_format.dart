import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import '../document/document.dart';

class NativeFormat {
  static const String magicBytes = 'NSPN';
  static const int currentVersion = 1;

  static Uint8List encode(NodespenDocument document) {
    final jsonStr = jsonEncode(document.toJson());
    final jsonBytes = utf8.encode(jsonStr);
    final compressed = GZipEncoder().encode(jsonBytes) ?? Uint8List.fromList(jsonBytes);

    final header = BytesBuilder();
    header.add(utf8.encode(magicBytes));
    header.addByte(currentVersion);
    header.add(_int32Bytes(compressed.length));
    header.add(compressed);

    return header.toBytes();
  }

  static NodespenDocument decode(Uint8List bytes) {
    final magic = utf8.decode(bytes.sublist(0, 4));
    if (magic != magicBytes) throw FormatException('Formato .nspn inválido');

    final version = bytes[4];
    final dataLength = _bytesToInt32(bytes.sublist(5, 9));
    final compressed = bytes.sublist(9, 9 + dataLength);

    final decompressed = GZipDecoder().decodeBytes(compressed);
    final jsonStr = utf8.decode(decompressed);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;

    return NodespenDocument.fromJson(json);
  }

  static Uint8List _int32Bytes(int value) {
    return Uint8List.fromList([
      value & 0xFF,
      (value >> 8) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 24) & 0xFF,
    ]);
  }

  static int _bytesToInt32(Uint8List bytes) {
    return bytes[0] | (bytes[1] << 8) | (bytes[2] << 16) | (bytes[3] << 24);
  }
}
