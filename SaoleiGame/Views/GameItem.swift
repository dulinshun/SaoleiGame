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


enum ItemState: Int {
    case normal = 1 // 普通
    case flag = 2  // 旗帜
    case doubt = 3 // 怀疑
}

extension ItemState {
    
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

class GameItem: UIButton {
    
    /// 对应的位置
    var x: Int = 0
    var y: Int = 0
    
    /// 对应的数字
    /// 0：空白
    /// 1 ~ 8：周围类数量
    /// 9：雷
    var number: Int = 1 {
        didSet {
            updateNumber()
        }
    }
    
    /// 状态
    var itemState = ItemState.normal {
        didSet {
            updateState()
        }
    }
    
    /// 是否为失败的 item
    var isFailureItem = false {
        didSet {
            setImage(UIImage(named: "item_failure"), for: .selected)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateState()
        updateNumber()
    }
}

private extension GameItem {
    
    /// 更新状态
    func updateState() {
        switch itemState {
        case .normal:
            setImage(UIImage(named: "item_normal"), for: .normal)
        case .flag:
            setImage(UIImage(named: "item_flag"), for: .normal)
        case .doubt:
            setImage(UIImage(named: "item_doubt"), for: .normal)
        }
    }
    
    /// 更新数字
    func updateNumber() {
        setImage(UIImage(named: "item_number_\(number)"), for: .selected)
    }
}
