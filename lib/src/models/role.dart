/// {@template Role}
/// A role is a set of permissions that can be assigned to a user.
/// {@endtemplate}
class Role {
  /// {@macro Role}
  Role({
    required this.id,
    required this.name,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// {@macro fromJson}
  factory Role.fromJson(
    Map<String, dynamic> json,
  ) {
    return Role(
      id: json['id'] as int,
      name: json['name'] as String,
      permissions: json['permissions'] as String,
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: DateTime.parse(json['createdAt'].toString()),
    );
  }

  final int id;

  /// The permissions of the role.
  final String permissions;

  /// The name of the role.
  final String name;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// This is the JSON representation of the Role class.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permissions': permissions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': createdAt.toIso8601String(),
    };
  }
}
