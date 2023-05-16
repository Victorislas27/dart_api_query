import 'dart:io';

import 'package:dart_api_query_package/src/builder.dart';
import 'package:dart_api_query_package/src/static_model.dart';
import 'package:dart_api_query_package/utils/merge_config.dart';

class Model extends StaticModel {
  late final Builder _builder;
  late final dynamic $http;

  Model() : super() {
    _builder = Builder(this);
  }

  dynamic _config;

  String baseUrl() {
    return baseUrl();
  }

  request(Map<String, String> config) {
    return request(config);
  }

  String resource() {
    return _builder.model.toString();
  }

  String url() {
    final urlBase = baseUrl();
    if (urlBase != '') {
      return urlBase + _builder.parseQuery();
    }

    _builder.reset();

    return _builder.parseQuery();
  }

  configs(config) {
    final property = Model();
    property._config(config);

    return this;
  }

  _reqConfig(config, {forceMethod = false}) {
    var config0 = mergeConfigs(_config, config);

    if (forceMethod) {
      config0['method'] = config['method'];
    }

    if (config0.containsKey('data')) {
      config0['data'].keys.any((property) {
        if (config0['data'][property] is List) {
          return config0['data'][property].any((value) => value is File);
        }

        return config0['data'][property] is File;
      });
    }

    return config0;
  }

  get() {
    final base = '${baseUrl()}/${resource()}';
    final url = '$base${_builder.query()}';

    return request(
      _reqConfig({'url': url, 'method': 'GET'}),
    ).then((response) {
      final collection = response.data;

      if (response.data.data != null) {
        response.data.data = collection;
      } else {
        response.data = collection;
      }

      return response.data;
    });
  }

  $get() {
    return get().then((response) => response.data || response);
  }

  Model include(List<String> args) {
    _builder.includes(args);

    return this;
  }

  Model append(List<String> args) {
    _builder.appends(args);

    return this;
  }

  Model select(List<String> args) {
    _builder.select(args);

    return this;
  }

  Model where(String key, String value) {
    _builder.where(key, value);

    return this;
  }

  Model whereIn(String key, List<String> list) {
    _builder.whereIn(key, list);

    return this;
  }

  Model page(int value) {
    _builder.page(value);

    return this;
  }

  Model limit(int value) {
    _builder.limit(value);

    return this;
  }

  Model sorts(List<String> args) {
    _builder.sort(args);

    return this;
  }

  Model custom(String args) {
    _builder.custom(args);

    return this;
  }
}
