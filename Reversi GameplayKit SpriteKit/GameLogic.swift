//
//  GameLogic.swift
//  Try6
//
//  Created by Владислав Эдуардович Дембский on 04.02.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import GameplayKit

final class GameLogic {

    private var gameScene: GameLogicUI
    private var gameModel = GameModel()
    private var alertActive = false

    private func addChip(color: CellType, row: Int, column: Int) {
        gameScene.displayChip(color, row: row, column: column)
        gameModel.board[row,column] = color
    }

    private func flipCells(row: Int,_ col: Int) {
        let playerColor = gameModel.currentPlayer.color
        for dir in directions {
            if let move = checkOneDirection(gameModel.board,playerColor,
                row,col,dir)
            { // we have find a valid move
                // go back and flip
                for var nextRow = move.row - dir.row,
                    nextCol = move.column - dir.col;
                    (nextRow != row) || (nextCol != col);
                    nextRow -= dir.row, nextCol -= dir.col {
                    gameScene.updateChip(playerColor, nextRow,
                        nextCol)
                    gameModel.board[nextRow,nextCol] = playerColor
                }
            }
        }
    }

    private func makeMove(row: Int,_ col: Int) {
        addChip(gameModel.currentPlayer.color, row: row, column: col)
        flipCells(row, col)
        let white = numberOfCells(gameModel.board, .White)
        let black = numberOfCells(gameModel.board, .Black)
        gameScene.updateCountsLabel(white, black: black)
        gameModel.currentPlayer = gameModel.currentPlayer.opponent

        if gameIsFinished() {
            alertActive = true
            var resultText: String
            switch white-black {
            case 1...64:
                resultText = "White win"
            case 0:
                resultText = "Draw"
            default:
                resultText = "Black win"
            }
            gameScene.displayAlert(resultText)
            return
        }

        if playerHasValidMoves(gameModel.board, gameModel.currentPlayer) {
            if gameModel.currentPlayer == gamePlayers[0] {
                return // wait for human move
            } else {
                aiMove() // let AI work
            }
        } else { // player must pass
            alertActive = true
            gameScene.displayAlert(
                "\(gameModel.currentPlayer.color) mast pass!")
        }
    }

    private func aiMove() {
        let strategist = GKMinmaxStrategist()
        strategist.gameModel = gameModel
        strategist.maxLookAheadDepth = 6
        let delay = 1.0
        let time = dispatch_time(DISPATCH_TIME_NOW,
            Int64(delay*Double(NSEC_PER_SEC)))
        gameScene.showAIIndicator(true)
        let mQueue = dispatch_get_main_queue()
        let cQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        dispatch_after(time, cQueue, {
            let move = strategist.bestMoveForActivePlayer() as! Move
            dispatch_async(mQueue, {
                self.gameScene.showAIIndicator(false)
                })
            dispatch_async(mQueue, {
                self.makeMove(move.row, move.column)
            })
        })
    }

    func gameIsFinished() -> Bool {
        if playerHasValidMoves(gameModel.board, gameModel.currentPlayer) ||
            playerHasValidMoves(gameModel.board,
                gameModel.currentPlayer.opponent)
        {
            return false
        }
        return true
    }
    
    func cellPressed(row: Int, _ column: Int) {
        if alertActive { // pass or game over
            alertActive = false
            gameScene.removeAlert()
            if gameIsFinished() {
                setInitialBoard()
                return
            }
            gameModel.currentPlayer = gameModel.currentPlayer.opponent
            if gameModel.currentPlayer == gamePlayers[1] {
                aiMove() // let AI work
            }
            return
        }
        if (row == -1) && (column == -1) {
            return // to allow user click in any place after alert
        }
        if gameModel.currentPlayer == gamePlayers[0] {
            if isValidMove(gameModel.board, gameModel.currentPlayer.color,
                row, column) {
                makeMove(row,column)
            }
        }
    }
    
    func setInitialBoard() {
        gameScene.clearGameView() // clear results of previous game
        for row in 0..<8 {
            for col in 0..<8 {
                switch (row,col) {
                case (3,3),(4,4) :
                    addChip(.White, row: row, column: col)
                case (3,4),(4,3) :
                    addChip(.Black, row: row, column: col)
                default:
                    gameModel.board[row,col] = .Empty
                }
            }
        }
        gameScene.updateCountsLabel(2,black: 2)
        gameModel.currentPlayer = gamePlayers[0]
    }

    init(scene: GameLogicUI) {
        self.gameScene = scene
    }

}
