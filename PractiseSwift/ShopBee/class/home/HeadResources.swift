//
//  HeadResources.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit
import HandyJSON
import ObjectMapper
class HeadResources: NSObject {

    var msg: String?
    var reqid: String?
    var data: DataDetial?
    
    class func loadHomeHeadData(completion:(_ data: HeadResources?,_ error: NSError?) -> Void) {
        let path =  (R.file.localResBundle(())!.absoluteString+"首页焦点按钮").RSwiftRemoveFilePre()!
        
        do {
        let jsonString = try String(contentsOfFile: path)
        if jsonString != nil {
            let data   = FocusData.deserialize(from: jsonString)?.headData
            let retData = HeadResources()
            retData.data = data
            completion(retData,nil)
           }
        }
        catch _{
            
        }
    }
}

class FocusData:HandyJSON{
    var code:Int = -1
    var msg:String = "faild"
    var reqid:String = "reqidtest"
    var headData:DataDetial?
    required init() {}
      func mapping(mapper: HelpingMapper){
          mapper.specify(property: &headData, name: "data")
    }
}

class DataDetial:HandyJSON{
    var focus:[Activities]?
    var icons:[Activities]?
    var dealer:Dealer?
    required init() {}

}

class Dealer:HandyJSON{
    var zchtid:String!
    var lat:String!
    var lng:String!
    required init() {}

}

 

 
class Activities: HandyJSON, Codable,NSCopying{
    var id: String? = nil
    var name: String? = nil
    var img: String? = nil
    var topimg: String? = nil
    var jptype: String? = nil
    var trackid: String? = nil
    var mimg: String? = nil
    var customURL: String? = nil
    
    func copy(with zone: NSZone? = nil) -> Any {
        let newItem = Activities();
        newItem.id = self.id;
        newItem.img = self.img;
        newItem.name = self.name;
        newItem.topimg = self.topimg;
        newItem.jptype = self.jptype;
        newItem.trackid = self.trackid;
        newItem.mimg = self.mimg;
        newItem.customURL = self.customURL;
        return newItem
    }
    
    required init() {}

}

 
