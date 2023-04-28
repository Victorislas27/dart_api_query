import 'package:dart_api_query_package/dart_api_query_package.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('query_builder_tests', () {
    test('throws_exception_if_target_not_included', () {
      try {
        final query = Query();
        query.includes('toppings');
      } catch (e) {
        expect(e.toString(),
            'Please call the for() method before adding filters or calling url() / get().');
      }
    });
    test('build_ a query_with appends_method', () {
      final query = Query();

      query.target('pizza').appends(['full_name', 'rating']);

      final expected = '/pizza?append=full_name,rating';

      expect(query.url(), expected);
    });

    test('throws_exception_if_appends_not_included', () {
      try {
        final query = Query();

        query.target('pizzza').appends([]);
      } catch (e) {
        expect(e.toString(),
            'The appends() function takes at least one argument.');
      }
    });

    test('build_query_with_includes', () {
      final query = Query();

      query.target('pizza').includes('toppings');

      final expected = '/pizza?includes=toppings';

      expect(query.url(), expected);
    });

    test('throws_exception_with_includes_not_passed', () {
      try {
        final query = Query();

        query.target('pizza').includes('');
      } catch (e) {
        expect(e.toString(),
            'The includes() function takes at least one argument.');
      }
    });

    test('can_query_with_where', () {
      final query = Query();

      query.target('pizza').where('topping', 'cheese');

      final expected = '/pizza?filter[topping]=cheese';

      expect(query.url(), expected);
    });

    test('throw_error_ if_less_than_two_arguments_passed', () {
      try {
        final query = Query();

        query.target('pizza').where('topping', '');
      } catch (e) {
        expect(e.toString(),
            'Exception: The where() function takes 2 arguments both of string values.');
      }
    });

    test('can_build_query_with_whereIn', () {
      final query = Query();

      query.target('pizza').whereIn('topping', ['beef', 'cheese']);

      final expected = '/pizza?filter[topping]=beef,cheese';

      expect(query.url(), expected);
    });

    test('throws_exception_with_whereIn_no_arguments_passed', () {
      try {
        final query = Query();
        query.target('pizza').whereIn('', '');
      } catch (e) {
        expect(e.toString(),
            'Exception: The whereIn() function takes 2 arguments of (string, array).');
      }
    });

    test('throws_exeception_if_first_argument_invalid', () {
      try {
        final query = Query();
        query.target('pizza').whereIn(['oranges'], ['oranges', 'apples']);
      } catch (e) {
        expect(e.toString(),
            'The first argument for the whereIn() function must be a string or integer.');
      }
    });

    test('throws_exeception_if_second_argument_invalid', () {
      try {
        final query = Query();
        query.target('pizza').whereIn('oranges', {'oranges', 'apples'});
      } catch (e) {
        expect(e.toString(),
            'Exception: The second argument for the whereIn() function must be an array.');
      }
    });

    test('can_build_a_query_with_select', () {
      final query = Query();

      query.target('pizza').select(['name', 'date_added']);

      final expected = '/pizza?fields[pizza]=name,date_added';

      expect(query.url(), expected);
    });

    test('build_query_with_select', () {
      final query = Query();

      query.target('pizza').select(['name', 'date_added']);

      final expected = '/pizza?fields[pizza]=name,date_added';
      expect(query.url(), expected);
    });

    test('throws_exception_with_no_argument_passed_in_select', () {
      try {
        final query = Query();

        query.target('pizza').select(['']);
      } catch (e) {
        expect(e.toString(),
            'The fields() function takes a single argument of an array.');
      }
    });

    test('throws_exception_with_no_array_argument_passed_in_select', () {
      try {
        final query = Query();

        query.target('pizza').select('');
      } catch (e) {
        expect(
            e.toString(), 'Exception: The select() function must be an array');
      }
    });

    test('can_limit_the_query', () {
      final query = Query();

      query.target('pizza').where('name', 'meatlovers').limit(5);

      final expected = '/pizza?filter[name]=meatlovers&limit=5';

      expect(query.url(), expected);
    });

    test('can_sort_the_query', () {
      final query = Query();

      query.target('pizza').sort(['-name', 'flavour']);

      final expected = '/pizza?sort=-name,flavour';

      expect(query.url(), expected);
    });

    test('query_object_can_be_reused', () {
      final query = Query();

      final actualOne =
          query.target('pizza').where('name', 'macaroni_and_cheese').get();
      final expectOne = '/pizza?filter[name]=macaroni_and_cheese';

      final actualTwo = query.target('pizza').where('name', 'meatlovers').get();
      final expectedTwo = '/pizza?filter[name]=meatlovers';

      expect(actualOne, expectOne);
      expect(actualTwo, expectedTwo);
    });

    test('can_paginate_the query', () {
      final query = Query();

      query.target('pizza').limit(5).page(2);

      final expected = '/pizza?page=2&limit=5';

      expect(query.url(), expected);
    });

    test('throws_error_target_not_included', () {
      try {
        final query = Query();
        query.includes('toppings').url();
      } catch (e) {
        expect(e.toString(),
            'Please call the for() method before adding filters or calling url() / get().');
      }
    });
  });
}
