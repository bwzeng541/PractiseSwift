//
//  HomeDataModel.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/16.
//

import Foundation
import SwiftyJSON
class HomeDataModel{
    public static let share = HomeDataModel.init()
    
     
    
    open var dataTotal: Int = 0 // default is UITableViewAutomaticDimension, set to 0 to disable
    
    open var dataArray: [DataItem] = [] ;
    
    open func requestData(){
        guard let booksFilePath = Bundle.main.path(forResource: "text", ofType: "plist") else { return }
        let dataArray = NSArray.init(contentsOf: URL.init(fileURLWithPath: booksFilePath))

        for (_, element) in dataArray!.enumerated() {
                if let model = DataItem.deserialize(from: (element as! NSDictionary)) {
                    self.dataArray.append(model);
                 }
         }

    }
    
    open func addItem(){
        let  r:DataItem = self.dataArray.randomElement() ?? DataItem();
        self.dataArray.append(r.copy() as! DataItem);
    }
}
