//
//  UIBarButtonItem.swift
//  swift-DY
//
//  Created by chenrin on 2016/10/26.
//  Copyright © 2016年 zhuoheng. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
//    class func createItem(imageName:String,highImageName:String,size:CGSize) -> UIBarButtonItem {
//        let btn = UIButton()
//        
//        btn.setImage(UIImage(named:imageName), for: .normal)
//        btn.setImage(UIImage(named:highImageName), for: .highlighted)
//        btn.frame = CGRect(origin: CGPoint.zero, size: size)
//       // btn.sizeToFit()
//        return UIBarButtonItem(customView: btn)
//    }
    
    //便利构造函数 -> convenience开头 -> 必须调用设计构造函数
   convenience init(imageName:String = "",highImageName:String = "",size:CGSize = CGSize.zero) {
    let btn = UIButton()
    
    btn.setImage(UIImage(named:imageName), for: .normal)
    btn.setImage(UIImage(named:highImageName), for: .highlighted)
    if size == CGSize.zero {
         // btn.sizeToFit()
    }else{
    btn.frame = CGRect(origin: CGPoint.zero, size: size)
           // btn.sizeToFit()
    }
    self.init(customView:btn)
    
    }
}



