import 'package:dart_api_query_package/src/model.dart';
import 'package:dart_api_query_package/src/parser.dart';

class Builder {
  late Model model;
  late List<String> include;
  late List<String> append;
  late List<String> sorts;
  late Map<dynamic, dynamic> fields;
  late Map<String, String> filters;
  late int? pageValue;
  late int? limitValue;
  late Map<String, dynamic> payload;

  late Parser parser;

  Builder(this.model) {
    include = [];
    append = [];
    sorts = [];
    fields = {};
    filters = {};
    pageValue = null;
    limitValue = null;
    payload = {};
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

  Builder includes(List<String> include) {
    include.removeWhere((item) => item.isEmpty);
    if (include.isEmpty) {
      throw Exception('The includes() should not be empty.');
    }

    this.include = include;

    return this;
  }

  Builder appends(List<String> append) {
    append.removeWhere((item) => item.isEmpty);
    if (append.isEmpty) {
      throw Exception('The appends() function takes at least one argument.');
    }

    this.append = append;

    return this;
  }

  Builder select(Map<String, dynamic> fields) {
    this.fields.addAll(fields);

    return this;
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

  void orderBy(List<String> fields) {
    fields.removeWhere((item) => item.isEmpty);
    if (fields.isEmpty) {
      throw Exception('The sort() function expects not empty values.');
    }
    sorts = fields;
  }


  Builder page(int value) {
    pageValue = value;

    return this;
  }

  Builder limit(int value) {
    limitValue = value;

    return this;
  }

  Builder params(Map<String, dynamic> args) {
    payload = args;

    return this;
  }
}
