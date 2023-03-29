//
//  AdViewModel.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/22.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Moya
import SwiftyJSON

extension String{
    
    func RSwiftRemoveFilePre() -> String? {
        let range = self.range(of: "file://")
        var ret = self
        if range != nil && range?.upperBound != nil {
            ret = String(self[range!.upperBound...])
        }
        return ret
    }
}

enum AppDataModelResult< T >  {
    case success(T)
    case failure(String)
}

class AdViewModel:ViewModelType {
    
   // let imageurl:Driver<String>
    struct Input{
        let startEvent: PublishSubject<Void>
    }
    private var disposeBag = DisposeBag()

    struct Output {
        let databaseReuslt: PublishSubject<AppDataModelResult<String> >
        let loading: PublishSubject<Bool>
    }
  
    
    func transform(_ input:AdViewModel.Input ) -> AdViewModel.Output {
        let _databaseReuslt = PublishSubject<AppDataModelResult<String> >()

        let _loading = PublishSubject<Bool>()

        let url = URL(string: "http://www.baidu.com")!
        
        var request =  URLRequest(url: url)
        request.method = .get
        request.timeoutInterval = 2
        request.cachePolicy = .useProtocolCachePolicy
        input.startEvent.subscribe (onNext: {  event in
            _loading.onNext(true)//模拟请求服务器
            AF.request( request).responseString {ret in
                _loading.onNext(false)
                switch ret.result{
                case .success(let value):
                    var ret = value
                    do{
                        let path =  (R.file.localResBundle(())!.absoluteString+"AD.txt").RSwiftRemoveFilePre()!
                        let ur =  URL.init(fileURLWithPath: path);
                        let data =  try Data.init(contentsOf:ur )
                        let json = try? JSON(data: data)
                        ret = json!["data"]["img_big_name"].string!
                    }
                    catch _{
                        
                    }
                    let retSuccess = AppDataModelResult.success(ret)
                    _databaseReuslt.onNext(retSuccess)
                    case .failure(let error):
                     _databaseReuslt.onNext(AppDataModelResult.failure(error.errorDescription!))
                    }
                }
            }
        ).disposed(by: disposeBag)

        return Output(databaseReuslt:_databaseReuslt,loading:_loading)
    }
}
