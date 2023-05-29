import 'package:dart_api_query_package/src/model.dart';

class ModelWithParamNames extends Model {
  @override
  parameterNames() {
    return {
      'include': 'include_custom',
      'filter': 'filter_custom',
      'sort': 'sort_custom',
      'fields': 'fields_custom',
      'append': 'append_custom',
      'page': 'page_custom',
      'limit': 'limit_custom'
    };
  }
}
