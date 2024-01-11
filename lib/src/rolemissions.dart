import 'package:rolemissions/src/persistance_delegate/persistance_delegate.dart';

import 'interfaces/user.dart';

/// {@template rolemissions}
/// A set of utilities for enabling role-based permissions in your application.
/// {@endtemplate}
class Rolemissions {
  /// {@macro rolemissions}
  const Rolemissions({
    required PersistanceDelegate persistanceDelegate,
    required this.permissions,
  }) : _persistanceDelegate = persistanceDelegate;

  ///
  final PersistanceDelegate _persistanceDelegate;

  ///
  PersistanceDelegate get persistanceDelegate => _persistanceDelegate;

  final List<List<Enum>> permissions;
}

abstract class RolemissionPermissions {
  RolemissionPermissions.fromSerialization(String serialization) {
    _permissions = deserialization(serialization);
  }

  RolemissionPermissions.fromUser(RolemissionUser user) {}

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

  List<List<Enum>> deserialization(String serialization) {
    final permissions = <List<Enum>>[];
    final serializedPermissions =
        serialization.split(serializationNewEnumSeparator);
    assert(serializedPermissions.length == allPermissions.length,
        'The amount of serialized permissions is not the same as the amount of permissions in the app');
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
            .take(maxBitsLength)
            .forEach((element) {
          number += 1 << element.index;
        });
        if (i > 0) buffer.write(serializationEnumByteSeparator);
        buffer.write(number.toRadixString(36));
      }
      buffer.write(serializationNewEnumSeparator);
    }
    return buffer.toString();
  }
}
