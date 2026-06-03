import 'dart:convert';
import 'dart:typed_data';

void writeInt32(BytesBuilder bb, int value) {
  final bd = ByteData(4);
  bd.setInt32(0, value, Endian.big);
  bb.add(bd.buffer.asUint8List());
}

int readInt32(Uint8List data, int offset) {
  final bd = ByteData.view(data.buffer, data.offsetInBytes + offset, 4);
  return bd.getInt32(0, Endian.big);
}

void writeString(BytesBuilder bb, String s) {
  final bytes = utf8.encode(s);
  writeInt32(bb, bytes.length);
  bb.add(Uint8List.fromList(bytes));
}

({String value, int bytesRead}) readString(Uint8List data, int offset) {
  final length = readInt32(data, offset);
  final start = offset + 4;
  return (
    value: utf8.decode(data.sublist(start, start + length)),
    bytesRead: 4 + length,
  );
}
