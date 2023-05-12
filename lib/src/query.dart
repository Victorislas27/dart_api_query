import 'package:dart_api_query_package/utils/stringify.dart';

abstract class Query {
  late String _model;
  late Map<String, String> queryParameters;
  late String _include;
  late List _append;
  late List<String> _sorts;
  late String _fields;
  late Map<String, String> _filters;
  late int? _pageValue;
  late int? _limitValue;
  late String _uri;

  Query() {
    queryParameters = {
      'filters': 'filter',
      'fields': 'fields',
      'includes': 'includes',
      'appends': 'append',
      'page': 'page',
      'limit': 'limit',
      'sort': 'sort'
    };

    _uri = '';
    _model = '';
    _include = '';
    _append = [];
    _sorts = [];
    _fields = '';
    _filters = {};
    _pageValue = null;
    _limitValue = null;
  }

  _parse() {
    _parseIncludes();
    _parseAppends();
    _parseFields();
    _parseFilters();
    _parseSorts();
    _parsePage();
    _parseLimit();

    return _uri;
  }

  String prepend() {
    return _uri == '' ? '?' : '&';
  }

  void _parseIncludes() {
    if (_include.isNotEmpty) {
      _uri +=
          '${prepend()}${queryParameters['includes']}=${_include.toString()}';
    }
  }

  void _parseAppends() {
    if (_append.isNotEmpty) {
      _uri +=
          '${prepend().toString()}${queryParameters['appends']}=${_append.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }
  }

  void _parseFields() {
    if (_fields.isNotEmpty) {
      _uri += prepend() +
          SimplifiedUri.objectToQueryString(
              {'${queryParameters['fields']}[${resource()}]': _fields});
    }
  }

  void _parseFilters() {
    if (_filters.isNotEmpty) {
      _uri += prepend() +
          SimplifiedUri.objectToQueryString(
              {queryParameters['filters']: _filters});
    }
  }

  void _parseSorts() {
    if (_sorts.isNotEmpty) {
      _uri +=
          '${prepend().toString()}${queryParameters['sort']}=${_sorts.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }
  }

  void _parsePage() {
    if (_pageValue == null) {
      return;
    }

    _uri += '${prepend().toString()}${queryParameters['page']}=$_pageValue';
  }

  void _parseLimit() {
    if (_limitValue == null) {
      return;
    }
    _uri += '${prepend().toString()}${queryParameters['limit']}=$_limitValue';
  }

  String baseUrl() {
    return baseUrl();
  }

  String resource() {
    return resource();
  }

  String custom(model) {
    _model = model;

    return _model;
  }

  String get() {
    final urlBase = baseUrl();
    if (urlBase != '') {
      return urlBase + parseQuery();
    }

    reset();
    return parseQuery();
  }

  String url() {
    return get();
  }

  void reset() {
    _uri = '';
  }

  String parseQuery() {
    final queryModel = resource();
    if (_model == '') {
      reset();
      return '/$queryModel${_parse()}';
    } else {
      return '/$_model${_parse()}';
    }
  }

  Query includes(include) {
    if (include.length == null) {
      throw Exception(
          'The ${queryParameters['includes']}s() function takes at least one argument.');
    }

    _include = include;

    return this;
  }

  Query appends(append) {
    if (append.length == null) {
      throw Exception(
          'The ${queryParameters['appends']}s() function takes at least one argument.');
    }

    _append = append;

    return this;
  }

  List<String> select(fields) {
    if (fields == null || fields.runtimeType != List<String>) {
      throw Exception('The select() function must be an array');
    }

    if (fields.length == 0) {
      throw Exception(
          'The ${queryParameters['fields']}() function takes a single argument of an array.');
    }

    if (fields[0].runtimeType == String ||
        fields[0].runtimeType == List<String>) {
      _fields = fields.join(',');
    }
    if (fields[0].runtimeType == Object) {
      (fields[0]).forEach(([key, value]) => {fields[key] = value.join(',')});
    }

    return fields;
  }

  Query where(key, value) {
    if (key == '' || value == '') {
      throw Exception(
          'The where() function takes 2 arguments both of string values.');
    }

    if (value.runtimeType == Object || value.runtimeType == List<String>) {
      throw Exception(
          'The second argument to the where() function must be a string. Use whereIn() if you need to pass in an array.');
    }

    _filters[key] = value;

    return this;
  }

  void whereIn(key, array) {
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

    _filters[key] = array.join(',');
  }

  void sort(args) {
    _sorts = args;
  }

  Query page(value) {
    if (value.runtimeType != int) {
      throw Exception(
          'The page() function takes a single argument of a number');
    }

    _pageValue = value;

    return this;
  }

  Query limit(value) {
    if (value.runtimeType != int) {
      throw Exception(
          'The limit() function takes a single argument of a number.');
    }

    _limitValue = value;

    return this;
  }
}
