//
//  DataItem.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/16.
//

import Foundation
import HandyJSON

class DataItem: HandyJSON, Codable,NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let newItem = DataItem();
        newItem.name = self.name;
        newItem.avatar = self.avatar;
        newItem.message = self.message;
        newItem.image = self.image;
        newItem.video = self.video;
            return newItem
    }
    
     
    
    var name: String? = nil
    var avatar: String? = nil
    var message: String? = nil
    var image: String? = nil
    var video: String? = nil
    required init() {}

}


//extension DataItem: Equatable {
//    static func ==(lhs: DataItem, rhs: DataItem) -> Bool {
//      return false
//    }
//}


 
