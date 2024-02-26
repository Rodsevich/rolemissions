import 'dart:async';

import 'package:rolemissions/src/models/models.dart';
import 'package:rolemissions/src/persistance_delegate/persistance_delegate.dart';

/// {@template rolemissions}
/// A set of utilities for enabling role-based permissions in your application.
/// {@endtemplate}
class Rolemissions {
  /// Factory method to get the singleton instance
  factory Rolemissions({
    required PersistanceDelegate persistanceDelegate,
  }) {
    // ignore: join_return_with_assignment
    _instance = Rolemissions._(
      persistanceDelegate: persistanceDelegate,
    );

    // Return the singleton instance
    return _instance;
  }

  /// Creates a new instance of [Rolemissions] with the provided
  /// [PersistanceDelegate].
  // Private constructor
  Rolemissions._({
    required PersistanceDelegate persistanceDelegate,
  }) : _persistanceDelegate = persistanceDelegate;

  // Singleton instance
  static late Rolemissions _instance;

  /// The singleton instance of [Rolemissions].
  static Rolemissions get instance => _instance;

  final PersistanceDelegate _persistanceDelegate;

  /// Initializes the database with the necessary tables for role/permissions persistence.
  Future<void> initialFixture({
    required String userTable,
  }) async =>
      _persistanceDelegate.initialFixture(
        userTable: userTable,
      );

  /// Initializes the database with the necessary tables for role/permissions persistence.
  Future<void> setUp() async => await _persistanceDelegate.setUp();

  /// Creates a role in the persistence delegate.
  Future<Role> createRole({
    required String name,
    required String permissions,
  }) async =>
      _persistanceDelegate.insertRole(
        name: name,
        permissions: permissions,
      );

  /// Gets all roles from the persistence delegate.
  FutureOr<List<Role>> getRoles() async => _persistanceDelegate.getRoles();

  /// Deletes a role from the persistence delegate.
  FutureOr<int> deleteRole(int id) async => _persistanceDelegate.deleteRole(id);

  /// Updates a role in the persistence delegate.
  FutureOr<Role> updateRole(Role role) async =>
      _persistanceDelegate.updateRole(role);

  /// Gets a role by its ID from the persistence delegate.
  FutureOr<Role> getRoleById(int id) async =>
      _persistanceDelegate.getRoleById(id);

  /// Relates a role to a user.
  FutureOr<int> asignRoleToUser({
    required int userId,
    required int roleId,
    required int organizationId,
  }) async =>
      _persistanceDelegate.relateRoleToUser(
        userId: userId,
        roleId: roleId,
        organizationId: organizationId,
      );

  /// Updates the privileges of a user in an organization.
  FutureOr<bool> updateUserPrivileges({
    required int userId,
    required int organizationId,
    required String privileges,
  }) async =>
      _persistanceDelegate.updateUserPrivileges(
        userId: userId,
        organizationId: organizationId,
        privileges: privileges,
      );
}

/// {@template rolemission_permissions}
/// A set of utilities for enabling role-based permissions in your application.
/// {@endtemplate}
abstract class RolemissionPermissions {
  /// {@macro rolemission_permissions}
  RolemissionPermissions.fromSerialization(String serialization) {
    _permissions = deserialization(serialization);
  }

  /// {@macro rolemission_permissions}
  RolemissionPermissions.fromEnumList(List<List<Enum>> permissions) {
    _permissions = permissions;
  }

  /// {@macro rolemission_permissions}
  RolemissionPermissions.fromUser();

  /// The permissions your app is made with. Every enum should be included here
  /// as a list like follows: (e.g.)
  /// ```dart
  /// List<List<Enum>> get allPermissions => [
  ///   PageHomePermissions.values,
  ///   PageSettingsPermissions.values,
  /// ];
  /// ```
  List<List<Enum>> get allPermissions;

  /// The separator used to separate the permissions [String] when serializing
  /// one enum from the other.
  static String serializationNewEnumSeparator = '-';

  /// The separator used to separate the permissions [String] when serializing
  /// one enum from the other.
  static String serializationEnumByteSeparator = '.';

  List<List<Enum>> _permissions = [];

  /// The permissions the user has
  List<List<Enum>> get permissions => _permissions;

  /// The max amount of bits an enum can have due to integer limitations of 64
  /// it's fixed at 62 bits because at 63/64 the serialized string length would
  /// be 1 character longer with no benefict
  static const maxBitsLength = 62;

  /// Deserializes the permissions from a [String] that was stored in a
  /// database.
  ///
  /// The [String] should be the result of the [toSerialization] method.
  List<List<Enum>> deserialization(String serialization) {
    final permissions = <List<Enum>>[];
    final serializedPermissions =
        serialization.split(serializationNewEnumSeparator);
    assert(
      serializedPermissions.length == allPermissions.length,
      'The amount of serialized permissions is not the same as the amount of permissions in the app',
    );
    for (var e = 0; e < serializedPermissions.length; e++) {
      final serializedPermission = serializedPermissions[e];
      final enumPermission = <Enum>[];
      final serializedPermissionBytes =
          serializedPermission.split(serializationEnumByteSeparator);
      for (var i = 0; i < serializedPermissionBytes.length; i++) {
        final number = int.parse(serializedPermissionBytes[i], radix: 36);
        final bitsAmount = number.toRadixString(2).length;
        for (var j = 0; j < bitsAmount; j++) {
          if (number & (1 << j) != 0) {
            enumPermission.add(allPermissions[e][j + i * maxBitsLength]);
          }
        }
      }
      permissions.add(enumPermission);
    }
    return permissions;
  }

  /// Serializes the permissions into a [String] that can be stored in a
  /// database.
  String toSerialization() {
    final buffer = StringBuffer();
    for (final permissionEnum in permissions) {
      final enumLength =
          allPermissions[permissions.indexOf(permissionEnum)].length;
      final maxBitsLengthAmount = enumLength ~/ maxBitsLength;
      for (var i = 0; i <= maxBitsLengthAmount; i++) {
        var number = 0;
        permissionEnum
            .skip(i * maxBitsLength)
            .take((i + 1) * maxBitsLength)
            .forEach((element) {
          number += 1 << (element.index % maxBitsLength);
        });
        if (i > 0) buffer.write(serializationEnumByteSeparator);
        buffer.write(number.toRadixString(36));
      }
      buffer.write(serializationNewEnumSeparator);
    }
    return buffer.toString().substring(0, buffer.length - 1);
  }

  /// Checks if the user has a specific permission.
  ///
  /// The [permission] should be an enum that is included in the
  /// [allPermissions] list.
  bool hasPermission(Enum permission) {
    for (final permissionEnum in allPermissions) {
      if (permissionEnum.contains(permission)) return true;
    }
    return false;
  }
}
