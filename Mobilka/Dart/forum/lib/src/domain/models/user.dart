import 'identity.dart';

class User implements Identity {
  @override
  final String id;
  final String login;
  final String email;
  final String roleId;

  const User({
    required this.id,
    required this.login,
    required this.email,
    required this.roleId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'login': login,
    'email': email,
    'roleId': roleId,
  };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      login: map['login'] as String,
      email: map['email'] as String,
      roleId: map['roleId'] as String,
    );
  }
}