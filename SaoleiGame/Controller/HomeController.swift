//
//  HomeController.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "选择难度"
        
        let levels: [GameLevel] = [.low, .medium, .higher]
        for i in 0 ..< levels.count {
            let level = levels[i]
            let title = level.title
            let width: CGFloat = view.bounds.width - 120
            let height: CGFloat = 40
            let originX: CGFloat = 60
            let originY: CGFloat = 150 + (height + 30) * CGFloat(i)
            
            let button = UIButton()
            button.tag = level.rawValue
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 5
            button.setTitle(title, for: .normal)
            button.frame = CGRect(x: originX, y: originY , width: width, height: height)
            button.addTarget(self, action: #selector(selectedLevel(button:)), for: .touchUpInside)
            view.addSubview(button)
        }
    }
    
    @objc private func selectedLevel(button: UIButton) {
        let controller = GameController()
        controller.level = GameLevel(rawValue: button.tag)!
        navigationController?.pushViewController(controller, animated: true)
    }
}
