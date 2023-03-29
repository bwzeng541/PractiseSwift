//
//  Theme.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/23.
//

import Foundation
import UIKit


// MARK: - 常用颜色
public let LFBGlobalBackgroundColor = UIColor.RGB(r: 239, g: 239, b: 239)
public let LFBNavigationYellowColor = UIColor.RGB(r: 253, g: 212, b: 49)
public let LFBTextGreyColol = UIColor.RGB(r:130, g: 130, b: 130)
public let LFBTextBlackColor = UIColor.RGB(r:50, g: 50, b: 50)
public let LFBNavigationBarWhiteBackgroundColor = UIColor.RGB(r:249, g: 250, b: 253)

public let GuideViewControllerDidFinish = "GuideViewControllerDidFinish"
public let LFBSearchViewControllerDeinit = "LFBSearchViewControllerDeinit"
public let LFBShopCarBuyPriceDidChangeNotification = "LFBShopCarBuyPriceDidChangeNotification"
public let HomeGoodsInventoryProblem = "HomeGoodsInventoryProblem"

public let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
public let ScreenBounds: CGRect = UIScreen.main.bounds
public let ShopCarRedDotAnimationDuration: TimeInterval = 0.2
public let NavigationH: CGFloat = 64
public let LFBSearchViewControllerHistorySearchArray = "LFBSearchViewControllerHistorySearchArray"
// MARK: - Home 属性
public let HotViewMargin: CGFloat = 10
public let HomeCollectionViewCellMargin: CGFloat = 10
public let HomeCollectionTextFont = UIFont.systemFont(ofSize: 14)
public let HomeCollectionCellAnimationDuration: TimeInterval = 1.0

func CGRectMake(_ x:CGFloat ,_ y:CGFloat ,_ w :CGFloat,_ h:CGFloat) -> CGRect{
    return CGRect.init(x: x,y: y,width: w,height: h)
}
