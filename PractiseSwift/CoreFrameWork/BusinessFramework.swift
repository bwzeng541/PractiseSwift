//
//  BusinessFramework.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/15.
//

import Foundation
 
#define MakeID(x, y) (((x)<<16) + (y))
#define ModuleID(x) ((x)>>16)
#define CapabilityID(x) (((x)<<16)>>16)

class BusinessFramework{
         static let sharedInstance = BusinessFramework()
}
//public static let share = TestByOc.init()
