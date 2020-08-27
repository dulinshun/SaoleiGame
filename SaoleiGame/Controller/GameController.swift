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
    
    private let countView = NumberView()
    
    private let faceView = UIButton()
    
    private let timerView = NumberView()
    
    private var items: [[GameItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = level.title
        view.backgroundColor = .white
        
        countView.frame = CGRect(x: 20, y: 100, width: 13*3, height: 23)
        view.addSubview(countView)
        
        timerView.frame = CGRect(x: view.bounds.width - 20 - 13*3 , y: 100, width: 13*3, height: 23)
        view.addSubview(timerView)
        
        
        faceView.center = CGPoint(x: view.bounds.width/2, y: timerView.center.y)
        faceView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        faceView.setImage(UIImage(named: "smile_normal"), for: .normal)
        faceView.addTarget(self, action: #selector(reset), for: .touchUpInside)
        view.addSubview(faceView)
        
        reset()
    }
}

private extension GameController {
    
    /// 平铺按钮
    func placeItems() {
        items.forEach{ $0.forEach{ $0.removeFromSuperview() } }
        items.removeAll()
        let itemSpace: CGFloat = 1
        let itemWidth = (view.bounds.width - itemSpace * CGFloat(level.columnCount - 1)) / CGFloat(level.columnCount)
        for i in 0 ..< level.columnCount {
            var subItems: [GameItem] = []
            for j in 0 ..< level.columnCount {
                let item = GameItem()
                item.x = i
                item.y = j
                item.number = 0
                item.addTarget(self, action: #selector(selectItem(item:)), for: .touchUpInside)
                subItems.append(item)
                view.addSubview(item)
                
                let originX = (itemWidth + itemSpace) * CGFloat(j)
                let originY = faceView.frame.maxY + 20 + (itemWidth + itemSpace) * CGFloat(i)
                item.frame = CGRect(x: originX, y: originY, width: itemWidth, height: itemWidth)
            }
            items.append(subItems)
        }
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
    
    /// 统计周围雷数量
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
    
    /// 一组 item 中雷的数量
    func landmineCount(items: [GameItem]) -> Int {
        return items.filter{ $0.number == 9 }.count
    }
    
    /// 邻近的雷数量
    func neighborLandmineCount(x: Int, y: Int) -> Int {
        let items = neighborItems(x: x, y: y)
        return landmineCount(items: items)
    }
    
    /// 打开所有的 item
    func openAllItems() {
        items.forEach{ $0.forEach{ $0.isSelected = true } }
    }
}

extension GameController {
    
    @objc private func selectItem(item: GameItem) {
       if item.isSelected { return }
       if item.itemState != .normal { return }
       item.isSelected = true
       
       /// 游戏失败
       if item.number == 9 {
            item.isFailureItem = true
            openAllItems()
            gameFailure()
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
    
    /// 重置
    @objc func reset() {
        placeItems()
        randomLandmine()
        statisticsNeighborLandmine()
    }
    
    /// 游戏失败
    func gameFailure() {
        print("踩雷了")
    }
    
    /// 游戏成功
    func gameSuccessfull() {
        print("游戏胜利")
    }
}
