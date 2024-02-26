import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rolemissions/rolemissions.dart';

/// This abstract class defines a delegate responsible for persisting
/// and retrieving role data. It provides a set of methods to
/// manage emails within a queue and a sent table, enabling
/// persistent storage and retrieval of email information.
///
/// Implementation:
///
/// Concrete subclasses must implement the methods defined in this
/// class to provide specific persistence functionality,
/// such as using a database, file storage, or other suitable mechanisms.
abstract class PersistanceDelegate {
  /// This is the logger for this class.
  final logger = Logger('PersistanceDelegate');

  /// Initializes the database with the necessary tables for role/permissions persistence.
  Future<void> initialFixture({
    required String userTable,
  });

  /// Performs any necessary setup tasks for the persistence delegate.
  FutureOr<void> setUp();

  /// Gets all roles from the persistence delegate.
  FutureOr<List<Role>> getRoles();

  /// Inserts a role into the persistence delegate.
  FutureOr<Role> insertRole({
    required String name,
    required String permissions,
  });

  /// Deletes a role from the persistence delegate.
  FutureOr<int> deleteRole(int id);

  /// Updates a role in the persistence delegate.
  FutureOr<Role> updateRole(Role role);

  /// Gets a role by its ID from the persistence delegate.
  FutureOr<Role> getRoleById(int id);

  /// Relates a role to a user.
  FutureOr<int> relateRoleToUser({
    required int userId,
    required int roleId,
    required int organizationId,
    String? privileges,
  });

  /// Updates the privileges of a user in an organization.
  FutureOr<bool> updateUserPrivileges({
    required int userId,
    required int organizationId,
    required String privileges,
  });
}
