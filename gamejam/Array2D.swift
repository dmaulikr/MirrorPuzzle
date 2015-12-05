//
//  Array2D.swift
//  virus
//
//  Created by drakeDan on 4/6/15.
//  Copyright (c) 2015 bravo. All rights reserved.
//

import SpriteKit

class Array2D<T> {
    let columns:Int
    let rows:Int
    var array:Array<T?>
    
    init(columns:Int, rows:Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count:rows*columns, repeatedValue:nil)
    }
    
    func count() -> Int {
        return array.count
    }
    
    subscript(column:Int, row:Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
