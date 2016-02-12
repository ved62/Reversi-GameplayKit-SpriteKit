//
//  GameLogicUI.swift
//
//  Reversi OS X
//
//  Created by Владислав Эдуардович Дембский on 06.02.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import SpriteKit

final class GameLogicUI: SKScene {
    private var gameLogic: GameLogic!
    private var atlas: SKTextureAtlas!

    private var gearSprite: SKSpriteNode! // used for indication AI activity

    override func didMoveToView(view: SKView) {
        //create texture atlas for sprites
        atlas = createAtlas()
        gearSprite = createAIIndicator()
        displayEmptyBoard()
        gameLogic = GameLogic(scene: self)
        gameLogic.setInitialBoard()
    }

    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        if let node: SKSpriteNode = nodeAtPoint(location) as? SKSpriteNode {
            if let num = Int(node.name!) {
                let row = num / 10
                let column = num % 10
                gameLogic.cellPressed(row,column)
            }
        } else {gameLogic.cellPressed(-1,-1)}
    }

    func displayChip(color: CellType,row: Int,column: Int) {
        let cell = childNodeWithName("\(row)\(column)") as! SKSpriteNode
        let chipSize = CGSize(width: cell.size.width*0.8,
            height: cell.size.height*0.8)
        let texture = color == .White ?
            atlas.textureNamed(Constants.ChipImages.whiteChip) :
            atlas.textureNamed(Constants.ChipImages.blackChip)
        let chip = SKSpriteNode(texture: texture, size: chipSize)
        chip.name = cell.name
        chip.zPosition = 1
        cell.addChild(chip)
    }

    func updateChip(color: CellType,_ row: Int,_ column: Int) {
        let cell = childNodeWithName("\(row)\(column)") as! SKSpriteNode
        let chip = cell.children[0] as! SKSpriteNode
        let savedWidth = chip.frame.width
        let resizeToLine = SKAction.resizeToWidth(2, duration: 0.4)
        let texture = color == .White ?
            atlas.textureNamed(Constants.ChipImages.whiteChip) :
            atlas.textureNamed(Constants.ChipImages.blackChip)
        let changeColor = SKAction.setTexture(texture)
        let restoreWidth = SKAction.resizeToWidth(savedWidth, duration: 0.4)
        let sequence = SKAction.sequence(
            [resizeToLine,
             changeColor,
             restoreWidth])
        chip.runAction(sequence, completion: {chip.texture = texture})
    }

    func displayAlert(text: String) {
        let alert = SKLabelNode(fontNamed: Constants.Fonts.alertFont)
        let topSquare = self.childNodeWithName("74") as! SKSpriteNode
        let fontSize = topSquare.frame.height
        alert.fontSize = fontSize
        let x = self.frame.midX
        let y = self.frame.midY
        alert.position = CGPointMake(x, y)
        alert.text = text
        alert.zPosition = 2
        alert.fontColor = SKColor.yellowColor()
        alert.name = Constants.alertSpriteName
        self.addChild(alert)
    }

    func removeAlert() {
        let alert = self.childNodeWithName(Constants.alertSpriteName)
        alert?.removeFromParent()
    }

    private func createAtlas() -> SKTextureAtlas {
        let chipImages = ChipImages()
        let dictionary = [
            Constants.ChipImages.whiteChip: chipImages.whiteChipWithLight,
            Constants.ChipImages.blackChip: chipImages.blackChipWithLight,
            Constants.cellImage: chipImages.cellImage ]
        return SKTextureAtlas(dictionary: dictionary)
    }

    func updateCountsLabel(white: Int, black: Int) {
        let label = childNodeWithName(Constants.countsLabelSpriteName)
            as! SKLabelNode
        label.text = "White: \(white)  Black: \(black)"
    }

    private func createAIIndicator() -> SKSpriteNode {
        let gear = SKSpriteNode(imageNamed: Constants.gearImage)
        let size = self.size.width/10
        gear.size = CGSize(width: size, height: size)
        return gear
    }

    func showAIIndicator(yes: Bool) {
        if yes {
            let y = self.frame.maxY-(gearSprite.size.height/2)-1
            gearSprite.position = CGPoint(x: self.frame.midX, y: y)
            gearSprite.zPosition = 2
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1.5)
            gearSprite.runAction(SKAction.repeatActionForever(action))
            self.addChild(gearSprite)
        } else {
                gearSprite.removeFromParent()
            }
    }
    
    private func displayEmptyBoard() {
        // Board parameters
        let size = self.size.width
        let boxSideLength = (size)/8
        let squareSize = CGSizeMake(boxSideLength, boxSideLength)
        // draw board
        let yOffset: CGFloat = (boxSideLength/2)
        for row in 0..<8 {
            let xOffset: CGFloat = (boxSideLength/2)
            for col in 0..<8 {
                let square = SKSpriteNode(
                    texture: atlas.textureNamed(Constants.cellImage),
                    size: squareSize)
                square.position = CGPointMake(CGFloat(col) * squareSize.width +
                    xOffset, CGFloat(row) * squareSize.height + yOffset)
                // Set sprite's name in row-col format(e.g., "07", "25")
                square.name = "\(row)\(col)"
                self.addChild(square)
            }
        }
        drawCountsLabel()
    }

    func clearGameView() {
        for row in 0..<8 {
            for col in 0..<8 {
                let cell = childNodeWithName("\(row)\(col)") as! SKSpriteNode
                if cell.children.isEmpty {
                    continue
                }
                cell.removeAllChildren()
            }
        }
    }

    private func drawCountsLabel() {
        let topSquare = self.childNodeWithName("74") as! SKSpriteNode
        let fontSize = topSquare.frame.height * 0.8
        let y = topSquare.frame.maxY + (fontSize/2) - 1
        let countsLabel = SKLabelNode(fontNamed: Constants.Fonts.countsFont)
        countsLabel.text = "White: 0  Black: 0"
        countsLabel.fontSize = fontSize
        countsLabel.position = CGPointMake(self.frame.midX, y)
        countsLabel.fontColor = SKColor.yellowColor()
        countsLabel.name = Constants.countsLabelSpriteName
        countsLabel.zPosition = 1
        self.addChild(countsLabel)
    }
}
