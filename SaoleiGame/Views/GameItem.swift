//
//  GameItem.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

enum GameItemType {
    case landmine // 雷
    case blank  // 空格
    case number // 数字
}

class GameItem: UIButton {
    
    var number: Int = 1 { didSet { numberDidChanged() } }
    
    var type = ItemType.normal { didSet { ItemTypeDidChanged() } }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberDidChanged()
        ItemTypeDidChanged()
        isSelected = true
    }
}

private extension GameItem {
    
    func numberDidChanged() {
        if number > 8 {
            setImage(UIImage(named: "tile_0_b2"), for: .selected)
        } else {
            setImage(UIImage(named: "tile_0_\(number)"), for: .selected)
        }
    }
    
    func ItemTypeDidChanged() {
        setImage(type.image, for: .normal)
    }
}
