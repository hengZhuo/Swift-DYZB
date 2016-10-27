//
//  UIcolor+Extension.swift
//  swift-DY
//
//  Created by chenrin on 2016/10/26.
//  Copyright © 2016年 zhuoheng. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(r : CGFloat,g : CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}


