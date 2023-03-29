//
//  ShopCarRedDotView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import UIKit

class ShopCarRedDotView: UIView {

    private static let instance = ShopCarRedDotView()
    
    class var sharedRedDotView: ShopCarRedDotView {
        return instance
    }
    
    private var numberLabel: UILabel?
    private var redImageView: UIImageView?
    
    var buyNumber: Int = 0 {
        didSet {
            if 0 == buyNumber {
                numberLabel?.text = ""
                isHidden = true
            } else {
                if buyNumber > 99 {
                    numberLabel?.font = UIFont.systemFont(ofSize: 8)
                } else {
                    numberLabel?.font = UIFont.systemFont(ofSize: 10)
                }
                
                isHidden = false
                numberLabel?.text = "\(buyNumber)"
            }
        }
    }
    func addProductToRedDotView(_ animation: Bool) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, 20, 20))
        backgroundColor = UIColor.clear
        
        redImageView = UIImageView(image: R.image.reddot())
        addSubview(redImageView!)
        
        numberLabel = UILabel()
        numberLabel!.font = UIFont.systemFont(ofSize: 10)
        numberLabel!.textColor = UIColor.white
        numberLabel?.textAlignment = NSTextAlignment.center
        addSubview(numberLabel!)
        
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        redImageView?.frame = bounds
        numberLabel?.frame = CGRectMake(0, 0, width, height)
    }
    
    func addProductToRedDotView(animation: Bool) {
        buyNumber+=1
        
        if animation {
            reddotAnimation()
        }
    }
    
    func reduceProductToRedDotView(_ animation: Bool) {
        if buyNumber > 0 {
            buyNumber-=1
        }
        
        if animation {
            reddotAnimation()
        }
    }
    
    private func reddotAnimation() {
        UIView.animate(withDuration: ShopCarRedDotAnimationDuration, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (completion) -> Void in
                UIView.animate(withDuration: ShopCarRedDotAnimationDuration, animations: { () -> Void in
                    self.transform = CGAffineTransform.identity
                    }, completion: nil)
        })
    }
}