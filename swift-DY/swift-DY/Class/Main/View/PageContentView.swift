//
//  PageContentView.swift
//  swift-DY
//
//  Created by chenrin on 2016/10/26.
//  Copyright © 2016年 zhuoheng. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate:class {
    func pageContentView(contentView:PageContentView,progress:CGFloat,sourceIndex:Int,targetIndex:Int)
}


private let ContentCellId = "ContentCellId"

class PageContentView: UIView {
     // MARK:- 定义属性
    var childVcs = [UIViewController]()
   weak var parentViewController : UIViewController?
    var startOffsetX:CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    var isForbidScrollDelegate:Bool = false
    
    lazy var collection : UICollectionView = {[weak self] in
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        //行间距
        layout.minimumLineSpacing = 0
        //item间距
        layout.minimumInteritemSpacing = 0
        //水平滚动
        layout.scrollDirection = .horizontal
        //创建collection
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellId)
        return collectionView
    }()
    
     // MARK:- 自定义构造函数
    init(frame: CGRect,childVcs:[UIViewController],parentViewController:UIViewController?) {
       
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension PageContentView{
    func setupUI() {
        //1.将我们的所有子控制器添加到父控制器
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        
        //2.添加UICollecionView,用于在cell中存放控制器的View
        addSubview(collection)
        collection.frame = bounds
    }
}


// MARK:- UICollectionViewDataSource
extension PageContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellId, for: indexPath)
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}
// MARK:- UICollectionViewDelegate
extension PageContentView:UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
       startOffsetX =  scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //判断是否是点击事件
        if isForbidScrollDelegate{return}
        
        //1.获取需要的数据
        var progress:CGFloat = 0
        //开始的index
        var sourceIndex : Int = 0
        //目标的index
        var targetIndex : Int = 0
        //2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        
        if currentOffsetX > startOffsetX {//左滑
            
            progress = currentOffsetX / scrollView.bounds.width - floor(currentOffsetX / scrollView.bounds.width )
            //计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollView.bounds.width)
            targetIndex = sourceIndex + 1
            if targetIndex>=childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            if currentOffsetX - startOffsetX == scrollView.bounds.width{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            progress = 1 - (currentOffsetX / scrollView.bounds.width - floor(currentOffsetX / scrollView.bounds.width ))
            targetIndex =  Int(currentOffsetX / scrollView.bounds.width)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
        }
        //传递代理
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


// MARK:- 对外暴露的方法
extension PageContentView{
    func setCurrentIndex(current:Int) {
        
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(current) * collection.frame.width
        collection.setContentOffset(CGPoint(x:offsetX,y:0), animated: false)
    }
}










