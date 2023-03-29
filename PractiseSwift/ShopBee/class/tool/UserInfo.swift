//
//  UserInfo.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import Foundation
import UIKit
import RxSwift
class UserInfo: NSObject {
    
    private static let instance = UserInfo()
    
    private var allAdress: [Adress]?
    private var disposeBag = DisposeBag()

    class var sharedUserInfo: UserInfo {
        return instance
    }
    
    func hasDefaultAdress() -> Bool {
        
        if allAdress != nil {
            return true
        } else {
            return false
        }
    }
    
    func setAllAdress(_ adresses: [Adress]) {
        allAdress = adresses
    }
    
    func cleanAllAdress() {
        allAdress = nil
    }
    
    func defaultAdress() -> Adress? {
        let tmpRet = Adress()
        if allAdress == nil || allAdress?.count == 0 {
            AdressViewMode.shared.adressSubject.subscribe(onNext: { [weak self] event in
                switch event
                {
                case .success(let ret):
                    self?.allAdress = ret
                case .failure(let errdes):
                    print("error"+errdes)
                    self?.allAdress?.removeAll()
                }
            }).disposed(by: disposeBag)
            return allAdress!.count > 1 ? allAdress![0] : tmpRet
        } else {
            return allAdress![0]
        }
    }
    
    func setDefaultAdress(_ adress: Adress) {
        if allAdress != nil {
            allAdress?.insert(adress, at: 0)
        } else {
            allAdress = [Adress]()
            allAdress?.append(adress)
        }
    }
}
