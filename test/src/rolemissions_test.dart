// ignore_for_file: prefer_const_constructors
import 'package:rolemissions/src/interfaces/user.dart';
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
    test('serializes well', () {
      ['11111'
      '001'
      '1'.padLeft(129,'1')].join('-');; 
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

abstract class RolemissionPermissions {
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

  RolemissionPermissions.fromSerialization(RolemissionUser user) {
    user.
  }

  String toSerialization() {
    final buffer = StringBuffer();
    for (final permissionEnum in permissions) {
      final enumLength =
          allPermissions[permissions.indexOf(permissionEnum)].length;
      const maxBitsLength = 64;
      final maxBitsLengthAmount = enumLength ~/ maxBitsLength;
      for (var i = 0; i <= maxBitsLengthAmount; i++) {
        var number = 0;
        permissionEnum.skip(i * 64).take(64).forEach((element) {
          number += 1 << element.index;
        });
        if(i > 0) buffer.write(serializationEnumByteSeparator);
        buffer.write(number.toRadixString(36));
      }
      buffer.write(serializationNewEnumSeparator);
    }
    return buffer.toString();
  }
}

class Permissions extends RolemissionPermissions {
  Permissions.fromSerialization(super.user) : super.fromSerialization();

  @override
  List<List<Enum>> get allPermissions => [
        P.values,
        Q.values,
      ];
}

enum P {
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

enum Q {
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

  int get value => 1 << index;
  // int get values {
  //   Solicitud solicitud = await Solicitudes.fromMap(map);

  //   '''{
  //     'solicitudes': [
  //       {
  //         'tipo': 0,
  //         'texto': 'Hola',
  //         'conforme': true,
  //         'fechaCreacion': '2021-10-10T10:10:10.000Z',
  //       },
  //       {
  //         'tipo': 1,
  //         'lacstm': 2,
  //         'saiudhsa': 'hola puto0',
  //         'fechaCreacion': '2021-10-10T10:10:10.000Z',
  //       },
  //     ],
  //   }''';
  // }
}

class Rolemissions {}

base class Solicitud {
  Solicitud._({required this.fechaCreacion});

  final DateTime fechaCreacion;
}

// final class SolicitudDeNotificacion extends Solicitud {
//   SolicitudDeNotificacion._({required super.fechaCreacion});

//   static const int index = 0;
//   String texto;
//   bool? conforme;
// }
