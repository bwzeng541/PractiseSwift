//
//  BaseViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/23.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = LFBGlobalBackgroundColor
    }
    
    deinit {
        JTPrint(message: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
