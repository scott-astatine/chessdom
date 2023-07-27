import 'ChessPiece.dart';

/// Initialize board pieces
List<List<ChessPiece?>> initializeBoardPieces() {
  List<List<ChessPiece?>> tBoard = List.generate(
    8,
    (index) => List.generate(8, (index) => null),
  );

  /// Pawns
  for (int i = 0; i < 8; i++) {
    tBoard[1][i] = ChessPiece(
      isWhite: true,
      type: ChessPieceType.pawn,
    );
    tBoard[6][i] = ChessPiece(
      isWhite: false,
      type: ChessPieceType.pawn,
    );
  }

  /// Bishops

  tBoard[0][2] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.bishop,
  );
  tBoard[0][5] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.bishop,
  );
  tBoard[7][2] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.bishop,
  );
  tBoard[7][5] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.bishop,
  );

  /// Knights

  tBoard[0][1] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.knight,
  );
  tBoard[0][6] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.knight,
  );
  tBoard[7][1] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.knight,
  );
  tBoard[7][6] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.knight,
  );

  /// Queens

  tBoard[0][3] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.queen,
  );
  tBoard[7][3] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.queen,
  );

  /// Kings

  tBoard[0][4] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.king,
  );
  tBoard[7][4] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.king,
  );

  /// Rooks

  tBoard[0][0] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.rook,
  );
  tBoard[0][7] = ChessPiece(
    isWhite: true,
    type: ChessPieceType.rook,
  );
  tBoard[7][0] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.rook,
  );
  tBoard[7][7] = ChessPiece(
    isWhite: false,
    type: ChessPieceType.rook,
  );

  return tBoard;
}

List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece, List<List<ChessPiece?>> board) {
  List<List<int>> candidateMoves = [];

  if (piece == null) {
    return [];
  }

  bool isb(r, c) {
    return r >= 0 && r < 8 && c >= 0 && c < 8;
  }

  int direction = piece.isWhite ? 1 : -1;

  switch (piece.type) {
    case ChessPieceType.pawn:
      // if (isb(row, col)) candidateMoves.add([row + direction, col]);

      /// Pawns can move forward if the the square is not occupied and
      /// can kill diagonaly.
      if (isb(row + direction, col) && board[row + direction][col] == null) {
        candidateMoves.add([row + direction, col]);
      }

      /// For when pawn is at the begnning they can move 2 squares
      if ((row == 1 && piece.isWhite) || (row == 6 && !piece.isWhite)) {
        if (isb(row + 2 * direction, col) &&
            board[row + 2 * direction][col] == null &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + 2 * direction, col]);
        }
      }

      /// Pawns can kill diagonaly
      if (isb(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1]!.isWhite != piece.isWhite) {
        candidateMoves.add([row + direction, col - 1]);
      }

      if (isb(row + direction, col + 1) &&
          board[row + direction][col + 1] != null &&
          board[row + direction][col + 1]!.isWhite != piece.isWhite) {
        candidateMoves.add([row + direction, col + 1]);
      }
      break;
    case ChessPieceType.rook:
      var directions = [
        [-1, 0], // Up
        [1, 0], // down
        [0, -1], // left
        [0, 1], // right
      ];

      for (var direc in directions) {
        var i = 1;
        while (true) {
          var newRow = row + i * direc[0];
          var newCol = col + i * direc[1];
          if (!isb(newRow, newCol)) {
            break;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }
          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }
      break;
    case ChessPieceType.bishop:
      var moves = [
        [-1, -1],
        [-1, 1],
        [1, -1],
        [1, 1],
      ];
      for (var direc in moves) {
        var i = 1;
        while (true) {
          var newRow = row + i * direc[0];
          var newCol = col + i * direc[1];
          if (!isb(newRow, newCol)) {
            break;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }
          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }

      break;
    case ChessPieceType.queen:
      var moves = [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
        [-1, -1],
        [-1, 1],
        [1, -1],
        [1, 1],
      ];
      for (var direc in moves) {
        var i = 1;
        while (true) {
          var newRow = row + i * direc[0];
          var newCol = col + i * direc[1];
          if (!isb(newRow, newCol)) {
            break;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }
          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }
      break;
    case ChessPieceType.king:
      var moves = [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
        [-1, -1],
        [-1, 1],
        [1, -1],
        [1, 1],
      ];
      for (var mv in moves) {
        var newRow = row + mv[0];
        var newCol = col + mv[1];
        if (!isb(newRow, newCol)) {
          continue;
        }
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }
        candidateMoves.add([newRow, newCol]);
      }
      break;
    case ChessPieceType.knight:
      var moves = [
        [-2, -1], // Up 2 left 1
        [-2, 1], // Up 2 right 1
        [-1, -2], // Up 1 left 2
        [-1, 2], // Up 1 right 2
        [1, -2], // down 1 left 2
        [1, 2], // down 1 right 2
        [2, -1], // down 2 left 1
        [2, 1], // down 2 right 1
      ];
      for (var mv in moves) {
        var newRow = row + mv[0];
        var newCol = col + mv[1];
        if (!isb(newRow, newCol)) {
          continue;
        }
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newCol]);
          }
          continue;
        }
        candidateMoves.add([newRow, newCol]);
      }
      break;
  }
  return candidateMoves;
}
