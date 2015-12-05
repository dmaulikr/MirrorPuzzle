//
//  ViewController.swift
//  gamejam
//
//  Created by drakeDan on 7/10/15.
//  Copyright (c) 2015 bravo. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.userInteractionEnabled = true
        
        scene = GameScene(size: skView.bounds.size)
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

