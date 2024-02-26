// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:rolemissions/rolemissions.dart';
import 'package:rolemissions/src/models/models.dart';
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

    /// The schema where the tables should be created.
    String schema = '',

    /// The name of the table where the roles will be stored.
    String roleTable = 'roles',

    /// The name of the table where the user-role relations will be stored.
    String userRoleRelationTable = 'user_role_relation',
  })  : _host = host,
        _databaseName = databaseName,
        _userName = userName,
        _dbPassword = dbPassword,
        _port = port,
        _schema = schema,
        _roleTable = roleTable,
        _userRoleRelationTable = userRoleRelationTable,
        super();

  @override
  Logger get logger => Logger('PostgresStrategy');

  final String _host;

  final String _databaseName;

  final String _userName;

  final String _dbPassword;

  final int _port;

  final String _schema;

  String get _schemaLabel => _schema.isNotEmpty ? '$_schema.' : '';

  final String _roleTable;

  final String _userRoleRelationTable;

  /// The connection to the database
  late final PostgreSQLConnection connection;

  /// Initializes the database with the necessary tables for email persistence.
  ///
  /// [schema]: The name of the schema where the tables should be created.
  @override
  Future<void> initialFixture({
    required String userTable,
  }) async {
    connection = PostgreSQLConnection(
      _host,
      _port,
      _databaseName,
      username: _userName,
      password: _dbPassword,
    );

    await connection.open();

    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $_schemaLabel$_roleTable (
      id SERIAL PRIMARY KEY,
      name VARCHAR(255),
      permissions VARCHAR(255),
      "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
  ''');

    await connection.execute('''
      CREATE TABLE IF NOT EXISTS $_schemaLabel$_userRoleRelationTable (
      id SERIAL PRIMARY KEY,
      "organizationId" INT NOT NULL,
      "roleId" INT NOT NULL,
      "userId" INT NOT NULL,
      "privileges" VARCHAR(255),
      "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
  ''');

    // TODO(anyone): Add validation to check if the column already exists.
    await connection.execute('''
      ALTER TABLE $_schemaLabel$userTable
      ADD COLUMN privileges VARCHAR(255)
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
    required String permissions,
  }) async {
    try {
      final query = await connection.query(
        '''
        INSERT INTO ${_schemaLabel}roles (name, permissions, "createdAt", "updatedAt") 
        VALUES (@name, @permissions, @createdAt, @updatedAt) RETURNING *
        ''',
        substitutionValues: {
          'name': name,
          'permissions': permissions,
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        },
      );

      final createdRole = query.map(
        (row) {
          return Role(
            id: row[0] as int,
            name: row[1] as String? ?? '',
            permissions: row[2] as String,
            createdAt: DateTime.parse(row[3].toString()),
            updatedAt: DateTime.parse(row[4].toString()),
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
      'SELECT * FROM ${_schemaLabel}roles',
    );

    return query
        .map(
          (row) => Role(
            id: row[0] as int,
            name: row[1] as String? ?? '',
            permissions: row[2] as String,
            createdAt: DateTime.parse(row[3].toString()),
            updatedAt: DateTime.parse(row[4].toString()),
          ),
        )
        .toList();
  }

  @override
  Future<int> deleteRole(int id) async {
    try {
      final query = await connection.query(
        'DELETE FROM ${_schemaLabel}roles WHERE id = @roleId RETURNING id',
        substitutionValues: {
          'roleId': id,
        },
      );

      return query.map((row) => row[0] as int).first;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Role> updateRole(Role role) async {
    try {
      final query = await connection.query(
        'UPDATE roles SET name = @name, permissions = @permissions, "updatedAt" = CURRENT_TIMESTAMP WHERE id = @roleId RETURNING *',
        substitutionValues: {
          'roleId': role.id,
          'name': role.name,
          'permissions': role.permissions,
        },
      );

      final updatedRole = query.map(
        (row) {
          return Role(
            id: row[0] as int,
            name: row[1] as String,
            permissions: row[2] as String,
            createdAt: DateTime.parse(row[3].toString()),
            updatedAt: DateTime.parse(row[4].toString()),
          );
        },
      ).first;

      return updatedRole;
    } catch (e) {
      rethrow;
    }
  }

  @override
  FutureOr<Role> getRoleById(int id) async {
    final query = await connection.query(
      'SELECT * FROM roles WHERE id = @roleId',
      substitutionValues: {
        'roleId': id,
      },
    );

    return query.map(
      (row) {
        return Role(
          id: row[0] as int,
          name: row[1] as String,
          permissions: row[2] as String,
          createdAt: DateTime.parse(row[3].toString()),
          updatedAt: DateTime.parse(row[4].toString()),
        );
      },
    ).first;
  }

  @override
  FutureOr<int> relateRoleToUser({
    required int userId,
    required int roleId,
    required int organizationId,
    String? privileges,
  }) async {
    final query = await connection.query(
      '''
      INSERT INTO user_role_relation ("userId", "roleId", "organizationId", "privileges") 
      VALUES (@userId, @roleId, @organizationId, @privileges) RETURNING id
      ''',
      substitutionValues: {
        'userId': userId,
        'roleId': roleId,
        'organizationId': organizationId,
        'privileges': privileges,
      },
    );

    return query.map((row) => row[0] as int).first;
  }

  @override
  FutureOr<bool> updateUserPrivileges({
    required int userId,
    required int organizationId,
    required String privileges,
  }) async {
    final query = await connection.query(
      '''
      UPDATE user_role_relation 
      SET "privileges" = @privileges, "updatedAt" = CURRENT_TIMESTAMP 
      WHERE "userId" = @userId AND "organizationId" = @organizationId
      ''',
      substitutionValues: {
        'userId': userId,
        'organizationId': organizationId,
        'privileges': privileges,
      },
    );

    return query.isNotEmpty;
  }
}
