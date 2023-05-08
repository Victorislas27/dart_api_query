import 'package:dart_api_query_package/src/query.dart';

abstract class Model extends Query {
  @override
  String get baseUrl => 'http://127.0.0.1:8000';
}
