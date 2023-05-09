import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'dummy/pizza.dart';

void main() {
  group('query_builder_tests', () {
    late Pizza query;
    setUp(() {
      query = Pizza();
    });
    test('throws_exception_if_target_not_included', () {
      try {
        query.includes('toppings');
      } catch (e) {
        expect(e.toString(),
            'Please call the for() method before adding filters or calling url() / get().');
      }
    });

    test('build_ a query_with appends_method', () {
      query.appends(['full_name', 'rating']);

      final expected = 'http://127.0.0.1:8000/pizza?append=full_name,rating';

      expect(query.url(), expected);
    });

    test('throws_exception_if_appends_not_included', () {
      try {
        query.appends([]);
      } catch (e) {
        expect(e.toString(),
            'The appends() function takes at least one argument.');
      }
    });

    test('build_query_with_includes', () {
      query.includes('toppings');

      final expected = 'http://127.0.0.1:8000/pizza?includes=toppings';

      expect(query.url(), expected);
    });

    test('throws_exception_with_includes_not_passed', () {
      try {
        query.includes('');
      } catch (e) {
        expect(e.toString(),
            'The includes() function takes at least one argument.');
      }
    });

    test('can_query_with_where', () {
      query.where('topping', 'cheese');

      final expected = 'http://127.0.0.1:8000/pizza?filter[topping]=cheese';

      expect(query.url(), expected);
    });

    test('can_query_with_more_where´s', () {
      query.where('topping', 'cheese');
      query.where('size', 'big');

      final expected =
          'http://127.0.0.1:8000/pizza?filter[topping]=cheese&filter[size]=big';

      expect(query.url(), expected);
    });

    test('throw_error_ if_less_than_two_arguments_passed', () {
      try {
        query.where('topping', '');
      } catch (e) {
        expect(e.toString(),
            'Exception: The where() function takes 2 arguments both of string values.');
      }
    });

    test('can_build_query_with_whereIn', () {
      query.whereIn('topping', ['beef', 'cheese']);

      final expected =
          'http://127.0.0.1:8000/pizza?filter[topping]=beef,cheese';

      expect(query.url(), expected);
    });

    test('throws_exception_with_whereIn_no_arguments_passed', () {
      try {
        query.whereIn('', '');
      } catch (e) {
        expect(e.toString(),
            'Exception: The whereIn() function takes 2 arguments of (string, array).');
      }
    });

    test('throws_exeception_if_first_argument_invalid', () {
      try {
        query.whereIn(['oranges'], ['oranges', 'apples']);
      } catch (e) {
        expect(e.toString(),
            'The first argument for the whereIn() function must be a string or integer.');
      }
    });

    test('throws_exeception_if_second_argument_invalid', () {
      try {
        query.whereIn('oranges', {'oranges', 'apples'});
      } catch (e) {
        expect(e.toString(),
            'Exception: The second argument for the whereIn() function must be an array.');
      }
    });

    test('can_build_a_query_with_select', () {
      query.select(['name', 'date_added']);

      final expected =
          'http://127.0.0.1:8000/pizza?fields[pizza]=name,date_added';

      expect(query.url(), expected);
    });

    test('build_query_with_select', () {
      query.select(['name', 'date_added']);

      final expected =
          'http://127.0.0.1:8000/pizza?fields[pizza]=name,date_added';
      expect(query.url(), expected);
    });

    test('throws_exception_with_no_argument_passed_in_select', () {
      try {
        query.select(['']);
      } catch (e) {
        expect(e.toString(),
            'The fields() function takes a single argument of an array.');
      }
    });

    test('throws_exception_with_no_array_argument_passed_in_select', () {
      try {
        query.select('');
      } catch (e) {
        expect(
            e.toString(), 'Exception: The select() function must be an array');
      }
    });

    test('can_limit_the_query', () {
      query.where('name', 'meatlovers').limit(5);

      final expected =
          'http://127.0.0.1:8000/pizza?filter[name]=meatlovers&limit=5';

      expect(query.url(), expected);
    });

    test('can_sort_the_query', () {
      query.sort(['-name', 'flavour']);

      final expected = 'http://127.0.0.1:8000/pizza?sort=-name,flavour';

      expect(query.url(), expected);
    });

    test('query_object_can_be_reused', () {
      final actualOne = query.where('name', 'macaroni_and_cheese').get();
      final expectOne =
          'http://127.0.0.1:8000/pizza?filter[name]=macaroni_and_cheese';

      final actualTwo = query.where('name', 'meatlovers').get();
      final expectedTwo = 'http://127.0.0.1:8000/pizza?filter[name]=meatlovers';

      expect(actualOne, expectOne);
      expect(actualTwo, expectedTwo);
    });

    test('can_paginate_the query', () {
      query.limit(5).page(2);

      final expected = 'http://127.0.0.1:8000/pizza?page=2&limit=5';

      expect(query.url(), expected);
    });

    test('throws_error_target_not_included', () {
      try {
        query.includes('toppings').url();
      } catch (e) {
        expect(e.toString(),
            'Please call the for() method before adding filters or calling url() / get().');
      }
    });

    test('build_custom_query', () {
      query.custom('vegetarian');
      query.where('topping', 'carrot');

      final expected =
          'http://127.0.0.1:8000/vegetarian?filter[topping]=carrot';

      expect(query.get(), expected);
    });

    test('build_query_with_all_filters', () {
      query
          .where('name', 'macaroni_and_chesse')
          .includes('toppings')
          .appends('full_name')
          .select(['name', 'ratings']);

      final expected =
          'http://127.0.0.1:8000/pizza?includes=toppings&append=full_name&fields[pizza]=name,ratings&filter[name]=macaroni_and_chesse';

      expect(query.get(), expected);
    });
  });
}
