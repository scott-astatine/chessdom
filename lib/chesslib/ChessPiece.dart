enum ChessPieceType {
  pawn,
  knight,
  bishop,
  queen,
  rook,
  king,
}

Map pieceImg = {
  ChessPieceType.pawn: "assets/pawn.svg",
  ChessPieceType.bishop: "assets/bishop.svg",
  ChessPieceType.queen: "assets/queen.svg",
  ChessPieceType.king: "assets/king.svg",
  ChessPieceType.rook: "assets/rook.svg",
  ChessPieceType.knight: "assets/knight.svg",
};

class ChessPiece {
  const ChessPiece({
    required this.isWhite,
    required this.type,
  });
  final bool isWhite;
  final ChessPieceType type;
}
