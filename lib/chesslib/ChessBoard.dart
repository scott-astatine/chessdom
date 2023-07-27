/*
  Author: Scott Astatine
  Date Created: 27-07-2023

*/

import 'ChessPiece.dart';
import 'Square.dart';
import 'rulesn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  /// Data Stores
  late List<List<ChessPiece?>> board;

  /// Current selected piece
  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;

  bool isWhiteTurn = true;

  /// Valid move x, y list for the current selected piece
  List<List<int>> validMoves = [];

  /// Kill list
  List<ChessPiece?> whiteKills = [];
  List<ChessPiece?> blackKills = [];

  /// inital kings postitions
  List<int> whiteKingPos = [7, 4];
  List<int> blackKingPos = [0, 4];
  bool checkMate = false;

  /// Data stores end

  @override
  void initState() {
    super.initState();
    board = initializeBoardPieces();
  }

  /// Change selected piece, selectedRow, selectedCol

  void setSelectedPiece(int row, int col) {
    setState(() {
      /// If the tapped piece is not selected
      if (board[row][col] != null && selectedPiece == null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      // If the tapped piece is the same piece
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite &&
          board[row][col]!.type == selectedPiece!.type &&
          row == selectedRow &&
          col == selectedCol) {
        selectedPiece = null;
        selectedRow = -1;
        selectedCol = -1;
      }

      /// To check if the piece is of same color
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      /// To move pieces
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      /// Clear selection if the tapped square is null
      else if (selectedPiece != null) {
        selectedPiece = null;
        selectedCol = -1;
        selectedRow = -1;
      }

      validMoves = calculateRawValidMoves(row, col, selectedPiece, board);
    });
  }

  /// Move piece to a new Row & Column and if there is a valid enemy kill add it
  /// to the respective kill list.

  void movePiece(int row, int col) {
    if (board[row][col] != null) {
      var capturedPiece = board[row][col];
      if (capturedPiece!.isWhite) {
        whiteKills.add(capturedPiece);
      } else {
        blackKills.add(capturedPiece);
      }
    }

    if (selectedPiece!.type == ChessPieceType.king) {
      selectedPiece!.isWhite
          ? whiteKingPos = [row, col]
          : blackKingPos = [row, col];
    }

    /// Move piece and null the old index
    board[row][col] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    /// Finding king's wherebout's
    if (askSquireKingsDeathStats(isWhiteTurn)) {
      checkMate = true;
    } else {
      checkMate = false;
    }

    setState(() {
      selectedRow = -1;
      selectedCol = -1;
      selectedPiece = null;
      validMoves = [];
    });
    isWhiteTurn = !isWhiteTurn;
  }

  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    ///
    /// Valid moves
    ///
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves =
        calculateRawValidMoves(row, col, piece, board);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        } else {
          realValidMoves = candidateMoves;
        }
      }
    }
    return realValidMoves;
  }

  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    ///
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    List<int>? originalKingPos;
    if (piece.type == ChessPieceType.king) {
      originalKingPos = piece.isWhite ? whiteKingPos : blackKingPos;

      if (piece.isWhite) {
        whiteKingPos = [endRow, endCol];
      } else {
        blackKingPos = [endRow, endCol];
      }
    }

    board[endCol][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = askSquireKingsDeathStats(piece.isWhite);

    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPos = originalKingPos!;
      } else {
        blackKingPos = originalKingPos!;
      }
    }
    return kingInCheck;
  }

  /// King's squirre
  bool askSquireKingsDeathStats(bool isWhiteKing) {
    List<int> kingPos = isWhiteKing ? whiteKingPos : blackKingPos;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing)
          continue;

        List<List<int>> pieceValidMoves =
            calculateRawValidMoves(i, j, board[i][j], board);

        if (pieceValidMoves
            .any((move) => move[0] == kingPos[0] && move[1] == kingPos[1])) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          /// Chess Board
          Expanded(
            flex: 3,
            child: Container(
              width: 600,
              height: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
              ),
              child: GridView.builder(
                itemCount: 8 * 8,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;

                  bool isWhite = (row + col) % 2 == 0;

                  bool isSelected = selectedCol == col && selectedRow == row;

                  bool isValidMove = false;
                  for (var v in validMoves) {
                    if (v[0] == row && v[1] == col && selectedPiece != null) {
                      isValidMove = true;
                    }
                  }
                  return ChessSquare(
                    isWhite: isWhite,
                    isSelected: isSelected,
                    piece: board[row][col],
                    isValidMove: isValidMove,
                    onTap: () {
                      setSelectedPiece(row, col);
                    },
                  );
                },
              ),
            ),
          ),

          Center(
            child: Text(
              checkMate ? "Check" : "",
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 30,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              // margin: EdgeInsets.all(40),
              width: constraints.maxWidth * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber,
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// Black killed pieces list
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: blackKills.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 9,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            child: SvgPicture.asset(
                              pieceImg[blackKills[index]!.type],
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                              width: 10,
                            ),
                          );
                        },
                      ),
                    ),

                    /// White killed pieces list
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: whiteKills.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            child: SvgPicture.asset(
                              pieceImg[whiteKills[index]!.type],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      );
    });
  }
}
