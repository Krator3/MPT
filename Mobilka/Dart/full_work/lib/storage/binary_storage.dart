import 'dart:io';
import 'dart:typed_data';
import '../entities/binary_utils.dart';
import '../entities/identifiable.dart';
import '../exceptions.dart';

typedef UserDeserializer<T> = T Function(Uint8List data);
typedef UserSerializer<T> = Uint8List Function(T item);

class BinaryStorage<T extends Identifiable> {
  final String filePath;
  final UserSerializer<T> serializer;
  final UserDeserializer<T> deserializer;

  BinaryStorage({
    required this.filePath,
    required this.serializer,
    required this.deserializer,
  });

  Future<void> save(List<T> items, int nextId) async {
    final file = File(filePath);
    final bb = BytesBuilder();
    writeInt32(bb, items.length);
    writeInt32(bb, nextId);
    for (final item in items) {
      final recordBytes = serializer(item);
      writeInt32(bb, recordBytes.length);
      bb.add(recordBytes);
    }
    await file.writeAsBytes(bb.toBytes());
  }

  Future<({List<T> items, int nextId})> load() async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw StorageException('Файл $filePath не найден');
    }
    final data = await file.readAsBytes();
    if (data.length < 4) return (items: <T>[], nextId: 1);
    final countBd = ByteData.view(data.buffer, data.offsetInBytes, 4);
    final count = countBd.getInt32(0, Endian.big);
    int nextId = 1;
    int offset = 4;
    if (data.length >= 8) {
      nextId = readInt32(data, offset);
      offset += 4;
    }
    final items = <T>[];
    for (int i = 0; i < count; i++) {
      if (offset + 4 > data.length) break;
      final recordSize = readInt32(data, offset);
      offset += 4;
      if (offset + recordSize > data.length) break;
      final recordData = data.sublist(offset, offset + recordSize);
      items.add(deserializer(recordData));
      offset += recordSize;
    }
    return (items: items, nextId: nextId);
  }
}
