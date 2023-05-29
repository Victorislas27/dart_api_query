class StaticModel {
  static instance() {
    return StaticModel();
  }

  static configs(config) {
    final self = instance();
    self.config(config);

    return self;
  }

  static include(List<String> args) {
    final self = instance();
    self.include(args);

    return self;
  }

  static append(List<String> args) {
    final self = instance();
    self.append(args);

    return self;
  }

  static select(List<String> args) {
    final self = instance();
    self.select(args);

    return self;
  }

  static where(String field, String value) {
    final self = instance();
    self.where(field, value);

    return self;
  }

  static whereIn(String field, List<String> list) {
    final self = instance();
    self.whereIn(field, list);

    return self;
  }

  static page(int value) {
    final self = instance();
    self.page(value);

    return self;
  }

  static limit(int value) {
    final self = instance();
    self.limit(value);

    return self;
  }

  static custom(String args) {
    final self = instance();
    self.custom(args);

    return self;
  }

  static params(Map<String, String> payload) {
    final self = instance();
    self.params(payload);

    return self;
  }

  static first() {
    final self = instance();

    return self.first();
  }

  static $first() {
    final self = instance();

    return self.$first();
  }

  static find(int id) {
    final self = instance();

    return self.find(id);
  }

  static $find(int id) {
    final self = instance();

    return self.$find(id);
  }

  static get() {
    final self = instance();

    return self.get();
  }

  static orderBy(List<String> args) {
    final self = instance();
    self.orderBy(args);
    return self;
  }

  static all() {
    final self = instance();

    return self.all();
  }

  static $get() {
    final self = instance();

    return self.$get();
  }

  static $all() {
    final self = instance();

    return self.$all();
  }
}
