//
//  ModelCommon.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/17.
//

import Foundation


public let Model1_Name = "Model1_Name"

public enum Model1_Capacity :String{
    case Capactity1 = "Capactity1"
    case Capactity2 = "Capactity2"
    case Capactity3 = "Capactity3"
    case Capactity4 = "Capactity4"
    case Capactity5 = "Capactity5"
}


public enum TModuleID:Int32{
    case HomeController = 0
    case ModeAManager
}


public enum HomeControllerCapacity :Int32{

    case Capactity1 = 0
    case Capactity2

}



public enum ModeAManagerCapacity :Int32{

    case Capactity1 = 0
    case Capactity2

}
