//
//  GameLogicUI.swift
//  Reversi GameplayKit SpriteKit
//
//  Created by Владислав Эдуардович Дембский on 06.02.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import Cocoa
import SpriteKit

final class GameLogicUI: SKScene {
    private var gameLogic: GameLogic!
    private var atlas: SKTextureAtlas!

    private var gearSprite: SKSpriteNode!

    override func didMoveToView(view: SKView) {
        //create texture atlas for sprites
        atlas = createAtlas()
        gearSprite = createGear()
        displayEmptyBoard()
        gameLogic = GameLogic(scene: self)
        gameLogic.setInitialBoard()
    }

    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        if let node: SKSpriteNode = nodeAtPoint(location) as? SKSpriteNode {
            var row = -1
            var column = -1
            if node.name != nil {
                if let num = Int(node.name!) {
                    row = num / 10
                    column = num % 10
                }
            }
            gameLogic.cellPressed(row,column)
        }
    }

    func displayChip(color: CellType,row: Int,column: Int) {
        let cell = childNodeWithName("\(row)\(column)") as! SKSpriteNode
        let chipSize = NSMakeSize(cell.size.width*0.8, cell.size.height*0.8)
        let texture = color == .White ?
            atlas.textureNamed(Constants.ChipImages.whiteChip) :
            atlas.textureNamed(Constants.ChipImages.blackChip)
        let chip = SKSpriteNode(texture: texture, size: chipSize)
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
        let topSquare = self.childNodeWithName("70") as! SKSpriteNode
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
        let chipImages = ChipImage()
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

    private func createGear() -> SKSpriteNode {
        let gear = SKSpriteNode(imageNamed: "Gear")
        let size = (self.size.width/8)*0.8
        gear.size = CGSize(width: size, height: size)
        return gear
    }

    func showAIIndicator(yes: Bool) {
        if gearSprite != nil {
            if yes {
                let topSquare = self.childNodeWithName("74") as! SKSpriteNode
                let y = topSquare.position.y + topSquare.size.height
                gearSprite.position =
                    CGPoint(x: topSquare.position.x-topSquare.size.width/2,
                        y: y)
                gearSprite.zPosition = 2
                let action = SKAction.rotateByAngle(CGFloat(M_PI),
                    duration:1.5)
                gearSprite.runAction(
                    SKAction.repeatActionForever(action))
                self.addChild(gearSprite)
            }
            else {
                gearSprite.removeFromParent()
            }
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
        let topSquare = self.childNodeWithName("70") as! SKSpriteNode
        let fontSize = topSquare.frame.height * 0.8
        let y = topSquare.frame.maxY + (fontSize/2)
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
