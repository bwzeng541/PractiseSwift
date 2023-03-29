//
//  SearhHotViewMode.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import HandyJSON
class SearhHotViewMode:ViewModelType {
    private var disposeBag = DisposeBag()

    private let databaseReuslt = BehaviorSubject<AppDataModelResult<[String]> >(value: AppDataModelResult.success([]))

    struct Input {
      let reqeustSignal: Observable<Void>
    }
    
    struct Output {
        let databaseReuslt: BehaviorSubject<AppDataModelResult<[String]> >
        //let loading: PublishSubject<Bool>
    }
    
    deinit{
        JTPrint(message: self)
    }

    func transform(_ input:Input) -> SearhHotViewMode.Output {
        input.reqeustSignal.flatMapLatest{[weak self] _  in
            return (self?.requestSearchHost())!
        }.subscribe(onNext:{[weak self] event in
            let vv = AppDataModelResult.success(event)
            self?.databaseReuslt.onNext(vv)
        }).disposed(by: disposeBag)
            
        return Output(databaseReuslt:databaseReuslt)
    }
    private func requestSearchHost()  -> Observable<[String]>{
        return Observable.create{observer in
             do{
                let path =  (R.file.localResBundle(())!.absoluteString+"SearchProduct").RSwiftRemoveFilePre()!
               // let ur =  URL.init(fileURLWithPath: path);
                 let JSONString = try String(contentsOfFile: path)
                 let ret = SearchHotData.deserialize(from: JSONString)
                 observer.onNext((ret?.data?.hotquery)!)
                 observer.onCompleted()
            }
            catch _{
                observer.onNext([])
                observer.onCompleted()
            }
           
            return Disposables.create {
             }
        
        }
    }
}

class SearchHotData:HandyJSON{
    
    var code:Int! = 0
    var msg:String! = ""
    var reqid:String! = "reqid"
    var data:HotQuery?
    required init() {}

}

class HotQuery:HandyJSON{
    var hotquery:[String]?
    required init() {}

}
/*
 
 {
     "code": 0,
     "msg": "success",
     "reqid": "16ea32e27fdd1597ed1d5a35bb458834",
     "data": {
         "hotquery": ["年货大集", "酸奶", "水", "车厘子", "洽洽瓜子", "维他", "香烟", "周黑鸭", "草莓", "星巴克", "卤味"]
     }
 }

 */
