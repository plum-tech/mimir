import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part "cell.g.dart";

@JsonEnum()
enum CellState {
  @JsonValue(0)
  covered,
  @JsonValue(1)
  blank,
  @JsonValue(2)
  flag;
}

@JsonSerializable()
@CopyWith()
class Cell {
  final int row;
  final int column;
  final bool mine;
  final CellState state;
  final int minesAround;

  const Cell({
    required this.row,
    required this.column,
    this.mine = false,
    this.state = CellState.covered,
    required this.minesAround,
  });

  Map<String, dynamic> toJson() => _$CellToJson(this);

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}
