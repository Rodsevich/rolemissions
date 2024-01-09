import 'package:rolemissions/src/rolemissions.dart';

import '../errors/not_initialized.dart';
import '../models/permission.dart';
import '../models/role.dart';

/// An interface pretended for being implemented in the user class of your system.
abstract class RolemissionUser {
  /// The [Rolemissions] instance that is used for checking and persisting permissions.
  Rolemissions get rolemissions;

  bool _isInitialized = false;

  /// A method that should be called when the user's roles and privileges are intended
  /// for being queried.
  void initRolemissions(String serializedRoles, String serializedPrivileges) {
    _roles = rolemissions.deserializeRoles(serializedRoles);
    _privileges = rolemissions.deserializePrivileges(serializedPrivileges);
    _isInitialized = true;
  }

  /// The roles of the user.
  List<Role> _roles = [];

  /// The roles of the user.
  List<Role> get roles =>
      _isInitialized ? _roles : throw NotInitializedRolemissions.roles();

  /// The permissions of the user that gets bypassing his roles.
  List<Permission> _privileges = [];

  /// The permissions of the user that gets bypassing his roles.
  List<Permission> get privileges => _isInitialized
      ? _privileges
      : throw NotInitializedRolemissions.privileges();
}
