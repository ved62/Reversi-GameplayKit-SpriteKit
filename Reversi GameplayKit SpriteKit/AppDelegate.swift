//
//  AppDelegate.swift
//  Reversi OS X
//
//  Created by Владислав Эдуардович Дембский on 06.02.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var gameView: SKView!

    private var gameScene: GameLogicUI!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        gameScene = GameLogicUI(size: gameView.frame.size)
        gameView.presentScene(gameScene)
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication)
        -> Bool
    {
        return true
    }

}

