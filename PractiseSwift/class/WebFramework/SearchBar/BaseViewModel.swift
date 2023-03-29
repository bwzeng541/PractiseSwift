//
//  BaseViewModel.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/4.
//

import Foundation
import RxSwift
import RxCocoa
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

class BaseViewModel: NSObject {

    var disposeBag = DisposeBag()

    let loading = ActivityIndicator()
    
    let error = ErrorTracker()

    override init() {
        super.init()
        
        error.asDriver().drive(onNext: { (error) in
            printLog("ViewModel ----------->error")
        }).disposed(by:disposeBag)
    }
    
    deinit {
        print("\(type(of: self)):Deinited")
    }
}
