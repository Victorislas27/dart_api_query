class StaticModel {
  static instance() {
    return instance();
  }

  static config(config) {
    final self = instance();
    self.config(config);

    return self;
  }

  static include(args) {
    final self = instance();
    self.include(args);

    return self;
  }

  static withA(args) {
    final self = instance();
    self.withA(args);

    return self;
  }

  static append(args) {
    final self = instance();
    self.append(args);

    return self;
  }

  static select(fields) {
    final self = instance();
    self.select(fields);

    return self;
  }

  static where(field, value) {
    final self = instance();
    self.where(field, value);

    return self;
  }

  static whereIn(field, array) {
    final self = instance();
    self.whereIn(field, array);

    return self;
  }
}
