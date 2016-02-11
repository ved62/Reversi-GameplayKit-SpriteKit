//
//  Board.swift
//  Reversi GameplayKit SpriteKit
//
//  Created by Владислав Эдуардович Дембский on 11.02.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

// enum for board cells
enum CellType: Int {
    case Empty = 0, White = 1, Black = -1
}

// Array 2D - grid 8x8
struct Board {
    // array to store the game board representation
    private var grid = [CellType](count: 64, repeatedValue: .Empty)

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
