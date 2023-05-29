import 'package:dart_api_query_package/src/builder.dart';
import 'package:dart_api_query_package/utils/stringify/stringify.dart';

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
    _parsePayload();

    return uri;
  }

  String reset() {
    return uri = '';
  }

  String prepend() {
    return uri == '' ? '?' : '&';
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

  bool hasPayload() {
    return builder.payload.isNotEmpty;
  }

  parametersName() {
    return builder.model.parameterNames();
  }

  void _parseIncludes() {
    if (!hasIncludes()) {
      return;
    }

    uri +=
        '${prepend()}${parametersName()['include']}=${builder.include.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
  }

  void _parseAppends() {
    if (!hasAppends()) {
      return;
    }

    uri +=
        '${prepend()}${parametersName()['append']}=${builder.append.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '').replaceAll('&', '')}';
  }

  void _parseFields() {
    if (!hasFields()) {
      return;
    }

    uri += prepend() +
        stringify({parametersName()['fields']: builder.fields}, encode: false, arrayFormat: PrefixGenerators.comma);
  }

  void _parseFilters() {
    if (!hasFilters()) {
      return;
    }

    uri += prepend() +
        stringify({parametersName()['filter']: builder.filters}, encode: false, arrayFormat: PrefixGenerators.comma);
  }

  void _parseSorts() {
    if (!hasSorts()) {
      return;
    }

    uri +=
        '${prepend()}${parametersName()['sort']}=${builder.sorts.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
  }

  void _parsePage() {
    if (!hasPage()) {
      return;
    }

    uri += '${prepend()}${parametersName()['page']}=${builder.pageValue}';
  }

  void _parseLimit() {
    if (!hasLimit()) {
      return;
    }

    uri += '${prepend()}${parametersName()['limit']}=${builder.limitValue}';
  }

  void _parsePayload() {
    if (!hasPayload()) {
      return;
    }

    uri += prepend() + stringify(builder.payload, encode: false, arrayFormat: PrefixGenerators.comma);
  }
}
