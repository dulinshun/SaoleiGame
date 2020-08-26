//
//  GameView.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    private let countView = NumberView()
    
    private let faceView = UIButton()
    
    private let timerView = NumberView()
    
    private var items: [GameItem] = []
    
    private let itemSpace: CGFloat = 1
    
    private var state: GameState = .normal { didSet{ updateState() } }
    
    var level = GameLevel.low { didSet{ resetItems() } }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        addSubview(countView)
        
        addSubview(timerView)
        
        faceView.setImage(UIImage(named: "classic_smile_down"), for: .selected)
        addSubview(faceView)
                
        resetItems()

        updateState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 数量
        let cWidth: CGFloat = 13*3
        let cHeight: CGFloat = 23
        let cx: CGFloat = 20
        let cy: CGFloat = 5
        countView.frame = CGRect(x: cx, y: cy, width: cWidth, height: cHeight)
        
        // 计时器
        let tx: CGFloat = bounds.width - 20 - cWidth
        timerView.frame = CGRect(x: tx , y: cy, width: cWidth, height: cHeight)
        
        // 笑脸
        faceView.center = CGPoint(x: bounds.width/2, y: timerView.center.y)
        faceView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        // items
        let itemCount = level.columnCount
        let itemWidth = (bounds.width - itemSpace * CGFloat(itemCount - 1)) / CGFloat(itemCount)
        for i in 0 ..< items.count {
            let item = items[i]
            let originX = (itemWidth + itemSpace) * CGFloat(i%itemCount)
            let originY = faceView.frame.maxY + 20 + (itemWidth + itemSpace) * CGFloat(i/itemCount)
            item.frame = CGRect(x: originX, y: originY, width: itemWidth, height: itemWidth)
        }
    }
}

private extension GameView {
    
    // 更新状态
    func updateState() {
        faceView.setImage(state.faceImage, for: .normal)
        
        switch state {
            case .normal:
            break
            case .win:
            break
            case .dead:
            items.forEach{ $0.isSelected = true }
            break
        }
    }
    
    // 重新设置 item
    func resetItems() {
        items.forEach{ $0.removeFromSuperview() }
        items.removeAll()
        let itemCount = level.columnCount
        for i in 0 ..< itemCount*itemCount {
            let item = GameItem()
            item.addTarget(self, action: #selector(selectItem(item:)), for: .touchUpInside)
            item.number = i%itemCount
            items.append(item)
            addSubview(item)
        }
        setNeedsLayout()
    }
    
    // 选择 item
    @objc private func selectItem(item: GameItem) {
        if item.type != .normal  { return }
        if item.isSelected { return }
        item.isSelected = true
    }
    
    
    /// 随机地雷
    func randomLandmine() {
        let landmineCount = level.landmineCount
        var currentLandmineCount = 0
        while currentLandmineCount <= landmineCount {
            let randomIndex = Int(arc4random()%UInt32(items.count))
            let item = items[randomIndex]
            if item.number != 9 {
                item.number = 9
                currentLandmineCount += 1
            }
        }
    }
    
    /// 统计雷数量
    func statisticsLandmine() {
            
        
    }
}
