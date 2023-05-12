import 'package:dart_api_query_package/utils/stringify.dart';

abstract class Query {
  late String _model;
  late Map<String, String> _queryParameters;
  late List<String> _include;
  late List<String> _append;
  late List<String> _sorts;
  late String _fields;
  late Map<String, String> _filters;
  late int? _pageValue;
  late int? _limitValue;
  late String _uri;

  Query() {
    _queryParameters = {
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
    _include = [];
    _append = [];
    _sorts = [];
    _fields = '';
    _filters = {};
    _pageValue = null;
    _limitValue = null;
  }

  /// abstract method that should be implemented by model.
  String baseUrl();

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
          '${prepend()}${_queryParameters['includes']}=${_include.join(',')}';
    }
  }

  void _parseAppends() {
    if (_append.isNotEmpty) {
      _uri +=
          '${prepend().toString()}${_queryParameters['appends']}=${_append.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }
  }

  void _parseFields() {
    if (_fields.isNotEmpty) {
      _uri += prepend() +
          SimplifiedUri.objectToQueryString(
              {'${_queryParameters['fields']}[${resource()}]': _fields});
    }
  }

  void _parseFilters() {
    if (_filters.isNotEmpty) {
      _uri += prepend() +
          SimplifiedUri.objectToQueryString(
              {_queryParameters['filters']: _filters});
    }
  }

  void _parseSorts() {
    if (_sorts.isNotEmpty) {
      _uri +=
          '${prepend().toString()}${_queryParameters['sort']}=${_sorts.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }
  }

  void _parsePage() {
    if (_pageValue != null) {
      _uri += '${prepend().toString()}${_queryParameters['page']}=$_pageValue';
    }
  }

  void _parseLimit() {
    if (_limitValue != null) {
      _uri +=
          '${prepend().toString()}${_queryParameters['limit']}=$_limitValue';
    }
  }

  String resource() {
    return '';
  }

  String custom(model) {
    _model = model;

    return _model;
  }

  String url() {
    final urlBase = baseUrl();
    if (urlBase != '') {
      return urlBase + parseQuery();
    }
    reset();
    return parseQuery();
  }

  void reset() {
    _uri = '';
  }

  String parseQuery() {
    if (_model == '') {
      reset();
      return '/${resource()}${_parse()}';
    }
    return '/$_model${_parse()}';
  }

  Query includes(List<String> include) {
    include.removeWhere((item) => item.isEmpty);
    if (include.isEmpty) {
      throw Exception(
          'The ${_queryParameters['includes']}() should not be empty.');
    }

    _include = include;

    return this;
  }

  Query appends(List<String> append) {
    append.removeWhere((item) => item.isEmpty);
    if (append.isEmpty) {
      throw Exception(
          'The ${_queryParameters['appends']}s() function takes at least one argument.');
    }

    _append = append;

    return this;
  }

  List<String> select(List<String> fields) {
    fields.removeWhere((item) => item.isEmpty);
    if (fields.isEmpty) {
      throw Exception('The select() function must must not be Empty.');
    }
    _fields = fields.join(',');

    return fields;
  }

  Query where(String key, String value) {
    if (key.isEmpty || value.isEmpty) {
      throw Exception('The where() function takes 2 not empty strings.');
    }

    _filters[key] = value;

    return this;
  }

  void whereIn(String key, List<String> list) {
    list.removeWhere((item) => item.isEmpty);
    if (key == '' || list.isEmpty) {
      throw Exception(
          'The whereIn() function expects not empty key and not empty list.');
    }
    _filters[key] = list.join(',');
  }

  void sort(List<String> args) {
    args.removeWhere((item) => item.isEmpty);
    if (args.isEmpty) {
      throw Exception('The sort() function expects not empty values.');
    }
    _sorts = args;
  }

  Query page(int value) {
    _pageValue = value;

    return this;
  }

  Query limit(int value) {
    _limitValue = value;

    return this;
  }
}
