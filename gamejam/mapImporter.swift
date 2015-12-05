//
//  mapImporter.swift
//  gamejam
//
//  Created by drakeDan on 7/11/15.
//  Copyright (c) 2015 bravo. All rights reserved.
//

import UIKit
import SpriteKit

class mapImporter {
    var row: Int
    var col: Int
    
    var cells: Array2D<Cell>?
    var beginCol: Int
    var beginRow: Int
    
    var endCol: Int
    var endRow: Int
    
    var blockLeft = [String: Bool]()
    var blockUp = [String: Bool]()
    
    let cellSize = 40
    
    init() {
        beginCol = 0
        beginRow = 0
        endCol = 0
        endRow = 0
        row = 0
        col = 0
    }
    
    func read(fileName:String) {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
        var text: String?
        do {
            text = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        var a = text!.characters.split{$0 == "\n"}.map(String.init)
        
        row = Int(a[0])!
        col = Int(a[1])!
        let backSlashTexture = SKTexture(imageNamed: "backSlash")
        let slashTexture = SKTexture(imageNamed: "slash")
        
        cells = Array2D<Cell>(columns: col, rows: row)
        
        for (var i = 0; i < row; i++) {
            for (var j = 0; j < col; j++) {
                cells![j, i] = Cell(column: j, row: i, id: 0)
                cells![j, i]!.sprite = SKSpriteNode(color: SKColor.grayColor(), size: CGSize(width: cellSize, height: cellSize))
            }
        }
        
        // read mirror setting
        for (var i = 2; i < 2 + row; i++) {
            let r = a[i]
            var id = 0
            for c in r.characters {
                if c == "s" {
                    beginRow = i - 2
                    beginCol = id
                    cells![id, i - 2]!.sprite = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: cellSize, height: cellSize))
                }
                else if c == "e" {
                    endRow = i - 2
                    endCol = id
                    cells![id, i - 2]!.isFinish = true
                    cells![id, i - 2]!.sprite = SKSpriteNode(color:SKColor.blueColor(), size:CGSize(width: cellSize, height: cellSize))
                }
                else if c == "\\" {
                    cells![id, i - 2]!.mirror = MirrorType.backSlash
                    let sprite = SKSpriteNode(texture: backSlashTexture, size: CGSize(width: cellSize, height: cellSize))
                    cells![id, i - 2]!.sprite?.addChild(sprite)
                }
                else if c == "/" {
                    cells![id, i - 2]!.mirror = MirrorType.slash
                    let sprite = SKSpriteNode(texture: slashTexture, size: CGSize(width: cellSize, height: cellSize))
                    cells![id, i - 2]!.sprite?.addChild(sprite)
                }
                
                id++
            }
            print(a)
        }
        
        // left block
        for (var i = 2 + row; i < 2 + row + row; i++){
            let r = a[i]
            var id = 0
            for c in r.characters {
                if (c == "1") {
                    let hash = "\(i - 2 - row) \(id)"
                    blockLeft[hash] = true
                }
                id++
            }
        }
        
        // up block
        for (var i = 2 + row + row; i < 2 + row + row + row; i++){
            let r = a[i]
            var id = 0
            for c in r.characters {
                if (c == "1") {
                    let hash = "\(i - 2 - row - row) \(id)"
                    blockUp[hash] = true
                }
                id++
            }
        }
        
   
    }
}
