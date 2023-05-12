import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'dummy/pizza.dart';

void main() {
  group('query builder tests', () {
    late Pizza query;
    setUp(() {
      query = Pizza();
    });

    test('build a query with appends method', () {
      query.appends(['full_name', 'rating']);

      final expected = 'http://127.0.0.1:8000/pizza?append=full_name,rating';

      expect(query.url(), expected);
    });

    test('throws exception if appends not included', () {
      try {
        query.appends([]);
      } catch (e) {
        expect(e.toString(),
            'Exception: The appends() function takes at least one argument.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('build query with includes', () {
      query.includes(['toppings']);

      final expected = 'http://127.0.0.1:8000/pizza?includes=toppings';

      expect(query.url(), expected);
    });

    test('throws exception with includes not passed', () {
      try {
        query.includes(['']);
      } catch (e) {
        expect(e.toString(), 'Exception: The includes() should not be empty.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('can query with where', () {
      query.where('topping', 'cheese');

      final expected = 'http://127.0.0.1:8000/pizza?filter[topping]=cheese';

      expect(query.url(), expected);
    });

    test('can query with more where´s', () {
      query.where('topping', 'cheese');
      query.where('size', 'big');

      final expected =
          'http://127.0.0.1:8000/pizza?filter[topping]=cheese&filter[size]=big';

      expect(query.url(), expected);
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

      final expected =
          'http://127.0.0.1:8000/pizza?filter[topping]=beef,cheese';

      expect(query.url(), expected);
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
      query.select(['name', 'date added']);

      final expected =
          'http://127.0.0.1:8000/pizza?fields[pizza]=name,date added';
      expect(query.url(), expected);
    });

    test('throws exception with no argument passed in select', () {
      try {
        query.select(['']);
      } catch (e) {
        expect(e.toString(),
            'Exception: The select() function must must not be Empty.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('can limit the query', () {
      query.where('name', 'meatlovers').limit(5);

      final expected =
          'http://127.0.0.1:8000/pizza?filter[name]=meatlovers&limit=5';

      expect(query.url(), expected);
    });

    test('can sort the query', () {
      query.sort(['-name', 'flavour']);

      final expected = 'http://127.0.0.1:8000/pizza?sort=-name,flavour';

      expect(query.url(), expected);
    });

    test('can sort the throws exception with bad sorts', () {
      try {
        query.sort(['']);
      } catch (e) {
        expect(e.toString(),
            'Exception: The sort() function expects not empty values.');
        return;
      }
      throw Exception("There was no Exception expected thrown.");
    });

    test('query object can be reused', () {
      final actualOne = query.where('name', 'macaroni and cheese').url();
      final expectOne =
          'http://127.0.0.1:8000/pizza?filter[name]=macaroni and cheese';

      final actualTwo = query.where('name', 'meatlovers').url();
      final expectedTwo = 'http://127.0.0.1:8000/pizza?filter[name]=meatlovers';

      expect(actualOne, expectOne);
      expect(actualTwo, expectedTwo);
    });

    test('can paginate the query', () {
      query.limit(5).page(2);

      final expected = 'http://127.0.0.1:8000/pizza?page=2&limit=5';

      expect(query.url(), expected);
    });

    test('build custom query', () {
      query.custom('vegetarian');
      query.where('topping', 'carrot');

      final expected =
          'http://127.0.0.1:8000/vegetarian?filter[topping]=carrot';

      expect(query.url(), expected);
    });

    test('build query with all filters', () {
      query
          .where('name', 'macaroni and chesse')
          .where('username', 'my-username')
          .includes(['toppings', 'another-toppings']).appends(
              ['full name', 'other']).select(['name', 'ratings']);

      final expected =
          'http://127.0.0.1:8000/pizza?includes=toppings,another-toppings&append=fullname,other&fields[pizza]=name,ratings&filter[name]=macaroni and chesse&filter[username]=my-username';

      expect(query.url(), expected);
    });
  });
}
