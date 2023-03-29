//
//  BusinessModeAManager.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/9.
//

import UIKit
import CTMediator

extension BusinessModeAManager{
    
}
class BusinessModeAManager: CTMeditorBusinessModuleProtocol {
    func callBusinessProcess(_ capabilityId: Int32, withInParam inParam: Any!) -> Int32 {
        switch (capabilityId) {
        case Int32(ModeAManagerCapacity.Capactity1.rawValue):
            func1(withInParam: inParam)
        case Int32(ModeAManagerCapacity.Capactity2.rawValue):
            func2(withInParam: inParam)
            
        default:
            break
        }
        return 0
    }
    
    
    func initBusinessModule(_ info: CTMediatorBusinessModuleInfo!) -> Int32 {
        info.businessModuleId = (Int32)(TModuleID.ModeAManager.rawValue)
        info.businessFramework = info.businessFramework
        return 0
    }
    
  
    
    private func func1(withInParam inParam: Any!){
            
    }
        
        
 
    private func func2(withInParam inParam: Any!){
        CTMediator.sharedInstance().broadcastBusinessNotify(MakeID((Int32)(TModuleID.HomeController.rawValue),Int32(ModeAManagerCapacity.Capactity1.rawValue)), withInParam: inParam)
    }
}
