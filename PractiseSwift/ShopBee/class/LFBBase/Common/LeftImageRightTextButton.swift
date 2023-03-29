//
//  LeftImageRightTextButton.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/28.
//

import UIKit

class LeftImageRightTextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        imageView?.contentMode = UIView.ContentMode.center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRectMake(0, (height - (imageView?.size.height)!) * 0.5, (imageView?.size.width)!, (imageView?.size.height)!)
        titleLabel?.frame = CGRectMake((imageView?.size.width)! + 10, 0, width - (imageView?.size.width)! - 10, height)
    }

}
