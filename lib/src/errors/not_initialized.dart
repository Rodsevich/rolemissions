/// Error thrown when the rolemissions package was not properly initialized
class NotInitializedRolemissions extends StateError {
  NotInitializedRolemissions() : super('Rolemissions is not initialized');

  /// Use this [StateError] when the user's privileges were not initialized
  NotInitializedRolemissions.privileges()
      : super("Rolemissions's User privileges were not initialized");

  /// Use this [StateError] when the user's roles were not initialized
  NotInitializedRolemissions.roles()
      : super("Rolemissions's User roles were not initialized");
}
