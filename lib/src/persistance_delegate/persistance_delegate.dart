import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rolemissions/src/models/role.dart';

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

  /// Performs any necessary setup tasks for the persistence delegate.
  FutureOr<void> setUp();

  /// Gets all roles from the persistence delegate.
  FutureOr<List<Role>> getRoles();

  /// Inserts a role into the persistence delegate.
  FutureOr<Role> insertRole({required String name, required int permissions});

  /// Deletes a role from the persistence delegate.
  FutureOr<bool> deleteRole({required String id});

  /// Updates a role in the persistence delegate.
  FutureOr<Role> updateRole(Role role);
}
