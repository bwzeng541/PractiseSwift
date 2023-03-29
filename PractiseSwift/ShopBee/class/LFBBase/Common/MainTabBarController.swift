//
//  MainTabBarController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/23.
//

import UIKit

class MainTabBarController: AnimationTabBarController,UITabBarControllerDelegate {
    private var fristLoadMainTabBarController: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        buildMainTabBarChildViewController()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if fristLoadMainTabBarController {
            let containers = createViewContainers()
            
            createCustomIcons(containers)
            fristLoadMainTabBarController = false
        }
    }
    
    private func buildMainTabBarChildViewController() {
        tabBarControllerAddChildViewController(TestCtrl(), "首页", "v2_home", "v2_home_r", 0)
        tabBarControllerAddChildViewController(TestCtrl(), "闪电超市", "v2_order", "v2_order_r", 1)
        tabBarControllerAddChildViewController(TestCtrl(), "购物车", "shopCart", "shopCart", 2)
        tabBarControllerAddChildViewController(TestCtrl(), "我的", "v2_my", "v2_my_r", 3)
    }

    private func tabBarControllerAddChildViewController(_ childView: UIViewController,_ title: String,_ imageName: String,_ selectedImageName: String,_ tag: Int) {
        let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        vcItem.tag = tag
        vcItem.animation = RAMBounceAnimation()
        childView.tabBarItem = vcItem
        
        let navigationVC = BaseNavigationController(rootViewController:childView)
        addChild(navigationVC)
        
        childView.navigationItem.title = title
    }
    
     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let childArr = tabBarController.children as NSArray
        let index = childArr.index(of: viewController)

        if index == 2 {
            return false
        }
        
        return true
    }

    
}
