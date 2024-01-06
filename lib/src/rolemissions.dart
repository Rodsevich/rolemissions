import 'package:rolemissions/src/models/permission.dart';
import 'package:rolemissions/src/persistance_delegate/persistance_delegate.dart';

/// {@template rolemissions}
/// A Very Good Project created by Very Good CLI.
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
