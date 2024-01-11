/// The main class of a permission. Your base category of permission should extend this class.
/// e.g.:
/// ```dart
///
///  base class PageHomePermissions extends Permission{
///   const P(Enum enumValue) : super(enumValue);
///  }
/// ```
@Deprecated('Use a simple enum value instead')
abstract class Permission {
  final Enum enumValue;

  Permission(this.enumValue);

  /// The bitmask of the permission. Used for persistance and checking.
  int get bitMask => 1 << enumValue.index;
}
