import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'dummy/model_with_param_names.dart';
import 'dummy/pizza.dart';

void main() {
  group('query builder tests', () {
    late Pizza query;
    setUp(() {
      query = Pizza();
    });

    test('build a complex query', () {});
    test('build a query with appends method', () {
      query.append(['full_name', 'rating']);

      final expected = '?append=full_name,rating';

      expect(query.builder.query(), expected);
    });

    test('throws exception if appends not included', () {
      try {
        query.append([]);
      } catch (e) {
        expect(e.toString(),
            'Exception: The appends() function takes at least one argument.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('build query with includes', () {
      query.include(['toppings']);

      final expected = '?include=toppings';

      expect(query.builder.query(), expected);
    });

    test('throws exception with includes not passed', () {
      try {
        query.include(['']);
      } catch (e) {
        expect(e.toString(), 'Exception: The includes() should not be empty.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('can query with where', () {
      query.where('topping', 'cheese');

      final expected = '?filter[topping]=cheese';

      expect(query.builder.query(), expected);
    });

    test('can query with more where´s', () {
      query.where('topping', 'cheese');
      query.where('size', 'big');

      final expected = '?filter[topping]=cheese&filter[size]=big';

      expect(query.builder.query(), expected);
    });

    test('throw error  if less than two arguments passed', () {
      try {
        query.where('topping', '');
      } catch (e) {
        expect(e.toString(),
            'Exception: The where() function takes 2 not empty strings.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('can build query with whereIn', () {
      query.whereIn('topping', ['beef', 'cheese']);

      final expected = '?filter[topping]=beef,cheese';

      expect(query.builder.query(), expected);
    });

    test('throws exception with whereIn no arguments passed', () {
      try {
        query.whereIn('', ['']);
      } catch (e) {
        expect(e.toString(),
            'Exception: The whereIn() function expects not empty key and not empty list.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('build query with select', () {
      query.select({
        'pizza': ['name', 'date_added'],
        'burguer': ['cheese']
      });

      final expected = '?fields[pizza]=name,date_added&fields[burguer]=cheese';

      expect(query.builder.query(), expected);
    });

    test('build query with select', () {
      query.select({
        'pizza': ['name', 'date_added'],
        'burguer': ['cheese']
      });

      final expected = '?fields[pizza]=name,date_added&fields[burguer]=cheese';

      expect(query.builder.query(), expected);
    });

    test('can limit the query', () {
      query.where('name', 'meatlovers').limit(5);

      final expected = '?filter[name]=meatlovers&limit=5';

      expect(query.builder.query(), expected);
    });

    test('can sort the query', () {
      query.orderBy(['-name', 'flavour']);

      final expected = '?sort=-name,flavour';

      expect(query.builder.query(), expected);
    });

    test('can sort the throws exception with bad sorts', () {
      try {
        query.orderBy(['']);
      } catch (e) {
        expect(e.toString(),
            'Exception: The sort() function expects not empty values.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('can paginate the query', () {
      query.limit(5).page(2);

      final expected = '?page=2&limit=5';

      expect(query.builder.query(), expected);
    });

    test('build query with params() ', () {
      query.params({
        'foo': 'bar',
        'baz': ['a', 'b']
      });

      final expected = '?foo=bar&baz=a,b';
      expect(query.builder.query(), expected);
    });

    test('build query with all filters', () {
      query
          .where('name', 'macaroni and chesse')
          .where('username', 'my-username')
          .include(['toppings', 'another-toppings']).append(
              ['full name', 'other']).select({
        'pizza': [
          'name',
        ]
      });

      final expected =
          '?include=toppings,another-toppings&append=fullname,other&fields[pizza]=name&filter[name]=macaroni and chesse&filter[username]=my-username';

      expect(query.builder.query(), expected);
    });

    test('builds a complex query with custom params names', () {
      final post = ModelWithParamNames()
        ..include(['user'])
        ..append(['likes'])
        ..select({
          'posts': ['title', 'content'],
          'user': ['age', 'firstname']
        })
        ..where('title', 'Cool')
        ..where('status', 'ACTIVE')
        ..page(3)
        ..limit(10)
        ..orderBy(['created_at']);

      final expected =
          '?include_custom=user&append_custom=likes&fields_custom[posts]=title,content&fields_custom[user]=age,firstname&filter_custom[title]=Cool&filter_custom[status]=ACTIVE&sort_custom=created_at&page_custom=3&limit_custom=10';

      expect(post.builder.query(), expected);
    });

    test('build query', () {
      query
          .where('name', 'macaroni and chesse')
          .where('username', 'my-username')
          .include(['toppings', 'another-toppings']).append(
              ['full name', 'other']).select({
        'pizza': ['name', 'ratings']
      });

      final expected =
          '?include=toppings,another-toppings&append=fullname,other&fields[pizza]=name,ratings&filter[name]=macaroni and chesse&filter[username]=my-username';

      expect(query.builder.query(), expected);
    });
  });
}
