import 'package:rolemissions/src/models/permission.dart';

/// {@template Role}
/// A role is a set of permissions that can be assigned to a user.
/// {@endtemplate}
class Role {
  /// {@macro Role}
  Role({
    required this.name,
    required this.permissions,
  });

  /// The permissions of the role.
  final List<Permission> permissions;

  final String name;
}
