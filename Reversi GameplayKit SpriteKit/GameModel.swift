//
//  GameModel.swift
//  Try1
//
//  Created by Владислав Эдуардович Дембский on 26.01.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import GameplayKit

final class GameModel: NSObject, GKGameModel {

    // array2D to store the game board representation
    var board = Board()
    var currentPlayer = gamePlayers[0] // human, white
    

    // players is required by GKGameModel protocol
    var players: [GKGameModelPlayer]? {
        return gamePlayers
    }

    // activePlayer is required by GKGameModel protocol
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }

    // applyGameModelUpdate is required by GKGameModel protocol
    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        let move = gameModelUpdate as! Move
        board[move.row,move.column] = currentPlayer.color
        flipCells(move.row, move.column)
        if playerHasValidMoves(board, currentPlayer.opponent) {
            currentPlayer = currentPlayer.opponent
        }
    }

    // copyWithZone is required by NSCopying protocol
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = GameModel()
        copy.setGameModel(self)
        return copy
    }

    // setGameModel is required by GKGameModel protocol
    func setGameModel(gameModel: GKGameModel) {
        let sourceModel = gameModel as! GameModel
        self.board = sourceModel.board
        self.currentPlayer = sourceModel.currentPlayer
    }

    // gameModelUpdatesForPlayer is required by GKGameModel protocol
    func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        let player = player as! Player
        var moves: [Move] = []
        for row in 0..<8 {
            for col in 0..<8 {
                    if isValidMove(self.board, player.color, row, col) {
                        moves.append(Move(row: row, column: col))
                    }
            }
        }
        player.numberOfMoves = moves.count
        if moves.isEmpty { return nil }
        return moves
    }

    let GKGameModelMaxScore: Int = 190
    let GKGameModelMinScore: Int = -190
    
    // scoreForPlayer is required by GKGameModel protocol
    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        let player = player as! Player
        var playerScore = player.numberOfMoves*3

        let corners = [(0,0),(0,7),(7,0),(7,7)]
        for corner in corners {
            if board[corner.0,corner.1] == player.color {playerScore+=30}
            else {
                if board[corner.0,corner.1] == player.opponent.color {
                    playerScore -= 30
                }
            }
        }

        playerScore += numberOfCells(self.board,player.color)
        playerScore -= numberOfCells(self.board,player.opponent.color)
        return playerScore
    }
    
    private func flipCells(row: Int,_ col: Int) {
        let playerColor = currentPlayer.color
        for dir in directions {
            if let move = checkOneDirection(board,playerColor,row,col,dir)
            {   // we have find a valid move
                // go back and flip
                for var nextRow = move.row - dir.row,
                    nextCol = move.column - dir.col;
                    (nextRow != row) || (nextCol != col);
                    nextRow -= dir.row, nextCol -= dir.col {
                    self.board[nextRow,nextCol] = playerColor
                }
            }
        }
    }

}
