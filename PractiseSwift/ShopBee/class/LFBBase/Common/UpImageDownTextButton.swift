//
//  UpImageDownTextButton.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/24.
//

 import UIKit

class UpImageDownTextButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRect.init(x:0,y: height - 15, width: width, height: (titleLabel?.height)!)
        titleLabel?.textAlignment = .center
        
        imageView?.frame = CGRect.init(x:0,y: 0,width: width,height: height - 15)
        imageView?.contentMode = UIView.ContentMode.center
    }

}

class ItemLeftButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let Offset: CGFloat = 15
        
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRect.init(x:-Offset,y: height - 15,width: width - Offset, height:(titleLabel?.height)!)
        titleLabel?.textAlignment = .center
        
        imageView?.frame = CGRect.init(x:-Offset,y: 0, width: width - Offset, height: height - 15)
        imageView?.contentMode = .center
    }
}

class ItemRightButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let Offset: CGFloat = 15
        
        titleLabel?.sizeToFit()
        titleLabel?.frame = CGRect.init(x:Offset, y:height - 15,width: width + Offset,height: (titleLabel?.height)!)
        titleLabel?.textAlignment = .center
        
        imageView?.frame = CGRect.init(x:Offset,y: 0, width:width + Offset,height: height - 15)
        imageView?.contentMode = .center
    }
}

class ItemLeftImageButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = bounds
        imageView?.frame.origin.x = -15
    }
    
}
