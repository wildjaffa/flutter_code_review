import 'package:flutter/material.dart';
import 'package:flutter_code_review/src/views/home/checker_piece.dart';

class CheckerSquare extends StatelessWidget {
  const CheckerSquare({
    super.key,
    required this.size,
    required this.color,
    required this.canAcceptPiece,
    this.piece,
    required this.onDrop,
  });

  final double size;
  final Color color;
  final CheckerPiece? piece;
  final bool canAcceptPiece;
  final Function(CheckerPiece checkerPiece) onDrop;

  @override
  Widget build(BuildContext context) {
    return canAcceptPiece
        ? DragTarget<CheckerPiece>(
            onAcceptWithDetails: (objects) {
              onDrop(objects.data);
            },
            builder: (context, item, item2) {
              return CheckerSquareContainer(
                  size: size,
                  color: color,
                  piece: piece,
                  canAcceptPiece: canAcceptPiece);
            },
          )
        : CheckerSquareContainer(
            size: size,
            color: color,
            piece: piece,
            canAcceptPiece: canAcceptPiece);
  }
}

class CheckerSquareContainer extends StatelessWidget {
  const CheckerSquareContainer({
    super.key,
    required this.size,
    required this.color,
    required this.piece,
    required this.canAcceptPiece,
  });

  final double size;
  final Color color;
  final CheckerPiece? piece;
  final bool canAcceptPiece;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: color,
      child: Center(
        child: canAcceptPiece
            ? Container(
                height: size / 3,
                width: size / 3,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              )
            : piece,
      ),
    );
  }
}
