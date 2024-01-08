// ignore_for_file: prefer_const_constructors
import 'package:rolemissions/rolemissions.dart';
import 'package:rolemissions/src/persistance_delegate/strategies/postgres_strategy.dart';
import 'package:test/test.dart';

void main() {
  group('Rolemissions', () {
    test('works with large numbers',(){
      StringBuffer sb = StringBuffer('enum P {');
      for(var i = 0; i < 67; i++){
       sb.writeln('\tp' + i.toRadixString(36) + ',');
      }
      sb.writeln('}');
      print(sb.toString());
      final numero_63 = int.parse('1'.padRight(62,'1'), radix: 2);
      final numero_64 = int.parse('1'.padRight(62,'1'), radix: 2);
      expect(numero_64, isNot(equals(numero_63)));
    });
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
	p1u;

 int get value  => 1 << index;
}