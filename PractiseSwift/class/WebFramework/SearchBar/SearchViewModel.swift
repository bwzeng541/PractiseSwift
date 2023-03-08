//
//  SearchViewModel.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/4.
//

import UIKit
import RxCocoa
import Moya
import RxSwift


//搜索数据模型：历史搜索数据，百度建议搜索数据，数据库里面的url
class SearchViewModel: BaseViewModel,ViewModelType {

    struct Input {
        let makeSearchText: Observable<String?>
     }
    
    struct Output {
        let databaseReuslt: BehaviorRelay<[UrlHistoryItem]>
        let searchReulst: BehaviorRelay<[UrlHistoryItem]>
    }
    
    private let provider = MoyaProvider<APISearchManager>()
    
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {
        let outMessage = BehaviorRelay<[UrlHistoryItem]>(value: [])
        let databaseReuslt = BehaviorRelay<[UrlHistoryItem]>(value: [])
        input.makeSearchText.filter(
            {
               let b = !($0?.isEmpty ?? false)
                if (b==false){
                    outMessage.accept([])
                databaseReuslt.accept(WCDataManager.shared().getObject(UrlHistoryItem.classForCoder(), tableName: urlHistoryTable, word:""))
                }
                return b
            }).debounce(.milliseconds(300), scheduler: MainScheduler.instance ).flatMapLatest
                {  [weak self] Element in
                    (self?.self.provider.rx.request(.baiduSearch(Element! )))!.catchAndReturn(Response.init(statusCode: 404, data: Data.init(), request: nil, response: nil))
                
                       //数据库查询
                }.map({ eml in
                    do {
                        let dogString:String = eml.data.gb_18030_2000;
                         print("ret = \(dogString)")
                        var titlesArray = [String]()
                        let regex = try! NSRegularExpression(pattern: "s:\\[\"(.*)\"\\]", options: [])
                        let basicDescription = dogString as NSString
                        
                        regex.enumerateMatches(in: basicDescription as String, options: [], range: NSMakeRange(0, basicDescription.length)) { result, flags, stop in
                          if let range = result?.range(at: 1) {
                              titlesArray.append(basicDescription.substring(with: range))
                          }
                        }
                        var retArray :[UrlHistoryItem] = []
                        for i in 0..<titlesArray.count {
                            let arr_hot =  titlesArray[i].components(separatedBy: "\",\"") //[titlesArray[i] componentsSeparatedByString:@"\",\""];
                            for j in 0..<arr_hot.count {
                                let mm =  UrlHistoryItem()
                                mm.webTitle = arr_hot[j]
                                mm.url = mm.webTitle.baiduSearchLink ;
                                retArray.append(mm)
                            }
                        }
                        outMessage.accept(retArray)
                        } catch {
                    }
                })
                .subscribe(
                 
                ).disposed(by: disposeBag)
        
      //

        
        input.makeSearchText.filter(
            {
               let b = !($0?.isEmpty ?? false)
                return b
            }).debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { event in
                    databaseReuslt.accept(WCDataManager.shared().getObject(UrlHistoryItem.classForCoder(), tableName: urlHistoryTable, word:event!))
                }
            ).disposed(by: disposeBag)
        
        return Output(databaseReuslt:databaseReuslt,searchReulst: outMessage)
    }
    
  
}
