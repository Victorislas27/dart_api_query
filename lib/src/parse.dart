// ignore_for_file: prefer_is_empty
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import '../utils/stringify.dart';

class Parser {
  var query;
  late String uri;

  Parser(this.query) {
    query = query;
    uri = '';
  }

  parse() {
    includes();
    appends();
    fields();
    filters();
    sorts();
    page();
    limit();
    params();

    return uri;
  }

  String prepend() {
    final url = uri == '' ? '?' : '&';
    return url;
  }

  includes() {
    if (query.include.length > 0) {
      uri +=
          '${prepend()}${query.queryParameters['includes']}=${query.include.toString()}';
    }
    return;
  }

  appends() {
    if (query.append.length > 0) {
      uri +=
          '${prepend().toString()}${query.queryParameters['appends']}=${query.append.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }

    return;
  }

  fields() {
    if (query.fields.length > 0) {
      final fields = {
        '${query.queryParameters['fields']}[${query.resource()}]': query.fields
      };

      final ob = SimplifiedUri.objectToQueryString(fields);

      uri += prepend() + ob;
    }

    return;
  }

  filters() {
    if (query.filters.length > 0) {
      final filters = {query.queryParameters['filters']: query.filters};

      final ob = SimplifiedUri.objectToQueryString(filters);

      uri += prepend() + ob;
    }

    return;
  }

  sorts() {
    if (query.sorts.length > 0) {
      uri +=
          '${prepend().toString()}${query.queryParameters['sort']}=${query.sorts.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}';
    }

    return;
  }

  page() {
    if (query.pageValue == null) {
      return;
    }

    uri +=
        '${prepend().toString()}${query.queryParameters['page']}=${query.pageValue}';
  }

  limit() {
    if (query.limitValue == null) {
      return;
    }
    uri +=
        '${prepend().toString()}${query.queryParameters['limit']}=${query.limitValue}';
  }

  params() {
    if (query.paramsObj == null) {
      return;
    }

    query.prepend() + json.encode(query.paramsObj);
  }
}
