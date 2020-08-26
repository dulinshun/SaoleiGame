//
//  GameState.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

enum GameState {
    case normal
    case win
    case dead
}

extension GameState {
    
    var faceImage: UIImage? {
        switch self {
        case .normal:
            return UIImage(named: "classic_smile")
        case .win:
            return UIImage(named: "classic_smile_win")
        case .dead:
            return UIImage(named: "classic_smile_dead")
        }
    }
    
}
