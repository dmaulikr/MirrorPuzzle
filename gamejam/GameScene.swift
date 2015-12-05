//
//  GameScene.swift
//  gamejam
//
//  Created by drakeDan on 7/10/15.
//  Copyright (c) 2015 bravo. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    
    let gameLayer = SKNode()
    let startPoint = CGPoint(x: 150, y: -100)
    let startx = 200
    let starty = -100
    let cellSpacing = 5
    let cellSize = 40
    var rowNumber = 3
    var colNumber = 3
    
    
    var lightRow = 0
    var lightCol = 0
    var lightDirect = LightDirection.right
    
    var light: SKShapeNode?
    
    var blockLeft = [String: Bool]()
    var blockUp = [String: Bool]()
    var blockSprites = [SKSpriteNode]()
    var buttons = [SKButton]()
    
    var cells: Array2D<Cell> = Array2D<Cell>(columns: 3, rows: 3)
    
    
    var level = 1
    
    var label: SKButton?
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0, y: 1)
        addChild(gameLayer)
        
//        var importer = mapImporter()
//        importer.read("level1")
//        
//        rowNumber = importer.row
//        colNumber = importer.col
//        
//        self.cells = importer.cells!
//        lightRow = importer.beginRow
//        lightCol = importer.beginCol
//        blockLeft = importer.blockLeft
//        blockUp = importer.blockUp
//        for (var i = 0; i < rowNumber; i++) {
//            for (var j = 0; j < colNumber; j++) {
//                cells[j, i]!.sprite!.position = CGPoint(x: startx + j * (cellSize + cellSpacing),
//                                          y: starty - i * (cellSize + cellSpacing))
//            }
//        }
//        
//        addButtons()
//        
//        redrawCells()
//        
//        var arr = updateLight(lightCol, row: lightRow)
//        redrawLights(arr)
//        
//        redrawBlocks()

        loadLevel("level1")
        
        var t = SKTexture(imageNamed: "cell")
        label = SKButton(normalTexture: t, selectedTexture: t, disabledTexture: t)
        label?.setButtonLabel(title: "level: \(level)", font: "Arial", fontSize: 25)
        label?.position = positionForColumn(10, row: 0)
        gameLayer.addChild(label!)
    }
    
    func loadLevel(fileName:String) {
//        gameLayer.removeAllChildren()
        clearCells()
        var importer = mapImporter()
        importer.read(fileName)
        
        rowNumber = importer.row
        colNumber = importer.col
        
        self.cells = importer.cells!
        lightRow = importer.beginRow
        lightCol = importer.beginCol
        blockLeft = importer.blockLeft
        blockUp = importer.blockUp
        for (var i = 0; i < rowNumber; i++) {
            for (var j = 0; j < colNumber; j++) {
                cells[j, i]!.sprite!.position = CGPoint(x: startx + j * (cellSize + cellSpacing),
                    y: starty - i * (cellSize + cellSpacing))
            }
        }
        
        redrawCells()
//        light?.removeFromParent()
        var arr = updateLight(lightCol, row: lightRow)
        redrawLights(arr)
        
        redrawBlocks()
        addButtons()
    }
    
    func nextLevel() {
        NSLog("finish")
        if (level + 1 > 5) {
            level = 0
        }
        if (level + 1 == 4){
            label?.setButtonLabel(title: "Thank U :)", font: "Arial", fontSize: 25)
        }
        else {
            label?.setButtonLabel(title: "level: \(level + 1)", font: "Arial", fontSize: 25)
        }
        loadLevel("level\(++level)")
    }
    
    func redrawBlocks() {
        for s in blockSprites {
            s.removeFromParent()
        }
        
        for (hash, _) in blockLeft {
            
            var ar = hash.characters.split{$0 == " "}.map(String.init)
            let row = Int(ar[0])
            let col = Int(ar[1])
            let pos = positionForColumn(col!, row: row!)
            let newPos = CGPoint(x: pos.x - CGFloat(cellSize) / 2 - 5, y: pos.y)
            let blockSprite = SKSpriteNode(imageNamed: "block")
            blockSprite.position = newPos
            blockSprite.size = CGSize(width: cellSize, height: cellSize)
            blockSprites.append(blockSprite)
            gameLayer.addChild(blockSprite)
        }
        
        for (hash, _) in blockUp {
            var ar = hash.characters.split{$0 == " "}.map(String.init)
            let row = Int(ar[0])
            let col = Int(ar[1])
            let pos = positionForColumn(col!, row: row!)
            let newPos = CGPoint(x: pos.x, y: pos.y + CGFloat(cellSize) / 2)
            let blockSprite = SKSpriteNode(imageNamed: "block")
            blockSprite.zRotation = CGFloat(M_PI_2)
            blockSprite.position = newPos
            blockSprite.size = CGSize(width: cellSize, height: cellSize)
            blockSprites.append(blockSprite)
            gameLayer.addChild(blockSprite)
        }
    }
    
    func addButtons() {
        let buttonTexture = SKTexture(image: UIImage(named: "button")!)
        let buttonPressedTexture = SKTexture(image:UIImage(named: "button-pressed")!)
        
        for b in buttons {
            b.removeFromParent()
        }
        ///////////right//////////
        for var i = 0; i < rowNumber; i++ {
            let buttonTexture = SKTexture(image: UIImage(named: "button")!)
            let buttonPressedTexture = SKTexture(image:UIImage(named: "button-pressed")!)
            let right1 = SKButton(normalTexture: buttonTexture, selectedTexture: buttonPressedTexture, disabledTexture: buttonPressedTexture)
            right1.tag = i + 1
            right1.size = CGSize(width: 20, height: 20)
            right1.setButtonLabel(title: ">", font: "Helvetica", fontSize: 20)
            right1.position = positionForColumn(colNumber, row: i)
            right1.setButtonAction(self, triggerEvent: SKButton.FTButtonActionType.TouchDown, action: "slidRow:")
            gameLayer.addChild(right1)
            buttons.append(right1)
        }
        
        
        ///////// left /////////
        for var i = 0; i < rowNumber; i++ {
            let left1 = SKButton(normalTexture: buttonTexture, selectedTexture: buttonPressedTexture, disabledTexture: buttonPressedTexture)
            left1.tag = -i - 1
            left1.size = CGSize(width: 20, height: 20)
            left1.setButtonLabel(title: "<", font: "Helvetica", fontSize: 20)
            left1.position = positionForColumn(-1, row: i)
            left1.setButtonAction(self, triggerEvent: SKButton.FTButtonActionType.TouchDown, action: "slidRow:")
            gameLayer.addChild(left1)
            buttons.append(left1)
        }
        
        
        //////// top ////////
        for var i = 0; i < colNumber; i++ {
            let top1 = SKButton(normalTexture: buttonTexture, selectedTexture: buttonPressedTexture, disabledTexture: buttonPressedTexture)
            top1.size = CGSize(width: 20, height: 20)
            top1.tag = i + 1
            top1.setButtonLabel(title: "^", font: "Helvetica", fontSize: 20)
            top1.position = positionForColumn(i, row: -1)
            top1.setButtonAction(self, triggerEvent: SKButton.FTButtonActionType.TouchDown, action: "slidCol:")
            gameLayer.addChild(top1)
            buttons.append(top1)
        }
        
        /////// bottom /////////
        for var i = 0; i < colNumber; i++ {
            let bottom1 = SKButton(normalTexture: buttonTexture, selectedTexture: buttonPressedTexture, disabledTexture: buttonPressedTexture)
            bottom1.tag = -i - 1
            bottom1.size = CGSize(width: 20, height: 20)
            bottom1.setButtonLabel(title: "v", font: "Helvetica", fontSize: 20)
            bottom1.position = positionForColumn(i, row: rowNumber)
            bottom1.setButtonAction(self, triggerEvent: SKButton.FTButtonActionType.TouchDown, action: "slidCol:")
            gameLayer.addChild(bottom1)
            buttons.append(bottom1)
        }
    }
    
    func clearCells() {
        for (var i = 0; i < rowNumber; i++) {
            for (var j = 0; j < colNumber; j++) {
                if let cell = cells[j, i] {
                    cell.sprite!.removeFromParent()
                }
            }
        }
    }
    
    func redrawCells() {
        for (var i = 0; i < rowNumber; i++) {
            for (var j = 0; j < colNumber; j++) {
                gameLayer.addChild(cells[j, i]!.sprite!)
                if (cells[j, i]!.mirror == MirrorType.slash) {
                    let slashSprite = SKSpriteNode(imageNamed: "slash")
                    slashSprite.size = CGSize(width: cellSize, height: cellSize)
                    cells[j, i]!.sprite?.addChild(slashSprite)
                }
                else if (cells[j, i]!.mirror == MirrorType.backSlash) {
                    let backSlashSprite = SKSpriteNode(imageNamed: "backSlash")
                    backSlashSprite.size = CGSize(width:cellSize, height:cellSize)
                    cells[j, i]!.sprite?.addChild(backSlashSprite)
                }
            }
        }
    }
    
    func validRow(row:Int, col:Int) -> Bool{
        return row >= 0 && row < rowNumber && col >= 0 && col < colNumber
    }
    
    
    func redrawLights(l: Array<(Int, Int)>) {
        light?.removeFromParent()
        let path = CGPathCreateMutable()
        let p = positionForColumn(l[0].0, row:l[0].1)
        CGPathMoveToPoint(path, nil, p.x, p.y)
        
        for (var i = 1; i < l.count; i++) {
            let pp = positionForColumn(l[i].0, row: l[i].1)
            if validRow(l[i].1, col:l[i].0) &&  i == l.count - 1 {
                var offsetX = lightDirect == LightDirection.right ? -(cellSize / 2) : (cellSize / 2)
                var offsetY = lightDirect == LightDirection.up ? -(cellSize / 2) : (cellSize / 2)
                offsetX = lightDirect == LightDirection.right || lightDirect == LightDirection.left ? offsetX : 0
                offsetY = lightDirect == LightDirection.up || lightDirect == LightDirection.down ? offsetY : 0
                CGPathAddLineToPoint(path, nil, pp.x + CGFloat(offsetX), pp.y + CGFloat(offsetY))
            } else {
                CGPathAddLineToPoint(path, nil, pp.x, pp.y)
            }
        }
        
        light = SKShapeNode(path: path)
        light!.strokeColor = SKColor.whiteColor()
        light!.lineWidth = 2
        gameLayer.addChild(light!)
    }
    
    func slidCol(sender: SKButton) {
        var col = sender.tag!
        var up = col > 0
        
        col = abs(col) - 1
        
        for (key, val) in blockUp {
            var ar = key.characters.split{$0 == " "}.map(String.init)
            var c = Int(ar[1])
            if (c == col) {
                return
            }
        }
        
        
        var newRow = 0
        
        if (up) {
            var puppy = cells[col, 0]
            puppy?.row = rowNumber - 1
            
            for (var i = 1; i < rowNumber; i++) {
                var cell = cells[col, i]
                newRow = (i + rowNumber - 1) % rowNumber
                cells[col, newRow] = cell
                cell!.row = newRow
            }
            cells[col, rowNumber - 1] = puppy
        }
        else {
            var puppy = cells[col, rowNumber - 1]
            puppy?.row = 0
            
            for (var i = rowNumber - 2; i >= 0; i--) {
                var cell = cells[col, i]
                newRow = (i + 1) % rowNumber
                cells[col, newRow] = cell
                cell!.row = newRow
            }
            
            cells[col, 0] = puppy
        }
        
        for (var i = 0; i < rowNumber; i++) {
            updateSprite(cells[col,i])
        }
        
        if (col == lightCol) {
            var offset = up ? rowNumber - 1 : 1
            lightRow = (lightRow + offset) % rowNumber
            var arr = updateLight(col, row:lightRow)
            redrawLights(arr)
        } else {
            var arr = updateLight(lightCol, row:lightRow)
            redrawLights(arr)
        }
    }
    
    func slidRow(sender:SKButton) {
        var row = sender.tag!
        var right = row > 0
        if (row > 0) {
            row = row - 1
        }
        else{
            row = -row - 1
        }
        
        for (key, _) in blockLeft {
            let ar = key.characters.split{$0 == " "}.map(String.init)
            let c = Int(ar[0])
            if (c == row) {
                return
            }
        }
        
        
        if (right) {
            var puppy = cells[colNumber - 1, row]
            puppy?.column = 0
            for (var i = colNumber - 2; i >= 0; i--) {
                var cell = cells[i, row]
                var newCol = (i + 1) % colNumber
                cells[newCol, row] = cell
                cell!.column = newCol
            }
            cells[0, row] = puppy
        }
        else {
            var puppy = cells[0, row]
            puppy?.column = colNumber - 1
            for (var i = 1; i < colNumber; i++) {
                var cell = cells[i, row]
                var newCol = (i + colNumber - 1) % colNumber
                cells[newCol, row] = cell
                cell!.column = newCol
            }
            cells[colNumber - 1, row] = puppy
        }
        
        for (var i = 0; i < colNumber; i++) {
            updateSprite(cells[i,row])
        }
        
        if (row == lightRow) {
            var offset = right ? 1 : colNumber - 1
            lightCol = (lightCol + offset) % colNumber
            var arr = updateLight(lightCol, row: row)
            redrawLights(arr)
        } else {
            var arr = updateLight(lightCol, row: lightRow)
            redrawLights(arr)
        }
        
    }
    
    func hasMirrorAtRow(row:Int, col:Int) -> Bool{
        let cell = cells[col, row]!
        return cell.mirror != MirrorType.none
    }
    
    func redirect(old:LightDirection, mirror: MirrorType) -> LightDirection{
        if (mirror == MirrorType.backSlash) {
            switch old {
            case LightDirection.right:
                    return LightDirection.down
            case LightDirection.left:
                    return LightDirection.up
            case LightDirection.up:
                    return LightDirection.left
            case LightDirection.down:
                    return LightDirection.right
            }
        }
         else
        {
            switch old {
            case LightDirection.right:
                return LightDirection.up
            case LightDirection.left:
                return LightDirection.down
            case LightDirection.up:
                return LightDirection.right
            case LightDirection.down:
                return LightDirection.left
            }
        }
    }
    
    func blockedAtRow(row: Int, col: Int) -> Bool {
        var hash: String
        var v: Bool?
        if (lightRow == row && lightCol == col) {
            return false
        }
        if (lightDirect == LightDirection.right) {
            hash = "\(row) \(col)"
            v =  blockLeft[hash]
        }
        else if (lightDirect == LightDirection.left) {
            hash = "\(row) \(col + 1)"
            v = blockLeft[hash]
        }
        else if (lightDirect == LightDirection.up) {
            hash = "\(row + 1) \(col)"
            v = blockUp[hash]
        }
        else if (lightDirect == LightDirection.down) {
            hash = "\(row) \(col)"
            v =  blockUp[hash]
        }
        
        if (v == nil) {
            return false;
        } else {
            return true
        }
    }
    
    func isFinished(row: Int, col:Int) -> Bool {
        if (cells[col, row]!.isFinish) {
            return true
        }
        return false
    }
    
    func updateLight(var col: Int, var row: Int) -> Array<(Int, Int)> {
        
        var lights = [(Int, Int)]()
        if (row < 0 || row >= rowNumber || col < 0 || col >= colNumber) {
            return lights
        }
        lightDirect = LightDirection.right
        while (col >= 0 && col <= colNumber - 1 && row >= 0 && row <= rowNumber - 1
            && !blockedAtRow(row, col:col) && !isFinished(row, col:col)) {
                lights.append((col, row))
                
                var x = 0
                var y = 0
                
                if (hasMirrorAtRow(row, col:col)) {
                    var mirrorType = cells[col, row]!.mirror
                    lightDirect = redirect(lightDirect, mirror: mirrorType)
                }
                
                switch lightDirect {
                case LightDirection.up:
                        x = 0
                        y = -1
                case LightDirection.right:
                        x = 1
                        y = 0
                case LightDirection.down:
                        x = 0
                        y = 1
                case LightDirection.left:
                        x = -1
                        y = 0
                }
                
                col = col + x;
                row = row + y;
        }

        lights.append((col, row))
        
        if (validRow(row, col: col) && !blockedAtRow(row, col: col) && isFinished(row, col: col)) {
            let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "nextLevel", userInfo: nil, repeats: false)
//            nextLevel(row, col:col)
        }
        
        return lights
    }
    
    func updateSprite(cell: Cell?) {
        if let c = cell {
            var newPos = positionForColumn(c.column, row:c.row)
            c.sprite!.position = newPos
        }
    }
    
    func positionForColumn(col:Int, row:Int) -> CGPoint {
        return CGPoint(x: startx + col * (cellSize + cellSpacing), y: starty - row * (cellSize + cellSpacing))
    }
    
    func randomColor() -> SKColor {
        var i: Int = Int(arc4random_uniform(5))
        switch i {
        case 0:
            return SKColor.redColor()
        case 1:
            return SKColor.blueColor()
        case 2:
            return SKColor.purpleColor()
        case 3:
            return SKColor.greenColor()
        default:
            return SKColor.yellowColor()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
