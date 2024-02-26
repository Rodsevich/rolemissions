// ignore_for_file: public_member_api_docs

/// {@template user_role_relation}
/// A user role relation is a set of permissions that can be assigned to a user.
/// {@endtemplate}
class UserRoleRelation {
  /// {@macro user_role_relation}
  UserRoleRelation({
    required this.id,
    required this.userId,
    required this.roleId,
    required this.createdAt,
  });

  /// {@macro fromJson}
  /// This is the JSON representation of the UserRoleRelation class.
  factory UserRoleRelation.fromJson(
    Map<String, dynamic> json,
    // ignore: avoid_unused_constructor_parameters
    Object? serializationManager,
  ) {
    return UserRoleRelation(
      id: json['id'] as int,
      userId: json['userId'] as int,
      roleId: json['roleId'] as int,
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }

  final int id;
  final int userId;
  final int roleId;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'roleId': roleId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
