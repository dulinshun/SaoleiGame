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
    
    private var items: [[GameItem]] = []
    
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
        let itemWidth = (bounds.width - itemSpace * CGFloat(level.columnCount - 1)) / CGFloat(level.columnCount)
        for i in 0 ..< level.columnCount {
            for j in 0 ..< level.columnCount {
                let item = items[i][j]
                let originX = (itemWidth + itemSpace) * CGFloat(j)
                let originY = faceView.frame.maxY + 20 + (itemWidth + itemSpace) * CGFloat(i)
                item.frame = CGRect(x: originX, y: originY, width: itemWidth, height: itemWidth)
            }
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
            break
        }
    }
    
    // 重新设置 item
    func resetItems() {
        items.forEach{ $0.forEach{ $0.removeFromSuperview() } }
        items.removeAll()
        for i in 0 ..< level.columnCount {
            var subItems: [GameItem] = []
            for j in 0 ..< level.columnCount {
                let item = GameItem()
                item.x = i
                item.y = j
                item.number = 0
                item.addTarget(self, action: #selector(selectItem(item:)), for: .touchUpInside)
                subItems.append(item)
                addSubview(item)
            }
            items.append(subItems)
        }
        setNeedsLayout()
    }
    
    /// 随机地雷
    func randomLandmine() {
        var currentLandmineCount = 0
        while currentLandmineCount <= level.landmineCount {
            let ri = Int(arc4random()%UInt32(level.columnCount))
            let rj = Int(arc4random()%UInt32(level.columnCount))
            let item = items[ri][rj]
            if item.number != 9 {
                item.number = 9
                currentLandmineCount += 1
            }
        }
    }
    
    /// 统计邻近雷数量
    func statisticsNeighborLandmine() {
        for i in 0 ..< level.columnCount {
            for j in 0 ..< level.columnCount {
                let item = items[i][j]
                if item.number == 9 { continue }
                let count = neighborLandmineCount(x: i, y: j)
                item.number = count
            }
        }
    }
    
    /// 邻近的 item
    func neighborItems(x: Int, y: Int) -> [GameItem] {
        var subItems: [GameItem] = []
        let mx = x - 1
        let my = y - 1
        for i in mx ..< mx + 3 {
            for j in my ..< my + 3 {
                if i < 0 || i >= level.columnCount { continue }
                if j < 0 || j >= level.columnCount { continue }
                if i == x && j == y { continue }
                subItems.append(items[i][j])
            }
        }
        return subItems
    }
    
    func landmineCount(items: [GameItem]) -> Int {
        return items.filter{ $0.number == 9 }.count
    }
    
    /// 邻近的雷数量
    func neighborLandmineCount(x: Int, y: Int) -> Int {
        let items = neighborItems(x: x, y: y)
        return landmineCount(items: items)
    }
    
    // 选择 item
    @objc private func selectItem(item: GameItem) {
        if item.isSelected { return }
        if item.itemState != .normal { return }
        item.isSelected = true
        
        if item.number == 9 {
            print("踩雷了")
            return
        }
        
        /// 如果周围没有雷则帮忙开了
        let subItems = neighborItems(x: item.x, y: item.y)
        let count = landmineCount(items: subItems)
        if count == 0 {
            for subItem in subItems {
                selectItem(item: subItem)
            }
        }
    }
}

extension GameView {
    
    func reset() {
        resetItems()
        randomLandmine()
        statisticsNeighborLandmine()
    }
}
