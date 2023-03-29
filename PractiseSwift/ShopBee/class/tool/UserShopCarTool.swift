//
//  UserShopCarTool.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/26.
//

import UIKit

class UserShopCarTool: NSObject {
    private static let instance = UserShopCarTool()
    class var sharedUserShopCar: UserShopCarTool {
        return instance
    }
    
    

    func addSupermarkProductToShopCar(_ goods: Goods) {
    }
    func removeSupermarketProduct(_ goods:Goods){
        
    }
}
