// ignore_for_file: prefer_const_constructors
import 'package:rolemissions/rolemissions.dart';
import 'package:rolemissions/src/persistance_delegate/strategies/postgres_strategy.dart';
import 'package:test/test.dart';

void main() {
  group('Rolemissions', () {
    test('can be instantiated', () {
      expect(
        Rolemissions(
          // TODO(anyone): Mock this
          persistanceDelegate: PostgresStrategy(
            host: '',
            databaseName: '',
            userName: '',
            dbPassword: '',
            port: 8080,
          ),
          permissions: [],
        ),
        isNotNull,
      );
    });
  });
}
