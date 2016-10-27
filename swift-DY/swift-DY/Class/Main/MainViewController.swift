//
//  MainViewController.swift
//  swift-DY
//
//  Created by chenrin on 2016/10/25.
//  Copyright © 2016年 zhuoheng. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profile")
    }

    
   private func addChildVc(storyName:String) {
    //1.通过storboard获取控制器
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
    //2.将childVc作为子控制器
        addChildViewController(childVc)
        
    }
    
    
    

}
