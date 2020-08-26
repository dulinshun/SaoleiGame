//
//  GameLevel.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

enum GameLevel: Int {
    case low = 1
    case medium = 2
    case higher = 3
}

extension GameLevel {
    
    var title: String {
        switch self {
        case .low:
            return "低级"
        case .medium:
            return "中级"
        case .higher:
            return "高级"
        }
    }
    
    var landmineCount: Int {
        switch self {
        case .low:
            return 10
        case .medium:
            return 40
        case .higher:
            return 99
        }
    }
    
    var columnCount: Int {
        switch self {
        case .low:
            return 10
        case .medium:
            return 16
        case .higher:
            return 20
        }
    }
}
