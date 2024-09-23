enum UpdateChannel {
  release,
  preview;

  static final _name2Value = Map.fromEntries(values.map((v) => MapEntry(v.name, v)));

  static UpdateChannel? fromName(String? name) => _name2Value[name];
}
