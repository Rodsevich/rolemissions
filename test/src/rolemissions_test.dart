// ignore_for_file: prefer_const_constructors
import 'package:rolemissions/rolemissions.dart';
import 'package:test/test.dart';

void main() {
  group('Rolemissions', () {
    test('works with large numbers', () {
      final numero_13 = int.parse('01'.padRight(12, '1'), radix: 2);
      final numero_63 = int.parse('01'.padRight(62, '1'), radix: 2);
      final numero_64 = int.parse('1'.padRight(63, '1'), radix: 2);
      final str13 = numero_13.toRadixString(36);
      print(str13);
      print(str13.length);
      final str64 = numero_64.toRadixString(36);
      print(str64);
      print(str64.length);
      expect(numero_64, isNot(equals(numero_63)));
    });
    test('(de)serializes well', () {
      final allPermissions36 = int.parse(''.padLeft(36, '1'), radix: 2).toRadixString(36);
      final allPermissions74 = int.parse(
                  ''.padLeft(RolemissionPermissions.maxBitsLength, '1'), radix: 2)
              .toRadixString(36) +
          RolemissionPermissions.serializationEnumByteSeparator +
          int.parse(''.padLeft(74 - RolemissionPermissions.maxBitsLength, '1'), radix: 2)
              .toRadixString(36);
      final allPermissions =
          Permissions.fromSerialization('$allPermissions36-$allPermissions74');
      expect(allPermissions.permissions.first.length, equals(36));
      expect(allPermissions.permissions.first.first, equals(E36.p0));
      expect(allPermissions.permissions.first.last, equals(E36.pz));
      expect(allPermissions.permissions[1].length, equals(74));
      expect(allPermissions.permissions[1].first, equals(E74.p0));
      expect(allPermissions.permissions[1].last, equals(E74.p21));

      final serialized = allPermissions.toSerialization();
      expect(serialized, equals('$allPermissions36-$allPermissions74'));
    });
    // test('can be instantiated', () {
    //   expect(
    //     Rolemissions(
    //       // TODO(anyone): Mock this
    //       persistanceDelegate: PostgresStrategy(
    //         host: '',
    //         databaseName: '',
    //         userName: '',
    //         dbPassword: '',
    //         port: 8080,
    //       ),
    //       permissions: [],
    //     ),
    //     isNotNull,
    //   );
    // });
  });
}

class Permissions extends RolemissionPermissions {
  Permissions.fromSerialization(super.user) : super.fromSerialization();

  @override
  List<List<Enum>> get allPermissions => [
        E36.values,
        E74.values,
      ];
}

enum E36 {
  p0,
  p1,
  p2,
  p3,
  p4,
  p5,
  p6,
  p7,
  p8,
  p9,
  pa,
  pb,
  pc,
  pd,
  pe,
  pf,
  pg,
  ph,
  pi,
  pj,
  pk,
  pl,
  pm,
  pn,
  po,
  pp,
  pq,
  pr,
  ps,
  pt,
  pu,
  pv,
  pw,
  px,
  py,
  pz;
}

enum E74 {
  p0,
  p1,
  p2,
  p3,
  p4,
  p5,
  p6,
  p7,
  p8,
  p9,
  pa,
  pb,
  pc,
  pd,
  pe,
  pf,
  pg,
  ph,
  pi,
  pj,
  pk,
  pl,
  pm,
  pn,
  po,
  pp,
  pq,
  pr,
  ps,
  pt,
  pu,
  pv,
  pw,
  px,
  py,
  pz,
  p10,
  p11,
  p12,
  p13,
  p14,
  p15,
  p16,
  p17,
  p18,
  p19,
  p1a,
  p1b,
  p1c,
  p1d,
  p1e,
  p1f,
  p1g,
  p1h,
  p1i,
  p1j,
  p1k,
  p1l,
  p1m,
  p1n,
  p1o,
  p1p,
  p1q,
  p1r,
  p1s,
  p1t,
  p1u,
  p1v,
  p1w,
  p1x,
  p1y,
  p1z,
  p20,
  p21;
}
