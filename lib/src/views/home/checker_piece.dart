import 'package:flutter/material.dart';

class CheckerPiece extends StatelessWidget {
  const CheckerPiece({
    super.key,
    required this.color,
    required this.size,
    required this.canMove,
    required this.onDragStarted,
    required this.onDragCompleted,
  });
  final Color color;
  final double size;
  final bool isKing = false;
  final bool canMove;
  final Function() onDragCompleted;
  final Function(CheckerPiece) onDragStarted;

  @override
  Widget build(BuildContext context) {
    return canMove
        ? Draggable<CheckerPiece>(
            data: this,
            childWhenDragging:
                PieceContainer(color: color.withOpacity(.7), size: size),
            feedback: PieceContainer(color: color, size: size + 5),
            onDragStarted: () {
              onDragStarted(this);
            },
            onDraggableCanceled: (velocity, offset) {
              onDragCompleted();
            },
            onDragCompleted: onDragCompleted,
            child: PieceContainer(color: color, size: size),
          )
        : PieceContainer(color: color, size: size);
  }
}

class PieceContainer extends StatelessWidget {
  const PieceContainer({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      height: size,
      width: size,
      // Add your widget code here
    );
  }
}
