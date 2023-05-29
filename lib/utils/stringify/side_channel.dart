
import 'package:dart_api_query_package/utils/stringify/weak_map.dart';

class SideChannel {
  WeakMap<dynamic, dynamic>? $wm;

  SideChannel(): $wm = null;

  void assertContain(dynamic key) {
    if (!has(key)) {
      throw Exception('Side channel does not contain key');
    }
  }

  dynamic get(dynamic key) {
    if ($wm != null) {
      return $wm!.get(key);
    }

    return null;
  }

  bool has(dynamic key) {
    if ($wm != null) {
      return $wm!.contains(key);
    }

    return false;
  }

  void set(dynamic key, dynamic value) {
    if ($wm == null) {
      $wm = WeakMap();
    }

    $wm!.add(key: key, value: value);
  }
}