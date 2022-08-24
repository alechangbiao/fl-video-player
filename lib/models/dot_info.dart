abstract class DotInfo<T> {
  /// Get the value from a given `<String>key`
  ///
  /// For example, `class C` conforms to `DotInfo` and it has a property `prop`,
  /// instead of calling `c.prop` we can use:
  ///
  ///     c.getValue(key: "prop");
  dynamic getValue({required String key});

  void update({required Map<String, dynamic> updates});

  Map<String, dynamic> toJson();
}
