
import 'package:dart_api_query_package/utils/stringify/side_channel.dart';

enum PrefixGenerators {
  brackets,
  comma,
  indices,
  repeat;

  @override
  String toString() {
    switch (this) {
      case PrefixGenerators.brackets:
        return 'brackets';
      case PrefixGenerators.comma:
        return 'comma';
      case PrefixGenerators.indices:
        return 'indices';
      case PrefixGenerators.repeat:
        return 'repeat';
    }
  }
}

final _arrayPrefixGenerators = {
  'brackets': (String prefix, dynamic key) => '$prefix[]',
  'comma': 'comma',
  'indices': (String prefix, dynamic key) => '$prefix[$key]',
  'repeat': (String prefix, dynamic key) => prefix
};

final _defaults = {
  'addQueryPrefix': false,
  'allowDots': false,
  'delimiter': '&',
  'encode': true,
  'encodeValuesOnly': false,
  'skipNulls': false,
  'strictNullHandling': false
};

final _isNonNullPrimitive = (dynamic v) => v is String || v is int || v is double || v is bool;
final _sentinel = <dynamic, dynamic>{};

List<String> _maybeMap(List<dynamic> val, Function func) {
  var mapped = <String>[];
  for (var i = 0; i < val.length; i += 1) {
    var tempValue = val.elementAt(i);
    if (tempValue != null) {
      mapped.add('${func(tempValue)}'.replaceAll('+', '%20'));
    }
  }

  return mapped;
}

List<String> _stringify(
    dynamic object,
    String prefix,
    dynamic generateArrayPrefix,
    bool commaRoundTrip,
    bool strictNullHandling,
    bool skipNulls,
    bool encoder,
    bool allowDots,
    bool encodeValuesOnly,
    SideChannel sideChannel) {
  var obj = object;

  dynamic tmpSc = sideChannel;
  var step = 0;
  var findFlag = false;
  ;
  while ((tmpSc = tmpSc.get(_sentinel)) != null && !findFlag) {
    var pos = tmpSc.get(object);
    step += 1;
    if (pos != null) {
      if (pos == step) {
        throw RangeError('Cyclic object value');
      } else {
        findFlag = true;
      }
    }

    if (tmpSc.get(_sentinel) == null) {
      step = 0;
    }
  }

  if (obj is DateTime) {
    obj = obj.toIso8601String();
  } else if (generateArrayPrefix == 'comma' && obj is List<String>) {
    obj = _maybeMap(obj, (dynamic value) {
      if (value is DateTime) {
        return value.toIso8601String();
      }

      return value;
    });
  }

  if (object == null) {
    if (strictNullHandling) {
      return [encoder && !encodeValuesOnly ? Uri.encodeQueryComponent(prefix).replaceAll('+', '%20') : prefix];
    }

    obj = '';
  }

  if (_isNonNullPrimitive(obj) || obj is StringBuffer) {
    if (encoder == true) {
      final keyValue = encodeValuesOnly ? prefix : Uri.encodeQueryComponent(prefix).replaceAll('+', '%20');
      final valueOfKey = Uri.encodeQueryComponent('$obj').replaceAll('+', '%20');
      return ['$keyValue=$valueOfKey'];
    }

    return ['$prefix=$obj'];
  }

  final values = <String>[];
  List<dynamic> objKeys;

  if (generateArrayPrefix == 'comma' && obj is List<String>) {
    if (encodeValuesOnly && encoder) {
      obj = _maybeMap(obj, Uri.encodeQueryComponent);
    }

    objKeys = obj.isNotEmpty
        ? [
            {'value': obj.join(',')}
          ]
        : [];
  } else if (obj is Map) {
    objKeys = obj.keys.toList();
  } else if (obj is List) {
    objKeys = obj.asMap().keys.toList();
  } else {
    return values;
  }

  var adjustedPrefix = commaRoundTrip && obj is List && obj.length == 1 ? '$prefix[]' : prefix;

  for (var j = 0; j < objKeys.length; ++j) {
    final key = objKeys.elementAt(j);
    final value = key is Map && key.containsKey('value')
        ? key['value']
        : obj is List
            ? obj.elementAt(key as int)
            : (obj as Map)[key];

    if (skipNulls && value == null) {
      continue;
    }

    final keyPrefix = obj is List
        ? generateArrayPrefix is Function
            ? generateArrayPrefix(adjustedPrefix, key) as String
            : adjustedPrefix
        : '$adjustedPrefix${(allowDots ? '.$key' : '[$key]')}';

    sideChannel.set(object, step);
    final valueSideChannel = SideChannel();
    valueSideChannel.set(_sentinel, sideChannel);
    values.addAll(_stringify(
        value,
        keyPrefix,
        generateArrayPrefix,
        commaRoundTrip,
        strictNullHandling,
        skipNulls,
        generateArrayPrefix == 'comma' && encodeValuesOnly && obj is List ? false : encoder,
        allowDots,
        encodeValuesOnly,
        valueSideChannel));
  }

  return values;
}

Map<String, dynamic> _normalizeStringifyOptions(
    {String? delimiter,
    bool? strictNullHandling,
    bool? skipNulls,
    bool? encode,
    PrefixGenerators? arrayFormat,
    bool? indices,
    bool? encodeValuesOnly,
    bool? addQueryPrefix,
    bool? allowDots}) {
  if (delimiter == null &&
      strictNullHandling == null &&
      skipNulls == null &&
      encode == null &&
      arrayFormat == null &&
      indices == null &&
      encodeValuesOnly == null &&
      addQueryPrefix == null &&
      allowDots == null) {
    return _defaults;
  }

  return {
    'addQueryPrefix': addQueryPrefix is bool ? addQueryPrefix : _defaults['addQueryPrefix'],
    'allowDots': allowDots is bool ? allowDots : _defaults['allowDots'],
    'delimiter': delimiter is String ? delimiter : _defaults['delimiter'],
    'encode': encode is bool ? encode : _defaults['encode'],
    'encodeValuesOnly': encodeValuesOnly is bool ? encodeValuesOnly : _defaults['encodeValuesOnly'],
    'skipNulls': skipNulls is bool ? skipNulls : _defaults['skipNulls'],
    'strictNullHandling': strictNullHandling is bool ? strictNullHandling : _defaults['strictNullHandling']
  };
}

String stringify(dynamic object,
    {String? delimiter,
    bool? strictNullHandling,
    bool? skipNulls,
    bool? encode,
    PrefixGenerators? arrayFormat,
    bool? indices,
    bool? encodeValuesOnly,
    bool? addQueryPrefix,
    bool? allowDots,
    bool? commaRoundTrip}) {
  var obj = object;
  var options = _normalizeStringifyOptions(
      delimiter: delimiter,
      strictNullHandling: strictNullHandling,
      skipNulls: skipNulls,
      encode: encode,
      arrayFormat: arrayFormat,
      indices: indices,
      encodeValuesOnly: encodeValuesOnly,
      addQueryPrefix: addQueryPrefix,
      allowDots: allowDots);

  final keys = <String>[];

  if (obj == null || obj is! Map) {
    return '';
  }

  String _arrayFormat;
  if (arrayFormat != null && _arrayPrefixGenerators.containsKey(arrayFormat.toString())) {
    _arrayFormat = arrayFormat.toString();
  } else if (indices != null) {
    _arrayFormat = indices ? 'indices' : 'repeat';
  } else {
    _arrayFormat = 'indices';
  }

  final generateArrayPrefix = _arrayPrefixGenerators[_arrayFormat];

  final _commaRoundTrip = generateArrayPrefix == 'comma' && commaRoundTrip != null && commaRoundTrip;

  final objKeys = (obj).keys;

  final sideChannel = SideChannel();
  for (var i = 0; i < objKeys.length; i++) {
    final key = objKeys.elementAt(i);

    if (options['skipNulls'] as bool && obj[key] == null) {
      continue;
    }

    keys.addAll(_stringify(
        obj[key],
        key,
        generateArrayPrefix,
        _commaRoundTrip,
        options['strictNullHandling'] as bool,
        options['skipNulls'] as bool,
        options['encode'] as bool,
        options['allowDots'] as bool,
        options['encodeValuesOnly'] as bool,
        sideChannel));
  }

  final joined = keys.join(options['delimiter'] as String);
  final prefix = options['addQueryPrefix'] as bool ? '?' : '';

  return joined.isNotEmpty ? '$prefix$joined' : '';
}
