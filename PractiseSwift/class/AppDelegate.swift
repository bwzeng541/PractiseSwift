//
//  AppDelegate.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/15.
//

import UIKit
import CTMediator
import RxSwift
import RxCocoa
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //var adViewController: ADViewController?
    private  let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        self.window = UIWindow.init();
        //        self.window?.backgroundColor = .white
        //        self.window?.frame = UIScreen.main.bounds
        //        self.window?.makeKeyAndVisible()
        //        self.window?.rootViewController = HomeController()
        //
        //        CTMediator.sharedInstance().registerBusinessModule(BusinessModeAManager.init())
        //        createWcdbTable()
        //
        AdressViewMode.shared.startUpdateAddress()
        buildKeyWindow()
        
        return true
    }
    
    private func  buildKeyWindow(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.makeKeyAndVisible()
        
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        
        if isFristOpen == nil {
            window?.rootViewController = GuideViewController()
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")//GuideViewControllerDidFinish
            
            NotificationCenter.default.rx
                .notification( Notification.Name(rawValue: GuideViewControllerDidFinish))
                .subscribe(onNext: { [weak self] _ in
                    self?.loadMainTarController()
                }).disposed(by: disposeBag)
            
        } else {
            loadADRootViewController()
        }
    }
    
    private func loadMainTarController(){
         let mainTabBar = MainTabBarController()
         window?.rootViewController = mainTabBar
    }
    
    private func loadADRootViewController(){
        let adViewController :ADViewController = ADViewController()
        self.window?.rootViewController = adViewController
        adViewController.adCallBack = { ret in
            
        }
        adViewController.rxCallback.subscribe(onNext: {[weak self] (element) in
            self!.loadMainTarController()
        })
    }
    // MARK: UISceneSession Lifecycle
}

