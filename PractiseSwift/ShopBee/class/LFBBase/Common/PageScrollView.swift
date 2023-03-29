//
//  PageScrollView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/29.
//

import UIKit
import Kingfisher
class PageScrollView: UIView {

    private let imageViewMaxCount = 3
    private var imageScrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var timer: Timer?
    private var placeholderImage: UIImage?
    private var imageClick:((_ index: Int) -> ())?
    
    var headData: HeadResources? {
        didSet {
            
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            
            if headData?.data?.focus!.count ?? -1 >= 0 {
                pageControl.numberOfPages = (headData?.data?.focus?.count)!
                pageControl.currentPage = 0
                updatePageScrollView()
                
                startTimer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildImageScrollView()
        
        buildPageControl()
        
    }
    
    convenience init(frame: CGRect, placeholder: UIImage, focusImageViewClick:@escaping ((_ index: Int) -> Void)) {
        self.init(frame: frame)
        placeholderImage = placeholder
        imageClick = focusImageViewClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageScrollView.frame = bounds
        imageScrollView.contentSize = CGSize.init(width: CGFloat(imageViewMaxCount) * width, height: 0)
        for i in 0...imageViewMaxCount - 1 {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRectMake(CGFloat(i) * imageScrollView.width, 0, imageScrollView.width, imageScrollView.height)
        }
        
        let pageW: CGFloat = 80
        let pageH: CGFloat = 20
        let pageX: CGFloat = imageScrollView.width - pageW
        let pageY: CGFloat = imageScrollView.height - pageH
        pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH)
        
        updatePageScrollView()
    }
    
    func buildImageScrollView(){
        imageScrollView = UIScrollView()
        imageScrollView.bounces = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.isPagingEnabled = true
        imageScrollView.delegate = self
        addSubview(imageScrollView)
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageViewClick(_:)))
            imageView.addGestureRecognizer(tap)
            imageScrollView.addSubview(imageView)
        }
    }
    
    @objc func imageViewClick(_ tap: UITapGestureRecognizer){
            imageClick?(tap.view!.tag)
    }
    
    func buildPageControl(){
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_normal")!)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_selected")!)
        addSubview(pageControl)
    }
    
    //MARK: 更新内容
    private func updatePageScrollView() {
        for  i in 0 ..< imageScrollView.subviews.count {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            var index = pageControl.currentPage
            
            if i == 0 {
                index-=1
            } else if 2 == i {
                index+=1
            }
            
            if index < 0 {
                index = self.pageControl.numberOfPages - 1
            } else if index >= pageControl.numberOfPages {
                index = 0
            }
            
            imageView.tag = index
            if (headData?.data?.focus!.count)! > 0 {
                imageView.kf.setImage(with: URL(string: headData!.data!.focus![index].img!), placeholder: placeholderImage)
            }
        }
        
        imageScrollView.contentOffset = CGPoint.init(x: imageScrollView.width, y: 0)
    }
    
    private func startTimer(){
        timer = Timer(timeInterval: 3.0, target: self, selector: #selector(getter: self.next), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func next() {
        imageScrollView.setContentOffset(CGPoint.init(x: 2.0 * imageScrollView.frame.size.width, y: 0), animated: true)
    }
}


extension PageScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var page: Int = 0
        var minDistance: CGFloat = CGFloat(MAXFLOAT)
        for i in 0..<imageScrollView.subviews.count {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            let distance:CGFloat = abs(imageView.x - scrollView.contentOffset.x)
            
            if distance < minDistance {
                minDistance = distance
                page = imageView.tag
            }
        }
        pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageScrollView()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageScrollView()
    }
}
