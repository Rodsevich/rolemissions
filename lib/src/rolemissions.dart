import 'package:rolemissions/src/models/permission.dart';
import 'package:rolemissions/src/persistance_delegate/persistance_delegate.dart';

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

  final List<Permission> permissions;
}
