//
//  HomeViewController.swift
//  swift-DY
//
//  Created by chenrin on 2016/10/25.
//  Copyright © 2016年 zhuoheng. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

     lazy var pageTitleView:PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
       let titleView = PageTitleView(frame:titleFrame , title: titles)
        titleView.backgroundColor = UIColor.white
        
        titleView.delegate = self
        
        return titleView
    }()
    
    lazy var pageContentView : PageContentView = {[weak self] in
        //1.确定内容的frame
       let contentViewFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH)
        //2.确定所以子控制器
        var childVcs = [UIViewController]()
        for _ in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentViewFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
        
    }()
    
    //系统的回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
     setupUI()
    
    }

}

// MARK:- 设置UI界面
extension HomeViewController{
     func setupUI(){
        //不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1.设置导航栏
        setupNavigationBar()
        
        //2.添加titleView
        view.addSubview(pageTitleView)
        
        //3.添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    
    private func setupNavigationBar(){
        //1.设置左侧的item
        let btn = UIButton()
        btn.setImage(UIImage(named:"logo.png"), for: .normal)
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        //2.设置右侧的item
      
        let size = CGSize(width: 40, height: 40)
//        let historyItem = UIBarButtonItem.createItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
//        let searchItem = UIBarButtonItem.createItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
//        let qrcodeItem = UIBarButtonItem.createItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
         let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
    }
    
    
}


// MARK:- 遵守titleView的协议
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(current: index)
    }
}


extension HomeViewController : PageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, target: targetIndex)
    }
}







