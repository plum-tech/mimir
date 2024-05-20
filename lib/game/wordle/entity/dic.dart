class WordleDic {
  final String name;

  const WordleDic._({
    required this.name,
  });

  static const all = WordleDic._(
    name: "all",
  );
  static const cet4 = WordleDic._(
    name: "cet4",
  );
  static const cet6 = WordleDic._(
    name: "cet6",
  );
  static const cetAll = WordleDic._(
    name: "cet-all",
  );
  static const toefl = WordleDic._(
    name: "toefl",
  );
  static final name2mode = {
    "all": all,
  };

  static final values = [
    all,
  ];
}
