//
//  FreshHot.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import UIKit
import ObjectMapper
import HandyJSON
import RxSwift
class FreshHot: NSObject {
    
    static let shared = FreshHot()
    
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
    
    let hostFressSubject = BehaviorSubject<AppDataModelResult<[Goods]> >(value: AppDataModelResult.success([]))
    private var timerDispose: Disposable?

    public func startUpdateFreshHot(){
        do{
            timerDispose?.dispose()
            timerDispose =  Observable<Int>.timer(.milliseconds(100), scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "updateAddress"))
                .subscribe(onNext: {[weak self] num in
                    let path =  (R.file.localResBundle(())!.absoluteString+"首页新鲜热卖").RSwiftRemoveFilePre()!
                    do {
                        let JSONString = try String(contentsOfFile: path)
                        do {
                            let mm   = FreshHomeHot.deserialize(from: JSONString)?.data
                            let ret = AppDataModelResult.success(mm!)
                             DispatchQueue.main.async {
                                 self?.hostFressSubject.onNext(ret)
                            }
                        }
                    } catch {
                        let rr:[Goods] = []
                        let ret = AppDataModelResult.success(rr)
                        self?.hostFressSubject.onNext(ret)
                    }
                })
        }
        catch _{
            
        }
        
    }
  
    
   
}

class FreshHomeHot:HandyJSON{
    var pag:Int! = -1
    var code:Int! = -1
    var msg:String! = ""
    var reqid:String! = ""
    var data:[Goods] = []
    required init() {}
}

class Goods: HandyJSON {
    //*************************商品模型默认属性**********************************
    /// 商品ID
    var id: String! = ""
    /// 商品姓名
    var name: String! = ""
    var brand_id: String!  = ""
    /// 超市价格
    var market_price: String! = ""
    var cid: String! = ""
    var category_id: String! = ""
    /// 当前价格
    var partner_price: String! = ""
    var brand_name: String! = ""
    var pre_img: String! = ""
    
    var pre_imgs: String! = ""
    /// 参数
    var specifics: String! = ""
    var product_id: String! = ""
    var dealer_id: String! = ""
    /// 当前价格
    var price: String! = ""
    /// 库存
    var number: Int! = -1
    /// 买一赠一
    var pm_desc: String! = ""
    var had_pm: Int! = -1
    /// urlStr
    var img: String! = ""
    /// 是不是精选 0 : 不是, 1 : 是
    var is_xf: Int! = 0
    
    //*************************商品模型辅助属性**********************************
    // 记录用户对商品添加次数
    var userBuyNumber: Int! = 0
    required init() {}
}
