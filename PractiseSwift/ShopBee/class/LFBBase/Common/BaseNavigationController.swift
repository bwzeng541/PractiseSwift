//
//  BaseNavigationController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/23.
//

import UIKit

class BaseNavigationController: UINavigationController,UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var isAnimation = true
    private var currentNotRootVC: UIViewController?

    
    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "v2_goback"), for: .normal)
        backBtn.titleLabel?.isHidden = true
       // backBtn.addTarget(self, action: "backBtnClick", forSelector("backBtnClick"): .touchUpInside)        
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)

        backBtn.contentHorizontalAlignment = .left
        backBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        let btnW: CGFloat = ScreenWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRect.init(x: 0, y: 0, width: btnW, height: 40)
        
        return backBtn
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // interactivePopGestureRecognizer!.delegate = nil
        // Do any additional setup after loading the view.
        interactivePopGestureRecognizer?.isEnabled = false;
        delegate = self
     
      
        guard let gesture = interactivePopGestureRecognizer else { return }
               gesture.isEnabled = false
               let gestureView = gesture.view
               // 2.获取所有的target
               let target = (gesture.value(forKey: "_targets") as? [NSObject])?.first
               guard let transition = target?.value(forKey: "_target") else { return }
               let action = Selector(("handleNavigationTransition:"))
               // 3.创建新的手势
               let popGes = UIPanGestureRecognizer()
               popGes.maximumNumberOfTouches = 1
        popGes.delegate = self
               gestureView?.addGestureRecognizer(popGes)
               popGes.addTarget(transition, action: action)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        if children.count > 0 {

            UINavigationBar.appearance().backItem?.hidesBackButton = false

            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backBtnClick() {
        popViewController(animated: isAnimation)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
           currentNotRootVC = viewControllers.count <= 1 ? nil : viewController
       }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (currentNotRootVC == nil || viewControllers.count <= 1 ){return false}
        let pos = gestureRecognizer.location(in: gestureRecognizer.view)//gestureRecognizer.location(in: gestureRecognizer.view?)//velocityInView(in: gestureRecognizer.view)
        if pos.x<200 {
            return true
        }
          return false
      }
}
