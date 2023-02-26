//
//  Mode1.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/17.
//

import Foundation
import CTMediator
public extension CTMediator{
    
    
    
    @objc public func A_showSwift(callback:@escaping (String) -> Void) -> UIViewController? {
        //PractiseSwift 是工程的名字
        let params = [
            "callback":callback,
            kCTMediatorParamsKeySwiftTargetModuleName:"PractiseSwift"
            ] as [AnyHashable : Any]
        if let viewController = self.performTarget("Mode1", action: "Extension_ViewController", params: params, shouldCacheTarget: false) as? UIViewController {
            return viewController
        }
        return nil
    }
    
    @objc public func A_showObjc(callback:@escaping (String) -> Void) -> UIViewController? {
        let callbackBlock = callback as @convention(block) (String) -> Void
        let callbackBlockObject = unsafeBitCast(callbackBlock, to: AnyObject.self)
        let params = ["callback":callbackBlockObject] as [AnyHashable:Any]
        if let viewController = self.performTarget("A", action: "Extension_ViewController", params: params, shouldCacheTarget: false) as? UIViewController {
            return viewController
        }
        return nil
    }
}
