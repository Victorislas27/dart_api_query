import 'package:dart_api_query_package/src/builder.dart';
import 'package:dart_api_query_package/utils/stringify.dart';

class Parser {
  late Builder builder;
  late String uri;

  Parser(this.builder) {
    builder;
    uri = '';
  }

  parse() {
    _parseIncludes();
    _parseAppends();
    _parseFields();
    _parseFilters();
    _parseSorts();
    _parsePage();
    _parseLimit();

    return uri;
  }

  bool hasIncludes() {
    return builder.include.isNotEmpty;
  }

  bool hasAppends() {
    return builder.append.isNotEmpty;
  }

  bool hasFields() {
    return builder.fields.isNotEmpty;
  }

  bool hasFilters() {
    return builder.filters.keys.isNotEmpty;
  }

  bool hasSorts() {
    return builder.sorts.isNotEmpty;
  }

  bool hasPage() {
    return builder.pageValue != null;
  }

  bool hasLimit() {
    return builder.limitValue != null;
  }

  String prepend() {
    return uri == '' ? '?' : '&';
  }

  void _parseIncludes() {
    if (builder.include.isNotEmpty) {
      uri +=
          '${prepend()}${builder.queryParameters['includes']}=${builder.include.join(',')}';
    }
  }

  void _parseAppends() {
    if (builder.append.isNotEmpty) {
      uri +=
          '${prepend().toString()}${builder.queryParameters['appends']}=${builder.append.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }
  }

  void _parseFields() {
    if (builder.fields.isNotEmpty) {
      uri += prepend() +
          SimplifiedUri.objectToQueryString({
            '${builder.queryParameters['fields']}[${builder.model.runtimeType.toString().toLowerCase()}]':
                builder.fields
          });
    }
  }

  void _parseFilters() {
    if (builder.filters.isNotEmpty) {
      uri += prepend() +
          SimplifiedUri.objectToQueryString(
              {builder.queryParameters['filters']: builder.filters});
    }
  }

  void _parseSorts() {
    if (builder.sorts.isNotEmpty) {
      uri +=
          '${prepend().toString()}${builder.queryParameters['sort']}=${builder.sorts.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }
  }

  void _parsePage() {
    if (builder.pageValue != null) {
      uri +=
          '${prepend().toString()}${builder.queryParameters['page']}=${builder.pageValue}';
    }
  }

  void _parseLimit() {
    if (builder.limitValue != null) {
      uri +=
          '${prepend().toString()}${builder.queryParameters['limit']}=${builder.limitValue}';
    }
  }
}
