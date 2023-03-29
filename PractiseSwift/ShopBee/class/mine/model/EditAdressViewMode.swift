//
//  EditAdressViewMode.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/28.
//

import UIKit
import RxCocoa
import RxSwift

enum ValidationResult< T >   {
    case ok(message: T)
    case empty
    case validating
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

class EditAdressViewMode :ViewModelType{
    private var disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        let databaseReuslt = PublishSubject<AppDataModelResult<Adress> >()
    
        //replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let realIphone = input.validatedUserIphone.map({ i -> String in
            let ret =  i.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            return ret
       }).asObservable()
        let allParame = Observable.combineLatest(input.validatedUsername, realIphone/*input.validatedUserIphone*/
                                                 ,input.validateUserGender,input.validateUserCity,input.validateUserAer
                                                 ,input.validateUserDeital) { (username: $0, iphone: $1,gender:$2,city:$3,useraer:$4,deital:$5) }
        input.tagSignal.withLatestFrom(allParame).flatMapLatest{[weak self] pair -> Observable<Adress> in
         //   return (self?.createProutce("pair"))!
            let nn = Adress()
            nn.gender = String(pair.gender)
            nn.accept_name = pair.username
            nn.city_name = pair.city
            nn.telphone = pair.iphone
            nn.address = pair.useraer + " "+pair.deital
            return .just(nn)
        }.subscribe(onNext:{[weak self]  event in
            let m =  AppDataModelResult.success(event)
            databaseReuslt.onNext(m)
        }).disposed(by: disposeBag)
    
       let validatedUsername = input.validatedUsername.flatMapLatest {[weak self] username in
           return ((self?.validateUsernamefun(username).observe(on: MainScheduler.instance))?.catchAndReturn(.failed(message: "validatedUsername error")))!
       }
        
        let validateIphone = input.validatedUserIphone.flatMapLatest{[weak self] iphone in
            return (self?.validateUseIphonefun(iphone).asDriver(onErrorJustReturn: .failed(message: "Error contacting server")))!
        }
        
        let validateUserGender = input.validateUserGender.flatMapLatest{[weak self] gender in
            return (self?.validateUseGenderfun(gender).asDriver(onErrorJustReturn: .failed(message: "Error contacting server")))!
        }
        
        let validateUserCity = input.validateUserCity.flatMapLatest{[weak self] city in
            return (self?.validateTextOrEmpytfun(city).asDriver(onErrorJustReturn: .failed(message: "Error contacting server")))!
        }
        
        let validateUserAer = input.validateUserAer.flatMapLatest{[weak self] aer in
            return (self?.validateTextOrEmpytfun(aer).asDriver(onErrorJustReturn: .failed(message: "Error contacting server")))!
        }
        
        let validatedeital = input.validateUserDeital.flatMapLatest{[weak self] deital in
            return (self?.validateTextOrEmpytfun(deital).asDriver(onErrorJustReturn: .failed(message: "Error contacting server")))!
        }
        
         let signupEnabled =  Observable.combineLatest(validatedUsername,validateIphone,validateUserGender
                                                   ,validateUserCity,validateUserAer,validatedeital)
        {
            username,iphone,gender,city,aer,deital in
            username.isValid && iphone.isValid && gender.isValid && city.isValid && aer.isValid && deital.isValid
        }.distinctUntilChanged()
            
        return Output(databaseReuslt:databaseReuslt,signupEnabled: signupEnabled)//,signupEnabled:signupEnabled)
    }
    
    private func createProutce(_ str:String)  -> Observable<Adress>{
        return Observable.create{[weak self] observer -> Disposable in
            
            print("")
            observer.onCompleted()
            return Disposables.create {
             }
        
        }
    }



    func validateTextOrEmpytfun(_ text: String) -> Observable<ValidationResult<String> > {
        if text.isEmpty {
            return .just(.empty)
        }
        return .just(.ok(message: text))
    }
    
    func validateUseGenderfun(_ gender: Int) -> Observable<ValidationResult<Int> > {
        if gender == 1 || gender == 2 {
            return .just(.ok(message: gender))
        }
        return .just(.empty)
    }
    
    func validateUseIphonefun(_ iphone: String) -> Observable<ValidationResult<String> > {
        if iphone.isEmpty {
            return .just(.empty)
        }
        let nre = iphone.trimmingCharacters(in: .whitespacesAndNewlines)
        if nre.length == 13 {
        return .just(.ok(message:nre))
        }
        return .just(.empty)
    }
    
    func validateUsernamefun(_ username: String) -> Observable<ValidationResult<String> > {
        if username.isEmpty {
            return .just(ValidationResult.empty)
        }
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(ValidationResult.failed(message: "Username can only contain numbers or digits"))
        }
        return .just(ValidationResult.ok(message: username))
    }
    
    deinit{
        JTPrint(message: self)
    }
    
    struct Input {
        //
        let tagSignal: Observable<Void>
        //性别选择按钮监控
        let validateUserGender:Observable<Int>
        //
        //名字监控
        let validatedUsername: Observable<String>
        //电话监控
        let validatedUserIphone: Observable<String>
        //城市监控
        let validateUserCity: Observable<String>
        //地区监控
        let validateUserAer: Observable<String>
        //详细地址监控
        let validateUserDeital: Observable<String>
    }
    
    struct Output {
          let databaseReuslt: PublishSubject<AppDataModelResult<Adress> >
          let signupEnabled : Observable<Bool>
    }
  /*
    
    let validatedUsername: Observable<ValidationResult<String> >
    let validatedUserIphone: Observable<ValidationResult<String> >
    let validateUserCity: Observable<ValidationResult<String> >
    let validateUserAer: Observable<ValidationResult<String> >
    let validateUserDeital: Observable<ValidationResult<String> >
    let validateUserGender: Observable<ValidationResult<String> >
*/
}
