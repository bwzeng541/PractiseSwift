//
//  AppCommon.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/19.
//

import Foundation

 

public let kWindowSafeAreaInset = { () -> UIEdgeInsets in
    var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
//    if #available(iOS 13.0, *){
//        let  window = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first
//        insets = window!.safeAreaInsets
//    }
    if #available(iOS 11.0, *) {
        insets = UIApplication.shared.keyWindow?.safeAreaInsets ?? insets
    }
    return insets
}

public let kSafeAreaTop = kWindowSafeAreaInset().top == 0 ? 20 : kWindowSafeAreaInset().top
public let kSafeAreaBottom = kWindowSafeAreaInset().bottom
public let kStatusH = kWindowSafeAreaInset().top
