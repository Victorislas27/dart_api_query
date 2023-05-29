import 'package:dart_api_query_package/utils/stringify/stringify.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('object with one field', () {
    final obj = {
      'pizza': ['hawaiana', 'pepperoni']
    };
    expect(stringify(obj, arrayFormat: PrefixGenerators.comma, encode: false),
        'pizza=hawaiana,pepperoni');
  });
  test('object with more fields', () {
    final obj = {
      'pizza': ['hawaiana', 'pepperoni'],
      'refresco': ['Coca cola', 'Pepsi']
    };
    expect(stringify(obj, arrayFormat: PrefixGenerators.comma, encode: false),
        'pizza=hawaiana,pepperoni&refresco=Coca cola,Pepsi');
  });
  test('ignore fields with empty searches', () {
    final obj = <String, List<String>>{
      'pizza': ['hawaiana', 'pepperoni'],
      'refresco': ['Coca cola', 'Pepsi'],
      'ignored': []
    };
    expect(stringify(obj, arrayFormat: PrefixGenerators.comma, encode: false),
        'pizza=hawaiana,pepperoni&refresco=Coca cola,Pepsi');
  });
  test('with key access', () {
    final obj = {
      'fields': {
        'pizza': ['hawaiana', 'pepperoni'],
        'refresco': ['Coca cola', 'Pepsi']
      }
    };
    expect(stringify(obj, arrayFormat: PrefixGenerators.comma, encode: false),
        'fields[pizza]=hawaiana,pepperoni&fields[refresco]=Coca cola,Pepsi');
  });
  test('with key access and empty searches', () {
    final obj = <String, Map<String, List<String>>>{
      'fields': {
        'pizza': ['hawaiana', 'pepperoni'],
        'refresco': ['Coca cola', 'Pepsi'],
        'ignored': []
      }
    };
    expect(stringify(obj, arrayFormat: PrefixGenerators.comma, encode: false),
        'fields[pizza]=hawaiana,pepperoni&fields[refresco]=Coca cola,Pepsi');
  });
  test('with key access and empty searches and mixed case', () {
    final obj = <String, dynamic>{
      'fields': <String, List<String>>{
        'pizza': ['hawaiana', 'pepperoni'],
        'refresco': ['Coca cola', 'Pepsi'],
        'ignored': []
      },
      'another': ['algo']
    };
    expect(
        stringify(obj, arrayFormat: PrefixGenerators.comma, encode: false),
        [
          'fields[pizza]=hawaiana,pepperoni',
          '&fields[refresco]=Coca cola,Pepsi&another=algo'
        ].join());
  });

  test('with multiple array keys', () {
    final obj = <String, dynamic>{
      'a': 'b',
      'c': ['d', 'e=f'],
      'f': [
        ['g'],
        ['h']
      ]
    };
    expect(stringify(obj, arrayFormat: PrefixGenerators.comma, encode: false),
        'a=b&c=d,e=f&f=g&f=h');
  });

  test('with nested object', () {
    final obj = <String, dynamic>{
      'a': {
        'b': {
          'c': 'd',
          'e': 'f',
        },
      },
    };
    expect(stringify(obj, encode: false), 'a[b][c]=d&a[b][e]=f');
  });

  test('with nesting objects up to 5 children deep', () {
    final obj = <String, dynamic>{
      'a': {
        'b': {
          'c': {
            'd': {
              'e': {
                'f': {
                  '[g][h][i]': 'j',
                },
              },
            },
          },
        },
      },
    };
    expect(stringify(obj, encode: false), 'a[b][c][d][e][f][[g][h][i]]=j');
  });
  test('with empty string', () {
    final obj = <String, dynamic>{'a': ''};
    expect(stringify(obj), 'a=');
  });

  test('with empty values and null', () {
    final obj = <String, dynamic>{
      'a': null,
      'b': '',
      'c': <List<dynamic>>[],
      'd': <String, dynamic>{}
    };
    expect(stringify(obj, encode: false), 'a=&b=');
  });

  test('stringifies a querystring object', () {
    expect(stringify({'a': 'b'}, encode: false), 'a=b');
    expect(stringify({'a': 1}, encode: false), 'a=1');
    expect(stringify({'a': 1, 'b': 2}, encode: false), 'a=1&b=2');
    expect(stringify({'a': 'A_Z'}, encode: false), 'a=A_Z');
    expect(stringify({'a': '€'}), 'a=%E2%82%AC');
    expect(stringify({'a': ''}), 'a=%EE%80%80');
    expect(stringify({'a': 'א'}), 'a=%D7%90');
    expect(stringify({'a': '𐐷'}), 'a=%F0%90%90%B7');
  });

  test('stringifies false values', () {
    expect(stringify(null), '');
    expect(stringify(false), '');
    expect(stringify(0), '');
  });

  test('stringifies nested false values', () {
    expect(
        stringify({
          'a': {
            'b': {'c': null}
          }
        }),
        'a%5Bb%5D%5Bc%5D=');
    expect(
        stringify({
          'a': {
            'b': {'c': false}
          }
        }),
        'a%5Bb%5D%5Bc%5D=false');
  });

  test('stringifies a nested object', () {
    expect(
        stringify({
          'a': {'b': 'c'}
        }),
        'a%5Bb%5D=c');
    expect(
        stringify({
          'a': {
            'b': {
              'c': {'d': 'e'}
            }
          }
        }),
        'a%5Bb%5D%5Bc%5D%5Bd%5D=e');
  });

  test('stringifies an array value', () {
    expect(
        stringify({
          'a': ['b', 'c', 'd']
        }, arrayFormat: PrefixGenerators.indices),
        'a%5B0%5D=b&a%5B1%5D=c&a%5B2%5D=d');
    expect(
        stringify({
          'a': ['b', 'c', 'd']
        }, arrayFormat: PrefixGenerators.brackets),
        'a%5B%5D=b&a%5B%5D=c&a%5B%5D=d');
    expect(
        stringify({
          'a': ['b', 'c', 'd']
        }, arrayFormat: PrefixGenerators.comma),
        'a=b%2Cc%2Cd');
    expect(
        stringify({
          'a': ['b', 'c', 'd']
        }),
        'a%5B0%5D=b&a%5B1%5D=c&a%5B2%5D=d');
  });

  test('stringifies comma and empty array values', () {
    expect(
        stringify({
          'a': [',', '', 'c,d%']
        }, encode: false, arrayFormat: PrefixGenerators.indices),
        'a[0]=,&a[1]=&a[2]=c,d%');
    expect(
        stringify({
          'a': [',', '', 'c,d%']
        }, encode: false, arrayFormat: PrefixGenerators.brackets),
        'a[]=,&a[]=&a[]=c,d%');
    expect(
        stringify({
          'a': [',', '', 'c,d%']
        }, encode: false, arrayFormat: PrefixGenerators.comma),
        'a=,,,c,d%');
    expect(
        stringify({
          'a': [',', '', 'c,d%']
        }, encode: false, arrayFormat: PrefixGenerators.repeat),
        'a=,&a=&a=c,d%');
  });

  test('stringifies comma and empty non-array values', () {
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: false, arrayFormat: PrefixGenerators.indices),
        'a=,&b=&c=c,d%');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: false, arrayFormat: PrefixGenerators.brackets),
        'a=,&b=&c=c,d%');
    expect(stringify({'a': ',', 'b': '', 'c': 'c,d%'}, encode: false),
        'a=,&b=&c=c,d%');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: false, arrayFormat: PrefixGenerators.repeat),
        'a=,&b=&c=c,d%');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: true,
            encodeValuesOnly: true,
            arrayFormat: PrefixGenerators.indices),
        'a=%2C&b=&c=c%2Cd%25');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: true,
            encodeValuesOnly: true,
            arrayFormat: PrefixGenerators.brackets),
        'a=%2C&b=&c=c%2Cd%25');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: true,
            encodeValuesOnly: true,
            arrayFormat: PrefixGenerators.comma),
        'a=%2C&b=&c=c%2Cd%25');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: true,
            encodeValuesOnly: true,
            arrayFormat: PrefixGenerators.repeat),
        'a=%2C&b=&c=c%2Cd%25');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: true,
            encodeValuesOnly: false,
            arrayFormat: PrefixGenerators.indices),
        'a=%2C&b=&c=c%2Cd%25');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: true,
            encodeValuesOnly: false,
            arrayFormat: PrefixGenerators.brackets),
        'a=%2C&b=&c=c%2Cd%25');
    expect(stringify({'a': ',', 'b': '', 'c': 'c,d%'}, encode: true),
        'a=%2C&b=&c=c%2Cd%25');
    expect(
        stringify({'a': ',', 'b': '', 'c': 'c,d%'},
            encode: true,
            encodeValuesOnly: false,
            arrayFormat: PrefixGenerators.repeat),
        'a=%2C&b=&c=c%2Cd%25');
  });

  test('stringifies an empty value', () {
    expect(stringify({'a': ''}), 'a=');
    expect(stringify({'a': null}, strictNullHandling: true), 'a');
    expect(stringify({'a': '', 'b': ''}), 'a=&b=');
    expect(stringify({'a': null, 'b': ''}, strictNullHandling: true), 'a&b=');
    expect(
        stringify({
          'a': {'b': ''}
        }),
        'a%5Bb%5D=');
    expect(
        stringify({
          'a': {'b': null}
        }, strictNullHandling: true),
        'a%5Bb%5D');
    expect(
        stringify({
          'a': {'b': null}
        }),
        'a%5Bb%5D=');
  });

  test('stringifies an empty array in different arrayFormat', () {
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        }, encode: false),
        'b[0]=&c=c');
    // arrayFormat default
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        }, encode: false, arrayFormat: PrefixGenerators.indices),
        'b[0]=&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        }, encode: false, arrayFormat: PrefixGenerators.brackets),
        'b[]=&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        }, encode: false, arrayFormat: PrefixGenerators.repeat),
        'b=&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        }, encode: false, arrayFormat: PrefixGenerators.comma),
        'b=&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.comma,
            commaRoundTrip: true),
        'b[]=&c=c');
    // with strictNullHandling
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.indices,
            strictNullHandling: true),
        'b[0]&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.brackets,
            strictNullHandling: true),
        'b[]&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.repeat,
            strictNullHandling: true),
        'b&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.comma,
            strictNullHandling: true),
        'b&c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.comma,
            strictNullHandling: true,
            commaRoundTrip: true),
        'b[]&c=c');
    // with skipNulls
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.indices,
            skipNulls: true),
        'c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.brackets,
            skipNulls: true),
        'c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        },
            encode: false,
            arrayFormat: PrefixGenerators.repeat,
            skipNulls: true),
        'c=c');
    expect(
        stringify({
          'a': <dynamic>[],
          'b': [null],
          'c': 'c'
        }, encode: false, arrayFormat: PrefixGenerators.comma, skipNulls: true),
        'c=c');
  });

  test('url encodes values', () {
    expect(stringify({'a': 'b c'}), 'a=b%20c');
  });

  test('stringifies a date', () {
    final now = DateTime.now();
    final str = 'a=${Uri.encodeComponent(now.toIso8601String())}';
    expect(stringify({'a': now}), str);
  });

  test('stringifies the weird object from qs', () {
    expect(stringify({'my weird field': '~q1!2"\'w\$5&7/z8)?'}),
        'my%20weird%20field=~q1%212%22%27w%245%267%2Fz8%29%3F');
  });

  test('stringifies boolean values', () {
    expect(stringify({'a': true}), 'a=true');
    expect(
        stringify({
          'a': {'b': true}
        }),
        'a%5Bb%5D=true');
    expect(stringify({'b': false}), 'b=false');
    expect(
        stringify({
          'b': {'c': false}
        }),
        'b%5Bc%5D=false');
  });

  test('stringifies buffer values', () {
    expect(stringify({'a': StringBuffer('test')}), 'a=test');
    expect(
        stringify({
          'a': {'b': StringBuffer('test')}
        }),
        'a%5Bb%5D=test');
  });

  test('does not crash when parsing circular references', () {
    var a = <String, dynamic>{};
    a['b'] = a;
    expect(
        () => stringify({'foo[bar]': 'baz', 'foo[baz]': a}),
        throwsA(predicate(
            (e) => e is RangeError && e.message == 'Cyclic object value')));
    var circular = <String, dynamic>{'a': 'value'};
    circular['a'] = circular;
    expect(
        () => stringify(circular),
        throwsA(predicate(
            (e) => e is RangeError && e.message == 'Cyclic object value')));
    var arr = ['a'];
    expect(() => stringify({'x': arr, 'y': arr}), returnsNormally);
  });

  test('non-circular duplicated references can still work', () {
    final hourOfDay = {'function': 'hour_of_day'};
    final p1 = {
      'function': 'gte',
      'arguments': [hourOfDay, 0]
    };
    final p2 = {
      'function': 'lte',
      'arguments': [hourOfDay, 23]
    };
    expect(
        stringify({
          'filters': {
            '\$and': [p1, p2]
          }
        }, encodeValuesOnly: true),
        'filters[\$and][0][function]=gte&filters[\$and][0][arguments][0][function]=hour_of_day&filters[\$and][0][arguments][1]=0&filters[\$and][1][function]=lte&filters[\$and][1][arguments][0][function]=hour_of_day&filters[\$and][1][arguments][1]=23');
  });
  test('objects inside arrays', () {
    final obj = {
      'a': {
        'b': {'c': 'd', 'e': 'f'}
      }
    };
    final withArray = {
      'a': {
        'b': [
          {'c': 'd', 'e': 'f'}
        ]
      }
    };
    expect(stringify(obj, encode: false), 'a[b][c]=d&a[b][e]=f');
    expect(
        stringify(obj, encode: false, arrayFormat: PrefixGenerators.brackets),
        'a[b][c]=d&a[b][e]=f');
    expect(stringify(obj, encode: false, arrayFormat: PrefixGenerators.indices),
        'a[b][c]=d&a[b][e]=f');
    expect(stringify(obj, encode: false, arrayFormat: PrefixGenerators.comma),
        'a[b][c]=d&a[b][e]=f');
    expect(stringify(withArray, encode: false), 'a[b][0][c]=d&a[b][0][e]=f');
    expect(
        stringify(withArray,
            encode: false, arrayFormat: PrefixGenerators.brackets),
        'a[b][][c]=d&a[b][][e]=f');
    expect(
        stringify(withArray,
            encode: false, arrayFormat: PrefixGenerators.indices),
        'a[b][0][c]=d&a[b][0][e]=f');
    expect(
        stringify(withArray,
            encode: false, arrayFormat: PrefixGenerators.comma),
        '???',
        skip: true,
        reason: 'TODO: figure out what this should do');
  });
}
