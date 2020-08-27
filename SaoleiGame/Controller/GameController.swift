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
    
    private let lblCount = UILabel()
    
    private let countView = NumberView() // 剩余雷数量
    
    private let faceView = UIButton() // 笑脸
    
    private let lblTime = UILabel()
    
    private let timerView = NumberView() // 时间
    
    private var items: [[GameItem]] = [] // 所有的 item
    
    private var btnFlag = UIButton() // 旗帜标记按钮
    
    private var btnDoubt = UIButton() // 疑问标记按钮
    
    private var btnNormal = UIButton() // 取消标记按钮
    
    private var lblCurrentState = UILabel() // 当前操作
    
    private var imageCurrentState = UIImageView() // 当前操作
    
    private var itemOperateState = ItemState.normal // 操作类型
    
    private var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = level.title
        view.backgroundColor = .white
        
        lblCount.text = "剩余"
        lblCount.frame = CGRect(x: 0, y: 100, width: 60, height: 23)
        lblCount.textAlignment = .center
        view.addSubview(lblCount)
        
        countView.frame = CGRect(x: 60, y: 100, width: 13*3, height: 23)
        view.addSubview(countView)
        
        timerView.frame = CGRect(x: view.bounds.width - 20 - 13*3 , y: 100, width: 13*3, height: 23)
        view.addSubview(timerView)
        
        lblTime.text = "时间"
        lblTime.frame = CGRect(x: timerView.frame.minX-60, y: timerView.frame.minY, width: 60, height: 23)
        lblTime.textAlignment = .center
        view.addSubview(lblTime)
        
        faceView.center = CGPoint(x: view.bounds.width/2, y: timerView.center.y)
        faceView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        faceView.addTarget(self, action: #selector(reset), for: .touchUpInside)
        view.addSubview(faceView)
        
        btnNormal.tag = ItemState.normal.rawValue
        btnNormal.setImage(UIImage(named: "mark_normal"), for: .normal)
        btnNormal.frame = CGRect(x: 20, y: faceView.frame.maxY + view.bounds.width + 40, width: 60, height: 60)
        btnNormal.addTarget(self, action: #selector(selectState(button:)), for: .touchUpInside)
        view.addSubview(btnNormal)
        
        btnFlag.tag = ItemState.flag.rawValue
        btnFlag.setImage(UIImage(named: "mark_flag"), for: .normal)
        btnFlag.frame = CGRect(x: btnNormal.frame.maxX + 20, y: btnNormal.frame.minY, width: btnNormal.frame.size.width, height: btnNormal.frame.size.height)
        btnFlag.addTarget(self, action: #selector(selectState(button:)), for: .touchUpInside)
        view.addSubview(btnFlag)
        
        btnDoubt.tag = ItemState.doubt.rawValue
        btnDoubt.setImage(UIImage(named: "mark_doubt"), for: .normal)
        btnDoubt.frame = CGRect(x: btnFlag.frame.maxX + 20, y: btnFlag.frame.minY, width: btnFlag.frame.size.width, height: btnFlag.frame.size.height)
        btnDoubt.addTarget(self, action: #selector(selectState(button:)), for: .touchUpInside)
        view.addSubview(btnDoubt)
        
        lblCurrentState.text = "当前操作"
        lblCurrentState.textAlignment = .center
        lblCurrentState.frame = CGRect(x: view.bounds.width - 100, y: btnDoubt.frame.minY, width: 100, height: 20)
        view.addSubview(lblCurrentState)
        
        imageCurrentState.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageCurrentState.center = CGPoint(x: lblCurrentState.center.x, y: lblCurrentState.center.y + 30)
        view.addSubview(imageCurrentState)
        
        reset()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
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
        while currentLandmineCount < level.landmineCount {
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
            
    /// 打开 item
    /// - Parameters:
    ///   - item: 打开的 item
    ///   - isClick: 是否是点击打开
    func open(item: GameItem, isClick: Bool) {
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
        
        /// 游戏成功
        if checkSuccess() {
            openAllItems()
            gameSuccessfull()
            return
        }
        
        /// 帮忙打开空白
        let subItems = neighborItems(x: item.x, y: item.y)
        let count = landmineCount(items: subItems)
        if count == 0 {
            for subItem in subItems {
                open(item: subItem, isClick: false)
            }
        }
    }
    
    /// 所有旗帜的 item
    func markFlagItems() -> [GameItem] {
        var subItems: [GameItem] = []
        for i in 0 ..< level.columnCount {
            for j in 0 ..< level.columnCount {
                let item = items[i][j]
                if item.itemState == .flag {
                    subItems.append(item)
                }
            }
        }
        return subItems
    }
    
    /// 所有未点开的 item
    func unopenItems() -> [GameItem] {
        var subItems: [GameItem] = []
        for i in 0 ..< level.columnCount {
            for j in 0 ..< level.columnCount {
                let item = items[i][j]
                if !item.isSelected {
                    subItems.append(item)
                }
            }
        }
        return subItems
    }
    
    /// 判定游戏是否成功
    func checkSuccess() -> Bool {
        let uItems = unopenItems()
        if uItems.count == level.landmineCount {
            return true
        }
        
        let mItems = markFlagItems()
        if mItems.count == level.landmineCount {
            for item in mItems where item.number != 9 {
                return false
            }
            return true
        }
        return false
    }
}

private extension GameController {
    
    func startTimer() {
        if timer != nil { return }
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1)
        timer?.setEventHandler(handler: { [weak self] in
            self?.timerView.number += 1
        })
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

extension GameController {
    
    @objc private func selectItem(item: GameItem) {
        if item.isSelected { return }
        self.startTimer()
        if itemOperateState == .normal {
            open(item: item, isClick: true)
            return
        }
        if item.itemState == itemOperateState {
            item.itemState = .normal
        } else {
            item.itemState = itemOperateState
        }
        
        countView.number = max(0, (level.landmineCount - markFlagItems().count))
        
        if checkSuccess() {
            openAllItems()
            gameSuccessfull()
        }
    }
    
    @objc private func selectState(button: UIButton) {
        self.itemOperateState = ItemState(rawValue: button.tag)!
        imageCurrentState.image = button.imageView?.image
    }
    
    /// 重置
    @objc func reset() {
        imageCurrentState.image = btnNormal.imageView?.image
        itemOperateState = .normal
        countView.number = level.landmineCount
        timerView.number = 0
        faceView.setImage(UIImage(named: "smile_normal"), for: .normal)
        placeItems()
        randomLandmine()
        statisticsNeighborLandmine()
    }
    
    /// 游戏失败
    func gameFailure() {
        stopTimer()
        faceView.setImage(UIImage(named: "smile_fail"), for: .normal)
        let alertController = UIAlertController(title: "您踩雷了", message: "是否重新开始", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "是", style: .default, handler: { [weak self] (_) in
            self?.reset()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    /// 游戏成功
    func gameSuccessfull() {
        stopTimer()
        faceView.setImage(UIImage(named: "smile_win"), for: .normal)
        let alertController = UIAlertController(title: "游戏胜利", message: "是否重新开始", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "是", style: .default, handler: { [weak self] (_) in
            self?.reset()
        }))
        present(alertController, animated: true, completion: nil)
    }
}
