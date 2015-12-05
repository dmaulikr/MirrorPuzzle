//
//  Cell.swift
//  gamejam
//
//  Created by drakeDan on 7/10/15.
//  Copyright (c) 2015 bravo. All rights reserved.
//

import UIKit
import SpriteKit

enum LightDirection: Int {
    case up = 0, right, down, left
}

enum MirrorType: Int {
    case none = 0, slash, backSlash
}

class Cell: Hashable, CustomStringConvertible {
    var id: Int
    var column: Int
    var row: Int
    
    var size: CGSize
    
    var sprite: SKSpriteNode?
    
    var mirror = MirrorType.none
    
    var isFinish: Bool
    
    var doorsOpen = [false, false, false, false]
    
    
    var hashValue: Int {
        return 0;
    }
    
    var description: String {
        return "\(column) \(row)"
    }
    
    init(column: Int, row:Int, id:Int) {
        self.id = id
        self.column = column
        self.row = row
        self.isFinish = false
        self.size = CGSize(width: 100, height: 100)
    }
}

func ==(lhs:Cell, rhs:Cell) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
