//
//  Player.swift
//  Try6
//
//  Created by Владислав Эдуардович Дембский on 04.02.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    private let id: Int

    // required by the GKGameModelPlayer protocol
    var playerId: Int {return id}

    let color: CellType
/*
    static let gamePlayers = [Player(playerColor: .White),Player(playerColor: .Black)]
*/
    var opponent : Player {
        if self.color == .White {return gamePlayers[1]}
        else {return gamePlayers[0]}
    }

    // used to save number of moves counted by gameModelUpdatesForPlayer
    private var mobility: Int = 0
    var numberOfMoves: Int {
        get {return mobility}
        set {mobility = newValue}
    }

    init(playerColor: CellType) {
        self.color = playerColor
        self.id = playerColor.rawValue
        super.init()
    }
}
