import 'identity.dart';

class Role implements Identity {
  @override
  final String id;
  final String name;

  const Role({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}