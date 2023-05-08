// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dart_api_query_package/src/parse.dart';

abstract class Query {
  var model;
  var baseUrl;
  var queryParameters;
  var options = {};
  var include;
  var append;
  var sorts;
  var fields;
  var filters;
  var pageValue;
  var limitValue;
  var paramsObj;
  var parser;

  Query([options]) {
    model = null;
    baseUrl = null;
    queryParameters = {
      'filters': 'filter',
      'fields': 'fields',
      'includes': 'includes',
      'appends': 'append',
      'page': 'page',
      'limit': 'limit',
      'sort': 'sort'
    };

    include = [];
    append = [];
    sorts = [];
    fields = {};
    filters = {};
    pageValue = null;
    limitValue = null;
    paramsObj = null;

    parser = Parser(this);
  }

  get() {
    if (baseUrl != '') {
      reset();
      return baseUrl + parseQuery();
    }

    reset();
    return parseQuery();
  }

  url() {
    return get();
  }

  reset() {
    parser.uri = '';
  }

  parseQuery() {
    if (model == '') {
      throw Exception(
          'Please call the for() method before adding filters or calling url() / get().');
    }

    return '/$model${parser.parse()}';
  }

  includes(include) {
    if (include.length == null) {
      throw Exception(
          'The ${queryParameters.includes}s() function takes at least one argument.');
    }

    this.include = include;

    return this;
  }

  appends(append) {
    if (append.length == null) {
      throw Exception(
          'The ${queryParameters.appends}s() function takes at least one argument.');
    }

    this.append = append;

    return this;
  }

  select(fields) {
    if (fields == null || fields.runtimeType != List<String>) {
      throw Exception('The select() function must be an array');
    }

    if (fields.length == 0) {
      throw Exception(
          'The ${queryParameters.fields}() function takes a single argument of an array.');
    }

    if (fields[0].runtimeType == String ||
        fields[0].runtimeType == List<String>) {
      this.fields = fields.join(',');
    }
    if (fields[0].runtimeType == Object) {
      (fields[0]).forEach(([key, value]) => {fields[key] = value.join(',')});
    }

    return this;
  }

  where(key, value) {
    if (key == '' || value == '') {
      throw Exception(
          'The where() function takes 2 arguments both of string values.');
    }

    if (value.runtimeType == Object || value.runtimeType == List<String>) {
      throw Exception(
          'The second argument to the where() function must be a string. Use whereIn() if you need to pass in an array.');
    }

    filters[key] = value;

    return this;
  }

  whereIn(key, array) {
    if (key == '' || array == '') {
      throw Exception(
          'The whereIn() function takes 2 arguments of (string, array).');
    }

    if (key.runtimeType == Object || key.runtimeType == List) {
      throw Exception(
          'The first argument for the whereIn() function must be a string or integer.');
    }

    if (array.runtimeType != List<String>) {
      throw Exception(
          'The second argument for the whereIn() function must be an array.');
    }

    filters[key] = array.join(',');
  }

  sort(args) {
    sorts = args;

    return this;
  }

  page(value) {
    if (value.runtimeType != int) {
      throw Exception(
          'The page() function takes a single argument of a number');
    }

    pageValue = value;

    return this;
  }

  limit(value) {
    if (value.runtimeType != int) {
      throw Exception(
          'The limit() function takes a single argument of a number.');
    }

    limitValue = value;

    return this;
  }
}
