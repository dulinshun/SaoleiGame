//
//  GameController.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    var level = GameLevel.low
    
    let gameView = GameView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = level.title
        view.backgroundColor = .white
        
        gameView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.width + 100)
        gameView.level = level
        view.addSubview(gameView)
    }
}
