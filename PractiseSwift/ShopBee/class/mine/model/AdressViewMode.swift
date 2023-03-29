//
//  AdressData.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON
import ObjectMapper

class AdressViewMode: NSObject {
    static let shared = AdressViewMode()
    
    private override init() {}
    
    override func copy() -> Any {
        return self // SingletonClass.shared
    }
    
    override func mutableCopy() -> Any {
        return self // SingletonClass.shared
    }
    
    // Optional
    func reset() {
        // Reset all properties to default value
    }
    
    let adressSubject = BehaviorSubject<AppDataModelResult<[Adress]> >(value: AppDataModelResult.success([]))
    private var timerDispose: Disposable?
    
    public func startUpdateAddress(){
        do{
            timerDispose?.dispose()
            timerDispose =  Observable<Int>.timer(.microseconds(100), scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "updateAddress"))
                .subscribe(onNext: {[weak self] num in
                    let path =  (R.file.localResBundle(())!.absoluteString+"MyAdress").RSwiftRemoveFilePre()!
                    do {
                        let JSONString = try String(contentsOfFile: path)
                        do {
                            let mm = MyAdress.init(JSONString: JSONString)?.adressData
                            let ret = AppDataModelResult.success(mm!)
                             DispatchQueue.main.async {
                                 self?.adressSubject.onNext(ret)
                            }
                        }
                    } catch {
                        
                    }
                })
        }
        catch _{
            
        }
    }
}



class Adress:Mappable{
    var accept_name: String! = ""
    var telphone: String! = ""
    var province_name: String! = ""
    var city_name: String! = ""
    var address: String! = ""
    var lng: String! = ""
    var lat: String! = ""
    var gender: String! = ""
    
    required init?(map: Map) {
    }
    
     init() {
    }
    
    func mapping(map: Map) {
        accept_name <- map["accept_name"]
        telphone <- map["telphone"]
        province_name <- map["province_name"]
        city_name <- map["city_name"]
        address <- map["address"]
        lng <- map["lng"]
        lat <- map["lat"]
        gender <- map["gender"]
    }
}

class MyAdress: Mappable {
    
    
    var code : Int! = -1
    var msg :String! = "查询失败"
    var reqid:String! = "reqid"
    var adressData:[Adress]! = []
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        reqid <- map["reqid"]
        adressData <- map["data"]
    }
    
    
    
}
