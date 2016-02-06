//
//  Move.swift
//  Try1
//
//  Created by Владислав Эдуардович Дембский on 26.01.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import GameplayKit

final class Move: NSObject, GKGameModelUpdate {
    private var score: Int = 0
    var value: Int { // required by GKGameModelUpdate protocol
        get { return score }
        set { score = newValue }
    }
    // constants to save move position
    let row: Int
    let column: Int

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        super.init()
    }
}
