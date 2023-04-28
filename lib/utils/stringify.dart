class SimplifiedUri {
  static Uri uri(String url, dynamic param) {
    final qs = objectToQueryString(param);
    final urlString = '$url?$qs';

    return Uri.parse(urlString);
  }

  static String objectToQueryString(dynamic json) {
    if (json == null) return '';

    List<String> queries = [];

    if (json is Map) {
      for (var key in json.keys) {
        if (json[key] is Map<dynamic, dynamic>) {
          generateInnerMap(queries, '$key', json[key]);
        } else if (json[key] is List) {
          generateInnerList(queries, '$key', json[key]);
        } else {
          final value = json[key];
          queries.add('$key=$value');
        }
      }
    } else if (json is List) {
      generateInnerList(queries, '', json);
    }

    return Uri.decodeQueryComponent(queries.join('&'));
  }

  static generateInnerMap(List<String> queryList, String parentKey,
      Map<dynamic, dynamic> innerJson) {
    for (var key in innerJson.keys) {
      if (innerJson[key] is Map<dynamic, dynamic>) {
        generateInnerMap(queryList, '$parentKey[$key]', innerJson[key]);
      } else if (innerJson[key] is List) {
        generateInnerList(queryList, '$parentKey[$key]', innerJson[key]);
      } else {
        final value = innerJson[key];

        queryList.add('$parentKey[$key]=$value');
      }
    }
  }

  static generateInnerList(
      List<String> queryList, String parentKey, List<dynamic> innerList) {
    for (var item in innerList) {
      if (item is Map) {
        generateInnerMap(
            queryList, '$parentKey[]', item as Map<String, dynamic>);
      } else {
        queryList.add('$parentKey[]=$item');
      }
    }
  }
}
