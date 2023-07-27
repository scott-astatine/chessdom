/*
  Author: Scott Astatine
  Date Created: 27-07-2023

*/

import 'ChessPiece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChessSquare extends StatelessWidget {
  const ChessSquare({
    super.key,
    required this.isWhite,
    required this.isSelected,
    required this.piece,
    required this.onTap,
    required this.isValidMove,
  });
  final bool isWhite;

  final bool isSelected;

  final bool isValidMove;

  final ChessPiece? piece;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Color? sqColor;

    var bg = isWhite ? Colors.white : Colors.black38;

    Widget? sqChild = piece != null
        ? SvgPicture.asset(
            pieceImg[piece!.type],
            colorFilter: piece!.isWhite
                ? null
                : ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
          )
        : null;

    if (isSelected) {
      sqColor = Colors.orange[200];
    } else if (isValidMove) {
      // sqColor = Colors.lightGreenAccent.withOpacity(0.7);
      sqChild = AnimatedContainer(
        color: bg,
        duration: Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.all(piece != null ? 8 : 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: isWhite ? Colors.black : Colors.white,
          ),
          child: Container(
            margin: EdgeInsets.all(piece != null ? 2 : 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: !isWhite ? Colors.black38 : Colors.white,
            ),
            child: piece != null
                ? SvgPicture.asset(
                    pieceImg[piece!.type],
                    colorFilter: ColorFilter.mode(
                      Colors.redAccent,
                      BlendMode.srcIn,
                    ),
                  )
                : null,
          ),
        ),
      );
    } else {
      sqColor = bg;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: sqColor,
          // borderRadius: BorderRadius.circular(isSelected ? 10 : 0),
        ),
        duration: Duration(milliseconds: 100),
        child: sqChild,
      ),
    );
  }
}

