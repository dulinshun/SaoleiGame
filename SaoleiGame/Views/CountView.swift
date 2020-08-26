//
//  NumberView.swift
//  SaoleiGame
//
//  Created by top on 2020/8/26.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class NumberView: UIView {

    private let imageView1 = UIImageView()
    private let imageView2 = UIImageView()
    private let imageView3 = UIImageView()
    
    public var number: Int = 0 { didSet{ numberDidChanged() } }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView1)
        addSubview(imageView2)
        addSubview(imageView3)
        numberDidChanged()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView1.frame = CGRect(x: bounds.width/3*0, y: 0, width: bounds.width/3, height: bounds.height)
        imageView2.frame = CGRect(x: bounds.width/3*1, y: 0, width: bounds.width/3, height: bounds.height)
        imageView3.frame = CGRect(x: bounds.width/3*2, y: 0, width: bounds.width/3, height: bounds.height)
    }
    
    private func numberDidChanged() {
        let images = [imageView1, imageView2, imageView3]
        var string = String(format: "%03d", number)
        string = (string as NSString).substring(from: string.count - 3)
        for (i, c) in string.enumerated() {
            images[i].image = UIImage(named: "classic_numbers_\(c)")
        }
    }
}
