//
//  AppDelegate.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init();
        self.window?.backgroundColor = .white
        self.window?.frame = UIScreen.main.bounds
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = HomeController()
        createWcdbTable()
        return true
    }

    // MARK: UISceneSession Lifecycle

}

