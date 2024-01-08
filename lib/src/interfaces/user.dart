import '../models/permission.dart';
import '../models/role.dart';

/// An interface pretended for being implemented in the user class of your system.
interface class RolemissionUser {
  /// The roles of the user.
  List<Role> roles;

  /// The permissions of the user that gets bypassing his role.
  List<Permission> privileges;
}
