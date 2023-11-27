import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'logic.dart';

final boxColors = <int, Color>{
  2: Colors.orange[50]!,
  4: Colors.orange[100]!,
  8: Colors.orange[200]!,
  16: Colors.orange[300]!,
  32: Colors.orange[400]!,
  64: Colors.orange[500]!,
  128: Colors.orange[600]!,
  256: Colors.orange[700]!,
  512: Colors.orange[800]!,
  1024: Colors.orange[900]!,
};

// TODO: I18n game
class Game2048Page extends StatefulWidget {
  const Game2048Page({super.key});

  @override
  State<StatefulWidget> createState() => Game2048PageState();
}

const _dragThreshold = 2.0;

class Game2048PageState extends State<Game2048Page> {
  static const int row = 4;
  static const int column = 4;

  bool _isDragging = false;
  bool _isGameOver = false;
  final Game _game = Game(row, column);

  late MediaQueryData _queryData;
  final double cellPadding = 5.0;
  final EdgeInsets _gameMargin = const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0);

  final startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() {
    _game.init();
    _isGameOver = false;
    setState(() {});
  }

  void moveLeft() {
    performFeedback();

    setState(() {
      _game.moveLeft();
      checkGameOver();
    });
  }

  void moveRight() {
    performFeedback();

    setState(() {
      _game.moveRight();
      checkGameOver();
    });
  }

  void moveUp() {
    performFeedback();

    setState(() {
      _game.moveUp();
      checkGameOver();
    });
  }

  void moveDown() {
    performFeedback();

    setState(() {
      _game.moveDown();
      checkGameOver();
    });
  }

  Future<void> performFeedback() async {
    await HapticFeedback.lightImpact();
  }

  void checkGameOver() {
    if (_game.isGameOver() && !_isGameOver) {
      _isGameOver = true;

      // 存储游戏记录
      final currentTime = DateTime.now();
      final time = currentTime.difference(startTime).inSeconds;
      final score = _game.score;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CellWidget> cellWidgets = <CellWidget>[];
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        cellWidgets.add(CellWidget(_game.get(r, c), this));
      }
    }

    _queryData = MediaQuery.of(context);

    List<Widget> children = <Widget>[];
    children.add(BoardGridWidget(this));
    children.addAll(cellWidgets);

    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
        actions: [
          PlatformTextButton(
            child: "New game".text(),
            onPressed: () {
              newGame();
            },
          )
        ],
      ),
      body: SizedBox.expand(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (details) {
            if (details.delta.distance == 0 || _isDragging) {
              return;
            }
            _isDragging = true;
            if (details.delta.direction > 0) {
              moveDown();
            } else {
              moveUp();
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.distance == 0 || _isDragging) {
              return;
            }
            _isDragging = true;
            if (details.delta.direction > 0) {
              moveLeft();
            } else {
              moveRight();
            }
          },
          onVerticalDragEnd: (_) {
            _isDragging = false;
          },
          onVerticalDragCancel: () {
            _isDragging = false;
          },
          onHorizontalDragDown: (_) {
            _isDragging = false;
          },
          onHorizontalDragCancel: () {
            _isDragging = false;
          },
          child: Container(
            margin: _gameMargin,
            width: _queryData.size.width,
            height: _queryData.size.width,
            child: Stack(children: children),
          ).center(),
        ),
      ),
    );
  }

  Widget buildScore() {
    return Container(
      color: Colors.orange[100],
      child: SizedBox(
        width: 130.0,
        height: 60.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Score', style: TextStyle(color: Colors.grey[700])),
              Text(
                _game.score.toString(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Size boardSize() {
    Size size = _queryData.size;
    double width = size.width - _gameMargin.left - _gameMargin.right;
    return Size(width, width);
  }
}

class BoardGridWidget extends StatelessWidget {
  final Game2048PageState state;

  const BoardGridWidget(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final boardSize = state.boardSize();
    double width = (boardSize.width - (Game2048PageState.column + 1) * state.cellPadding) / Game2048PageState.column;
    List<CellBox> backgroundBox = <CellBox>[];
    for (int r = 0; r < Game2048PageState.row; ++r) {
      for (int c = 0; c < Game2048PageState.column; ++c) {
        CellBox box = CellBox(
          left: c * width + state.cellPadding * (c + 1),
          top: r * width + state.cellPadding * (r + 1),
          size: width,
          color: Colors.grey[300]!,
        );
        backgroundBox.add(box);
      }
    }
    return Positioned(
      left: 0.0,
      top: 0.0,
      child: Container(
        width: state.boardSize().width,
        height: state.boardSize().height,
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Stack(
          children: backgroundBox,
        ),
      ),
    );
  }
}

class AnimatedCellWidget extends AnimatedWidget {
  final BoardCell cell;
  final Game2048PageState state;
  final Animation<double> animation;

  const AnimatedCellWidget({
    super.key,
    required this.cell,
    required this.state,
    required this.animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (Game2048PageState.column + 1) * state.cellPadding) / Game2048PageState.column;
    if (cell.number == 0) {
      return Container();
    } else {
      return CellBox(
        left: (cell.column * width + state.cellPadding * (cell.column + 1)) + width / 2 * (1 - animationValue),
        top: cell.row * width + state.cellPadding * (cell.row + 1) + width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: boxColors.containsKey(cell.number) ? boxColors[cell.number]! : boxColors[boxColors.keys.last]!,
        text: Text(
          cell.number.toString(),
          maxLines: 1,
          style: TextStyle(
            fontSize: 30.0 * animationValue,
            fontWeight: FontWeight.bold,
            color: cell.number < 32 ? Colors.grey[600] : Colors.grey[50],
          ),
        ),
      );
    }
  }
}

class CellWidget extends StatefulWidget {
  final BoardCell cell;
  final Game2048PageState state;

  const CellWidget(
    this.cell,
    this.state, {
    super.key,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
    widget.cell.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cell.isNew && !widget.cell.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.cell.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedCellWidget(
      cell: widget.cell,
      state: widget.state,
      animation: animation,
    );
  }
}

class CellBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text? text;

  const CellBox({
    required this.left,
    required this.top,
    required this.size,
    required this.color,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: Center(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.center, child: text)),
      ),
    );
  }
}
