import 'dart:typed_data';
import 'binary_utils.dart';
import 'enums.dart';
import 'identifiable.dart';

class ForumUser implements Identifiable {
  int _id;
  String _name;
  bool _isActive;
  Role _role;
  String? _bio;

  ForumUser({
    required int id,
    required String name,
    required bool isActive,
    required Role role,
    String? bio,
  })  : _id = id,
        _name = name,
        _isActive = isActive,
        _role = role,
        _bio = bio;

  @override
  int getId() => _id;
  int get id => _id;
  String get name => _name;
  bool get isActive => _isActive;
  Role get role => _role;
  String? get bio => _bio;

  set id(int value) => _id = value;
  set name(String value) => _name = value;
  set isActive(bool value) => _isActive = value;
  set role(Role value) => _role = value;
  set bio(String? value) => _bio = value;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'isActive': _isActive,
        'role': _role.name,
        'bio': _bio,
      };

  factory ForumUser.fromMap(Map<String, dynamic> map) => ForumUser(
        id: map['id'] as int,
        name: map['name'] as String,
        isActive: map['isActive'] as bool,
        role: Role.values.byName(map['role'] as String),
        bio: map['bio'] as String?,
      );

  Uint8List toBytes() {
    final bb = BytesBuilder();
    writeInt32(bb, _id);
    writeString(bb, _name);
    bb.add(Uint8List.fromList([_isActive ? 0x01 : 0x00]));
    bb.add(Uint8List.fromList([_role.index]));
    if (_bio == null) {
      bb.add(Uint8List.fromList([0x00]));
    } else {
      bb.add(Uint8List.fromList([0x01]));
      writeString(bb, _bio!);
    }
    return bb.toBytes();
  }

  factory ForumUser.fromBytes(Uint8List data) {
    int offset = 0;
    final id = readInt32(data, offset);
    offset += 4;
    final nameResult = readString(data, offset);
    offset += nameResult.bytesRead;
    final isActive = data[offset] == 0x01;
    offset += 1;
    final role = Role.values[data[offset]];
    offset += 1;
    final bioFlag = data[offset];
    offset += 1;
    String? bio;
    if (bioFlag == 0x01) {
      final bioResult = readString(data, offset);
      bio = bioResult.value;
    }
    return ForumUser(
      id: id,
      name: nameResult.value,
      isActive: isActive,
      role: role,
      bio: bio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForumUser &&
          _id == other._id &&
          _name == other._name &&
          _isActive == other._isActive &&
          _role == other._role &&
          _bio == other._bio;

  @override
  int get hashCode => Object.hash(_id, _name, _isActive, _role, _bio);

  @override
  String toString() =>
      'User{id=$_id, name=$_name, active=$_isActive, role=$_role, bio=$_bio}';
}
