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
  })  : _host = host,
        _databaseName = databaseName,
        _userName = userName,
        _dbPassword = dbPassword,
        _port = port,
        super();

  @override
  Logger get logger => Logger('PostgresStrategy');

  final String _host;

  final String _databaseName;

  final String _userName;

  final String _dbPassword;

  final int _port;

  /// The connection to the database
  late final PostgreSQLConnection connection;

  /// Initializes the database with the necessary tables for email persistence.
  ///
  /// [schema]: The name of the schema where the tables should be created.
  Future<void> initialFixture(
    String schema, {
    required String userTable,
  }) async {
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $schema.roles (
      id SERIAL PRIMARY KEY,
      name TEXT,
      permissions BYTEA,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    );
  ''');

    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $schema.permissions (
      id SERIAL PRIMARY KEY,
      value TEXT
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    );
  ''');

    await connection.execute('''
      ALTER TABLE $schema.$userTable
      ADD COLUMN permissions TEXT;
  ''');

    return;
  }

  @override
  Future<void> setUp() async {
    connection = PostgreSQLConnection(
      _host,
      _port,
      _databaseName,
      username: _userName,
      password: _dbPassword,
    );

    await connection.open();
  }

  @override
  Future<Role> insertRole({
    required String name,
    required int permissions,
  }) async {
    try {
      final query = await connection.query(
        'INSERT INTO role (name, permissions) VALUES (@name, @permissions) RETURNING *',
        substitutionValues: {
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
    final query = await connection.query(
      'SELECT * FROM role',
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
      await connection.query(
        'DELETE FROM role WHERE id = @roleId',
        substitutionValues: {
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
      final query = await connection.query(
        'UPDATE role SET name = @name, permissions = @permissions, updatedAt = CURRENT_TIMESTAMP WHERE id = @roleId RETURNING *',
        substitutionValues: {
          'name': role.name,
          // TODO(andre): convert to binary.
          'permissions': ''
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
