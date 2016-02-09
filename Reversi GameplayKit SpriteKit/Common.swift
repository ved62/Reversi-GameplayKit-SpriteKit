//
//  Common.swift
//  Try4
//
//  Created by Владислав Эдуардович Дембский on 02.02.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

// enum for board cells
enum CellType: Int {
    case Empty = 0, White = 1, Black = -1
}

struct Board {
    // array to store the game board representation
    var grid = [CellType](count: 64, repeatedValue: .Empty)

    subscript (row: Int, column: Int) -> CellType {
        get {
            return grid[row*8 + column]
        }
        set {
            grid[row*8 + column] = newValue
        }
    }
}

let numberOfCells = { (board: Board,color: CellType) -> Int in
    return board.grid.filter({$0 == color}).count
    }

// array to keep both game playyers information
let gamePlayers = [Player(playerColor: .White),Player(playerColor: .Black)]

// Array to keep all possible directions within game board
let directions: [(row: Int,col: Int)] =
    [ ( 1,-1), ( 1,0), ( 1,1),  // up-left, up, up-right
      ( 0,-1),         ( 0,1),  // left, ,right
      (-1,-1), (-1,0), (-1,1) ] // down-left, down, down-right

// this function is used by both isValidMove and flipCells
func checkOneDirection(board: Board,_ color: CellType,_ row: Int,_ col: Int,
    _ dir: (row: Int,col: Int) ) -> Move? {

    // closure to check if we are on board
    let positionOutOfRange = {return ($0<0) || ($0>7)}
    let opponentColor: CellType = (color == .White) ? .Black : .White
    var nextRow = row + dir.row
    if positionOutOfRange(nextRow) {
        return nil
    }
    var nextCol = col + dir.col
    if positionOutOfRange(nextCol) {
        return nil
    }
    if board[nextRow,nextCol] != opponentColor  {
        return nil // neibor is empty or has the same color
    }
    while board[nextRow,nextCol] == opponentColor {
        nextRow += dir.row
        if positionOutOfRange(nextRow) {
            return nil
        }
        nextCol += dir.col
        if positionOutOfRange(nextCol) {
            return nil
        }
    }
    if board[nextRow,nextCol] == color
    {
        return Move(row: nextRow, column: nextCol)
        // we have find a possible move
    }
    return nil
}

func isValidMove(board: Board,_ color: CellType,_ row: Int,_ col: Int) -> Bool {
    if board[row,col] != .Empty {
        return false
    }
    for dir in directions {
        if checkOneDirection(board, color, row, col, dir) != nil {
            return true
        }
    }
    return false // not valid move
}

func playerHasValidMoves(board: Board,_ player: Player) -> Bool {
    for row in 0..<8 {
        for col in 0..<8 {
            if isValidMove(board, player.color, row, col) {
                return true
            }
        }
    }
    return false
}


