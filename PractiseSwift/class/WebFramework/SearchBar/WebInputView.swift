//
//  WebInputView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/3.
//

import UIKit

 

protocol WebInputViewDelegate:AnyObject {
     func clickCharFromInputView(_ str:String)
}

class WebInputView: UIView {
    private let titleArray = [":" ,"/","www.","m.",".com",".cn",".net","https://"]
     
    weak open var delegate: WebInputViewDelegate? // default is nil. weak reference

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
     }
    
    func makeUI() {
        
        let offset:Float = 5.0
        let count  = Float(titleArray.count);
        let w = ((Float)(self.frame.size.width) - offset) / (count) - offset
        for j in 0 ..< titleArray.count {
            let title = titleArray[j]
            let btn = UIButton.init(type: .custom)
            let frame = CGRect.init(x: CGFloat((Float((j+1))*offset)+(w*Float(j))),y: 0.0,width: CGFloat(w),height: self.frame.height)
            btn.frame = frame;
            btn.backgroundColor = UIColor.backGroundGrayColor()
            btn.setTitle(title, for:.normal )
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.setTitleColor(UIColor.black, for: .normal)
            self.addSubview(btn)
            btn.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)

         }
    }
    
    @objc func clickEvent(sender:UIButton) {
        delegate?.clickCharFromInputView((sender.titleLabel?.text)!)
    }
}
