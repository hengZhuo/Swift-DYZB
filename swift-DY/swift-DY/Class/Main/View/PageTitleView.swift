//
//  PageTitleView.swift
//  swift-DY
//
//  Created by chenrin on 2016/10/26.
//  Copyright © 2016年 zhuoheng. All rights reserved.
//

import UIKit
// MARK:- 定义协议
protocol  PageTitleViewDelegate:class{
    func pageTitleView(titleView:PageTitleView,selectedIndex index:Int)
    
}

private let knormolLineColor:(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kselectLineColor:(CGFloat,CGFloat,CGFloat) = (255,128,0)

// MARK:- 定义类
class PageTitleView: UIView {
    // MARK:- 定义属性
     var titles : [String]
    //当前的下标值label
    var currentIndex = 0
    weak var delegate : PageTitleViewDelegate?
    
    lazy var titleLabels : [UILabel] = [UILabel]()
    
    lazy var scrollView:UIScrollView = {
       let scrollView = UIScrollView()
        //水平的线不显示
        scrollView.showsHorizontalScrollIndicator = false
        //
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        //不能超过内容的范围
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var scrollLine:UIView = {
      
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        
     return scrollLine
    }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect,title:[String]) {
        self.titles = title
        super.init(frame: frame)
        
        setupUI()
    }
    
    //重写了init，就要实现下面的代码
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension PageTitleView{
    
     func setupUI(){
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.添加title对应的Label
        setupTitleLabels()
        
        //3.设置底线和滚动的滑块
        setupBottomAndScrollLine()
    }
    
    //私有的方法
    private func setupTitleLabels(){
        for (index,title) in titles.enumerated() {
            // 1.创建UIlabel
            let label = UILabel()
            //2.设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: knormolLineColor.0, g: knormolLineColor.1, b: knormolLineColor.2)
            label.textAlignment = .center
            //3.设置label的frame
            let labelW = frame.width / CGFloat(titles.count)
            let labelH = frame.height
            let labelX = CGFloat(index) * labelW
            let labelY = CGFloat(0)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //4.将label添加到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            //5.给label添加手势
            label.isUserInteractionEnabled = true
            
            let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    private func setupBottomAndScrollLine(){
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height + lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //2.添加底下红色的线
        //2.1 获取第一个label
        guard let firstLabel = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor(r: kselectLineColor.0, g: kselectLineColor.1, b: kselectLineColor.2)
        //2.2设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - 2, width:firstLabel.frame.width , height:CGFloat(2))
    }
    
    @objc func titleLabelClick(tapGes:UITapGestureRecognizer){
        //获取当前label的下标值
       guard let currentLabel = tapGes.view as? UILabel else{return}
        
        //获取之前的label
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = UIColor(r: knormolLineColor.0, g: knormolLineColor.1, b: knormolLineColor.2)
        currentLabel.textColor = UIColor(r: kselectLineColor.0, g: kselectLineColor.1, b: kselectLineColor.2)
        
        
        //保存最新的label的index
        currentIndex = currentLabel.tag
        
        //滚动条位置的变化
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        
        UIView .animate(withDuration: 0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
            
            //通知代理
            self.delegate?.pageTitleView(titleView: self, selectedIndex: self.currentIndex)
        }
        
    }
}

// MARK:- 对外暴露的方法
extension PageTitleView{
    func setTitleWithProgress(progress:CGFloat,sourceIndex:Int,target:Int) {
        //1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[target]
        //2.处理滑块的逻辑（那根线）
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.处理颜色渐变
        //3.1 取出变化的范围
        let colorDelta = (kselectLineColor.0 - knormolLineColor.0,kselectLineColor.1 - knormolLineColor.1,kselectLineColor.2 - knormolLineColor.2)
        sourceLabel.textColor = UIColor(r: kselectLineColor.0 - colorDelta.0 * progress, g: kselectLineColor.1 - colorDelta.1 * progress, b: kselectLineColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: knormolLineColor.0 + colorDelta.0 * progress, g:  knormolLineColor.1 + colorDelta.1 * progress, b:  knormolLineColor.2 + colorDelta.2 * progress)
        //
        //记录最新的index
        currentIndex = target
    }
}










