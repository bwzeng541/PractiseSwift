//
//  DataItem.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/16.
//

import Foundation
import HandyJSON

class DataItem: HandyJSON, Codable {
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


 
