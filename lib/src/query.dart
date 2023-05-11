import 'package:dart_api_query_package/utils/stringify.dart';

abstract class Query {
  late String model;
  late Map<String, String> queryParameters;
  Map<String, String> options = {};
  late String include;
  late List append;
  late List<String> sorts;
  late String fields;
  late Map<String, String> filters;
  late int? pageValue;
  late int? limitValue;
  late String uri;

  Query([options]) {
    queryParameters = {
      'filters': 'filter',
      'fields': 'fields',
      'includes': 'includes',
      'appends': 'append',
      'page': 'page',
      'limit': 'limit',
      'sort': 'sort'
    };

    uri = '';
    model = '';
    include = '';
    append = [];
    sorts = [];
    fields = '';
    filters = {};
    pageValue = null;
    limitValue = null;
  }

  parse() {
    parseIncludes();
    parseAppends();
    parseFields();
    parseFilters();
    parseSorts();
    parsePage();
    parseLimit();

    return uri;
  }

  String prepend() {
    final url = uri == '' ? '?' : '&';
    return url;
  }

  parseIncludes() {
    if (include.isNotEmpty) {
      uri += '${prepend()}${queryParameters['includes']}=${include.toString()}';
    }
    return;
  }

  parseAppends() {
    if (append.isNotEmpty) {
      uri +=
          '${prepend().toString()}${queryParameters['appends']}=${append.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }

    return;
  }

  parseFields() {
    if (fields.isNotEmpty) {
      final fields = {
        '${queryParameters['fields']}[${resource()}]': this.fields
      };

      final ob = SimplifiedUri.objectToQueryString(fields);

      uri += prepend() + ob;
    }

    return;
  }

  parseFilters() {
    if (filters.isNotEmpty) {
      final filters = {queryParameters['filters']: this.filters};

      final ob = SimplifiedUri.objectToQueryString(filters);

      uri += prepend() + ob;
    }

    return;
  }

  parseSorts() {
    if (sorts.isNotEmpty) {
      uri +=
          '${prepend().toString()}${queryParameters['sort']}=${sorts.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }

    return;
  }

  parsePage() {
    if (pageValue == null) {
      return;
    }

    uri += '${prepend().toString()}${queryParameters['page']}=$pageValue';
  }

  parseLimit() {
    if (limitValue == null) {
      return;
    }
    uri += '${prepend().toString()}${queryParameters['limit']}=$limitValue';
  }

  baseUrl() {
    return this;
  }

  resource() {
    return this;
  }

  custom(model) {
    this.model = model;

    return this;
  }

  get() {
    final urlBase = baseUrl();
    if (urlBase != '') {
      return urlBase + parseQuery();
    }

    reset();
    return parseQuery();
  }

  url() {
    return get();
  }

  reset() {
    uri = '';
  }

  parseQuery() {
    final queryModel = resource();
    if (model == '') {
      reset();
      return '/$queryModel${parse()}';
    } else {
      return '/$model${parse()}';
    }
  }

  includes(include) {
    if (include.length == null) {
      throw Exception(
          'The ${queryParameters['includes']}s() function takes at least one argument.');
    }

    this.include = include;

    return this;
  }

  appends(append) {
    if (append.length == null) {
      throw Exception(
          'The ${queryParameters['appends']}s() function takes at least one argument.');
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
          'The ${queryParameters['fields']}() function takes a single argument of an array.');
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

    if (key.runtimeType == Object || key.runtimeType == List<String>) {
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
