import 'package:rolemissions/src/models/permission.dart';

void main() {
  final permissions = [
    ReadPermission(),
    ReadPermission(),
    ReadPermission(),
    ReadPermission(),
  ];

  final binary = List.generate(permissions.length, (e) => e)
      .fold('', (pv, value) => pv + (value >> 1).toRadixString(2));

  print(binary);
  print('00101101');
}

class ReadPermission extends Permission {
  ReadPermission();
}
