extension type const SudokuCellNote(int _notes) {
  const SudokuCellNote.empty() : _notes = 0;

  factory SudokuCellNote.fromJson(dynamic json) {
    return SudokuCellNote((json as num).toInt());
  }

  int toJson() => _notes;

  /// Setter for a specific note (1-9)
  SudokuCellNote setNoted(int number, bool value) {
    if (number < 1 || number > 9) {
      throw ArgumentError("Invalid note number. Must be between 1 and 9.");
    }

    // Calculate bit position for the note (0 for 1st bit, 1 for 2nd, etc.)
    final int bitPosition = number - 1;

    // Update the bitmask based on the value
    final newNotes = value ? (_notes | (1 << bitPosition)) : (_notes & ~(1 << bitPosition));

    // Create a new instance with the updated bitmask
    return SudokuCellNote(newNotes);
  }

  /// Getter for a specific note (1-9)
  bool getNoted(int number) {
    if (number < 1 || number > 9) {
      throw ArgumentError("Invalid note number. Must be between 1 and 9.");
    }

    final int bitPosition = number - 1;
    return (_notes & (1 << bitPosition)) != 0;
  }

  bool get anyNoted {
    // 0b111111111
    return (_notes & 0x1FF) != 0;
  }
}
