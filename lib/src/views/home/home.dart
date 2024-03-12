import 'package:flutter/material.dart';
import 'package:flutter_code_review/src/views/home/checker_piece.dart';
import 'package:flutter_code_review/src/views/home/checker_square.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Color whiteSquare = Colors.white;
  final Color blackSquare = Colors.brown;

  late List<Player> players;
  List<Position> possibleMoves = [];

  dragStarted(pieceX, pieceY, CheckerPiece piece) {
    possibleMoves = [];
    for (var y = 0; y < 8; y++) {
      if (y == pieceY) continue;
      if (y != pieceY + 1 && y != pieceY - 1) continue;
      for (var x = 0; x < 8; x++) {
        if (x != pieceX + 1 && x != pieceX - 1) continue;
        if ((x + y) % 2 == 0) continue;
        if (squareHasPiece(Position(x, y)) != null) {
          continue;
        }
        possibleMoves.add(Position(x, y));
      }
    }
    setState(() {
      possibleMoves = possibleMoves;
    });
  }

  onPieceMoved(int x, int y, CheckerPiece checkerPiece) {
    for (var player in players) {
      player.isTurn = !player.isTurn;
      for (var playerPiece in player.pieces) {
        final originalPiece = playerPiece.piece;
        playerPiece.piece = CheckerPiece(
            color: playerPiece.piece.color,
            size: playerPiece.piece.size,
            canMove: player.isTurn,
            onDragStarted: (piece) {
              dragStarted(x, y, piece);
            },
            onDragCompleted: onDragCompleted);
        if (originalPiece != checkerPiece) continue;
        playerPiece.position = Position(x, y);
      }
    }
    setState(() {
      players = players;
      possibleMoves = [];
    });
  }

  onDragCompleted() {
    setState(() {
      possibleMoves = [];
    });
  }

  bool squareIsInPossibleMoves(int x, int y) {
    for (var move in possibleMoves) {
      if (move.x == x && move.y == y) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    players = [
      Player(
        playerPosition: 1,
        pieces: [
          for (var x = 0; x < 3; x++)
            for (var y = 0; y < 8; y++)
              if ((x + y) % 2 != 0)
                BoardPiece(
                  position: Position(x, y),
                  piece: CheckerPiece(
                    onDragStarted: (piece) {
                      dragStarted(x, y, piece);
                    },
                    onDragCompleted: onDragCompleted,
                    color: Colors.red,
                    size: 50,
                    canMove: true,
                  ),
                ),
        ],
      ),
      Player(
        playerPosition: 2,
        pieces: [
          for (var x = 5; x < 8; x++)
            for (var y = 0; y < 8; y++)
              if ((x + y) % 2 != 0)
                BoardPiece(
                  position: Position(x, y),
                  piece: CheckerPiece(
                    onDragStarted: (piece) => dragStarted(x, y, piece),
                    onDragCompleted: onDragCompleted,
                    color: Colors.black,
                    size: 50,
                    canMove: false,
                  ),
                ),
        ],
      ),
    ];
    players[0].isTurn = true;
    super.initState();
  }

  CheckerPiece? squareHasPiece(Position position) {
    for (var player in players) {
      for (var piece in player.pieces) {
        if (piece.position.x == position.x && piece.position.y == position.y) {
          return piece.piece;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
      ),
      body: Container(
        color: Colors.grey,
        child: Center(
          child: SizedBox(
            width: 400,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 8,
              children: [
                for (var x = 0; x < 8; x++)
                  for (var y = 0; y < 8; y++)
                    CheckerSquare(
                      size: 50,
                      color: (x + y) % 2 == 0 ? whiteSquare : blackSquare,
                      piece: squareHasPiece(Position(x, y)),
                      canAcceptPiece: squareIsInPossibleMoves(x, y),
                      onDrop: (piece) {
                        onPieceMoved(x, y, piece);
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Position {
  final int x;
  final int y;
  const Position(this.x, this.y);
}

class Player {
  final int playerPosition;
  final List<BoardPiece> pieces;
  bool isTurn = false;
  Player({
    required this.playerPosition,
    required this.pieces,
  });
}

class BoardPiece {
  Position position;
  CheckerPiece piece;
  BoardPiece({
    required this.position,
    required this.piece,
  });
}
