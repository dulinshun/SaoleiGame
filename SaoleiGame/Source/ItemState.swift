//
//  ItemType.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

enum ItemType {
    case normal // 普通
    case flag   // 旗帜
    case doubt  // 怀疑
}

extension ItemType {
    
    var image: UIImage? {
        switch self {
        case .normal:
            return UIImage(named: "tile_0_base")
        case .flag:
            return UIImage(named: "tile_0_d")
        case .doubt:
            return UIImage(named: "tile_0_q")
        }
    }
}
