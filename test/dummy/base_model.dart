import 'package:dart_api_query_package/src/model.dart';

abstract class BaseModel extends Model {
  @override
  baseUrl() {
    return 'http://127.0.0.1:8000';
  }

  @override
  request(config) {
    return $http.request(config);
  }
}
