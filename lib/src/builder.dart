import 'package:dart_api_query_package/src/model.dart';
import 'package:dart_api_query_package/src/parser.dart';

class Builder {
  late Model model;
  late Map<String, String> queryParameters;
  late List<String> include;
  late List<String> append;
  late List<String> sorts;
  late String fields;
  late Map<String, String> filters;
  late int? pageValue;
  late int? limitValue;
  late String customModel;
  late Parser parser;

  Builder(this.model) {
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
    fields = '';
    filters = {};
    pageValue = null;
    limitValue = null;
    customModel = '';
    parser = Parser(this);
  }

  query() {
    return parser.parse();
  }

  String reset() {
    return parser.uri = '';
  }

  String resource() {
    return model.resource();
  }

  String custom(args) {
    customModel = args;

    return customModel;
  }

  String parseQuery() {
    if (customModel != '') {
      return '/$customModel${parser.parse()}';
    }
    reset();
    return '/${model.runtimeType.toString().toLowerCase()}${parser.parse()}';
  }

  Builder includes(List<String> include) {
    include.removeWhere((item) => item.isEmpty);
    if (include.isEmpty) {
      throw Exception(
          'The ${queryParameters['includes']}() should not be empty.');
    }

    this.include = include;

    return this;
  }

  Builder appends(List<String> append) {
    append.removeWhere((item) => item.isEmpty);
    if (append.isEmpty) {
      throw Exception(
          'The ${queryParameters['appends']}s() function takes at least one argument.');
    }

    this.append = append;

    return this;
  }

  List<String> select(List<String> fields) {
    fields.removeWhere((item) => item.isEmpty);
    if (fields.isEmpty) {
      throw Exception('The select() function must must not be Empty.');
    }

    this.fields = fields.join(',');

    return fields;
  }

  Builder where(String key, String value) {
    if (key.isEmpty || value.isEmpty) {
      throw Exception('The where() function takes 2 not empty strings.');
    }

    filters[key] = value;

    return this;
  }

  void whereIn(String key, List<String> list) {
    list.removeWhere((item) => item.isEmpty);
    if (key == '' || list.isEmpty) {
      throw Exception(
          'The whereIn() function expects not empty key and not empty list.');
    }
    filters[key] = list.join(',');
  }

  void sort(List<String> args) {
    args.removeWhere((item) => item.isEmpty);
    if (args.isEmpty) {
      throw Exception('The sort() function expects not empty values.');
    }
    sorts = args;
  }

  Builder page(int value) {
    pageValue = value;

    return this;
  }

  Builder limit(int value) {
    limitValue = value;

    return this;
  }
}
