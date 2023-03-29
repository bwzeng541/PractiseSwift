//
//  UIBarButtonItem.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/24.
//

import UIKit


enum ItemButtonType: Int {
    case Left = 0
    case Right = 1
}

extension UIBarButtonItem {

   
    
    class func barButton(_ title: String, titleColor: UIColor, image: UIImage, hightLightImage: UIImage?, target: AnyObject?, action: Selector, type: ItemButtonType) -> UIBarButtonItem {
        var btn:UIButton = UIButton()
        if type == ItemButtonType.Left {
            btn = ItemLeftButton(type: .custom)
        } else {
            btn = ItemRightButton(type: .custom)
        }
        btn.setTitle(title, for: .normal)
        btn.setImage(image, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setImage(hightLightImage, for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        
        return UIBarButtonItem(customView: btn)
    }

    class func barButton(_ image: UIImage, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        let btn = ItemLeftImageButton(type: .custom)
        btn.setImage(image, for: .normal)
        btn.imageView?.contentMode = .center
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.frame = CGRectMake(0, 0, 44, 44)
        return UIBarButtonItem(customView: btn)
    }
    
    class func barButton(_ title: String, titleColor: UIColor, target: AnyObject?, action: Selector?) -> UIBarButtonItem {
        let btn = UIButton(frame: CGRectMake(0, 0, 60, 44))
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        if action != nil {
            btn.addTarget(target, action: action!, for: .touchUpInside)
        }
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        if title.count == 2 {
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -25)
        }
        return UIBarButtonItem(customView: btn)
    }
}
