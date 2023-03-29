//
//  SearchProducts.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/26.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import HandyJSON

 


class SearchProducts:ViewModelType {
   
    deinit{
        JTPrint(message: self)
    }
    private var disposeBag = DisposeBag()
    private var task:DataRequest?
    struct Input {
      let reqeustSignal: Observable<String?>
    }
    
    struct Output {
         let searching: Observable<Bool>
         let databaseReuslt: PublishSubject<AppDataModelResult<[Goods]> >
    }
    
    func transform(_ input: Input) -> Output {
        let signingIn = ActivityIndicator()
        let databaseReuslt = PublishSubject<AppDataModelResult<[Goods]> >()

        input.reqeustSignal.flatMapLatest{[weak self] event  in
            return (self?.requestSearchProduct(event!))!.trackActivity(signingIn)
        }.subscribe(onNext:{[weak self] event in
            let vv = AppDataModelResult.success(event)
            databaseReuslt.onNext(vv)
        }).disposed(by: disposeBag)
            
        return Output(searching:signingIn.asObservable() ,databaseReuslt:databaseReuslt)
    }
    
    private func requestSearchProduct(_ str:String)  -> Observable<[Goods]>{
        return Observable.create{[weak self] observer -> Disposable in
             do{
                 self?.task?.cancel()
                 let url = URL(string: "http://www.baidu.com")!
                 var request =  URLRequest(url: url)
                 request.method = .get
                 request.timeoutInterval = 2
                 request.cachePolicy = .useProtocolCachePolicy
                 
                 self?.task =  AF.request( request).responseString {ret in

                     switch ret.result{
                     case .success(_):
                         do{
                         let path =  (R.file.localResBundle(())!.absoluteString+"促销").RSwiftRemoveFilePre()!
                           let jsonString = try String(contentsOfFile: path)
                          if jsonString != nil {
                              let data   = SearchProductResulst.deserialize(from: jsonString)?.goods
                              observer.onNext(data!)
                              observer.onCompleted()
                              }
                          else {
                          observer.onNext([])
                              observer.onCompleted()
                          }
                         }
                         catch _{
                             
                         }
                     case .failure( _):
                         observer.onNext([])
                         observer.onCompleted()
                     }
                    
                 }
            }
            catch _{
                observer.onNext([])
                observer.onCompleted()
            }
           
            return Disposables.create {
                self?.task?.cancel()
            }
        
        }
    }
}


class SearchProductResulst:HandyJSON{
    required init() {}
    
    var code:Int? = -1;
    var  msg:String? = "falid"
    var reqid:String? = "reqid"
    var goods:[Goods]?
    func mapping(mapper: HelpingMapper){
        mapper.specify(property: &goods, name: "data")
 
    }
}
