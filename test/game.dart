import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sit/game/minesweeper/utils.dart';
import 'package:sit/utils/list2d/impl.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

void main() {
  group("List2D", () {
    test("Test generating", () {
      final map = List2D.generate(9, 9, (row, column) => (row, column));
      final map2d = map.to2DList();
      for (final row in map2d) {
        print(row);
      }
    });
    test("Test subview", () {
      final map = List2D.generate(9, 9, (row, column) => (row, column));
      final sub = map.subview(rows: 5, columns: 5, rowStart: 3, columnStart: 3);
      final sub2d = sub.to2DList();
      for (final row in sub2d) {
        print(row);
      }
    });
  });

  group("Minesweeper", () {
    test("Test generate symmetric range", () {
      assert(generateSymmetricRange(5, 8).toList().equals([-7, -6, -5, 5, 6, 7]));
      assert(generateSymmetricRange(0, 8).toList().equals([-7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7]));
      assert(generateSymmetricRange(0, 0).toList().equals([]));
      assert(generateSymmetricRange(0, 1).toList().equals([0]));
      assert(generateSymmetricRange(0, 2).toList().equals([-1, 0, 1]));
      assert(generateSymmetricRange(10, 10).toList().equals([]));
      assert(generateSymmetricRange(9, 10).toList().equals([-9, 9]));
    });
    test("Test generateCoord", () {
      assert(generateCoord(1).toList().equals([(0, 0)]));
      assert(generateCoord(2)
          .toList()
          .equals([(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)]));
      assert(generateCoord(3).toList().equals([
        (-2, -2),
        (-2, -1),
        (-2, 0),
        (-2, 1),
        (-2, 2),
        (-1, -2),
        (-1, -1),
        (-1, 0),
        (-1, 1),
        (-1, 2),
        (0, -2),
        (0, -1),
        (0, 0),
        (0, 1),
        (0, 2),
        (1, -2),
        (1, -1),
        (1, 0),
        (1, 1),
        (1, 2),
        (2, -2),
        (2, -1),
        (2, 0),
        (2, 1),
        (2, 2)
      ]));
    });
    assert(generateCoord(3, startWith: 2).toList().equals([(-2, -2), (-2, 2), (2, -2), (2, 2)]));
    assert(generateCoord(5, startWith: 3).toList().equals([
      (-4, -4),
      (-4, -3),
      (-4, 3),
      (-4, 4),
      (-3, -4),
      (-3, -3),
      (-3, 3),
      (-3, 4),
      (3, -4),
      (3, -3),
      (3, 3),
      (3, 4),
      (4, -4),
      (4, -3),
      (4, 3),
      (4, 4)
    ]));
  });

  group("Sudoku", () {
    test("Test generating", () {
      final generator = SudokuGenerator(emptySquares: 18);
      print(generator.newSudoku);
      print(generator.newSudokuSolved);
    });
  });
}
