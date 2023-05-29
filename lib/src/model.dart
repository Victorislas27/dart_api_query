import 'package:dart_api_query_package/src/builder.dart';
import 'package:dart_api_query_package/src/static_model.dart';

class Model extends StaticModel {
  late final Builder builder;
  late final String _fromResource;
  late final String _customResource;

  Model() : super() {
    builder = Builder(this);
  }

  String baseUrl() {
    return baseUrl();
  }

  String resource() {
    return builder.model.toString();
  }

  parameterNames() {
    return {
      'include': 'include',
      'filter': 'filter',
      'sort': 'sort',
      'fields': 'fields',
      'append': 'append',
      'page': 'page',
      'limit': 'limit'
    };
  }

  void custom(List<dynamic> args) {
    if (args.isEmpty) {
      throw Exception('The custom() method takes a minimum of one argument.');
    }

    String slash = '';
    String resource = '';

    for (var value in args) {
      switch (value.runtimeType) {
        case String:
          resource += slash + (value as String).replaceAll(RegExp('^\\/'), '');
          break;
        case Model:
          resource += slash + (value as Model).resource();

          if ((value).isValidId((value).getPrimaryKey())) {
            resource += '/${(value).getPrimaryKey()}';
          }
          break;
        default:
          throw Exception(
              'Arguments to custom() must be strings or instances of Model.');
      }

      if (slash.isEmpty) {
        slash = '/';
      }
    }

    _customResource = resource;
  }

  primaryKey() {
    return 'id';
  }

  getPrimaryKey() {
    return primaryKey();
  }

  isValidId(id) {
    return !!id;
  }

  Model include(List<String> args) {
    builder.includes(args);

    return this;
  }

  Model params(Map<String, dynamic> payload) {
    builder.params(payload);

    return this;
  }

  Model append(List<String> append) {
    builder.appends(append);

    return this;
  }

  Model select(Map<String, dynamic> args) {
    builder.select(args);

    return this;
  }

  Model where(String key, String value) {
    builder.where(key, value);

    return this;
  }

  Model whereIn(String key, List<String> list) {
    builder.whereIn(key, list);

    return this;
  }

  Model page(int value) {
    builder.page(value);

    return this;
  }

  Model limit(int value) {
    builder.limit(value);

    return this;
  }

  Model orderBy(List<String> args) {
    builder.orderBy(args);

    return this;
  }
}
