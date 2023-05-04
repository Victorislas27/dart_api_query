// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dart_api_query_package/dart_api_query_package.dart';

abstract class Model implements Query {
  var atributtes = {};
  var query;
  @override
  late var baseUrl;

  Model(this.atributtes) : super() {
    if (atributtes.isEmpty) {
      query = Query(this);
    }

    if (baseUrl == '') {
      throw Exception('You must declare baseURL() method.');
    }
  }
}
