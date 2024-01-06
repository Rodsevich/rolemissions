// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:rolemissions/src/models/role.dart';
import 'package:rolemissions/src/persistance_delegate/persistance_delegate.dart';

/// {@template PostgresStrategy}
/// Concrete implementation of [PersistanceDelegate] using a PostgreSQL database.
/// {@endtemplate}
class PostgresStrategy extends PersistanceDelegate {
  /// {@macro PostgresStrategy}
  PostgresStrategy({
    /// The hostname or IP address of the PostgreSQL server.
    required String host,

    /// The name of the database to connect to.
    required String databaseName,

    /// The username for authentication.
    required String userName,

    /// The password for authentication.
    required String dbPassword,

    /// The port number on which the PostgreSQL server is listening.
    required int port,

    /// The SSL mode to use for the connection
    SslMode? sslMode,
  })  : _host = host,
        _databaseName = databaseName,
        _userName = userName,
        _dbPassword = dbPassword,
        _port = port,
        _sslMode = sslMode,
        super();

  @override
  Logger get logger => Logger('PostgresStrategy');

  final String _host;

  final String _databaseName;

  final String _userName;

  final String _dbPassword;

  final int _port;

  final SslMode? _sslMode;

  /// The connection to the database
  late final Connection connection;

  /// Initializes the database with the necessary tables for email persistence.
  ///
  /// [schema]: The name of the schema where the tables should be created.
  Future<void> initialFixture(String schema) async {
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $schema.role (
      id SERIAL PRIMARY KEY,
      name VARCHAR(255),
      permissions BYTEA,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    );
  ''');

    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $schema.permission (
      id SERIAL PRIMARY KEY,
      value BYTEA
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    );
  ''');

    return;
  }

  @override
  Future<void> setUp() async {
    connection = await Connection.open(
      Endpoint(
        host: _host,
        database: _databaseName,
        username: _userName,
        password: _dbPassword,
        port: _port,
      ),
      settings: _sslMode != null
          ? ConnectionSettings(
              sslMode: _sslMode,
            )
          : null,
    );
  }

  @override
  Future<Role> insertRole({
    required String name,
    required int permissions,
  }) async {
    try {
      final query = await connection.execute(
        Sql.named(
          'INSERT INTO role (name, permissions) VALUES (@name, @permissions) RETURNING *',
        ),
        parameters: {
          'name': name,
          'permissions': permissions,
        },
      );

      final createdRole = query.map(
        (row) {
          return Role(
            name: row[0] as String? ?? '',
            permissions: [],
          );
        },
      ).first;

      return createdRole;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Role>> getRoles() async {
    final query = await connection.execute(
      Sql.named('SELECT * FROM role'),
    );

    return query
        .map(
          (row) => Role(
            name: row[0] as String? ?? '',
            permissions: [],
          ),
        )
        .toList();
  }

  @override
  Future<bool> deleteRole({required String id}) async {
    try {
      await connection.execute(
        Sql.named('DELETE FROM role WHERE id = @roleId'),
        parameters: {
          'roleId': id,
        },
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Role> updateRole(Role role) async {
    try {
      final query = await connection.execute(
        Sql.named(
          'UPDATE role SET name = @name, permissions = @permissions, updatedAt = CURRENT_TIMESTAMP WHERE id = @roleId RETURNING *',
        ),
        parameters: {
          'name': role.name,
          // TODO(andre): convert to binary.
          'permissions':
              List.generate(role.permissions.length, (e) => e.toRadixString(2))
                  .join(),
        },
      );

      final updatedRole = query.map(
        (row) {
          return Role(
            name: row[0] as String? ?? '',
            // TODO(andre): convert to list of permissions.
            permissions: [],
          );
        },
      ).first;

      return updatedRole;
    } catch (e) {
      rethrow;
    }
  }
}
