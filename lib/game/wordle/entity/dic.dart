class WordleWordSet {
  final String name;

  const WordleWordSet._({
    required this.name,
  });

  static const all = WordleWordSet._(
    name: "all",
  );
  static const cet4 = WordleWordSet._(
    name: "cet-4",
  );
  static const cet6 = WordleWordSet._(
    name: "cet-6",
  );
  static const toefl = WordleWordSet._(
    name: "toefl",
  );
  static final name2mode = {
    "all": all,
    "cet-4": cet4,
    "cet-6": cet6,
    "toefl": toefl,
  };

  static final values = [
    all,
    cet4,
    cet6,
    toefl,
  ];
}
