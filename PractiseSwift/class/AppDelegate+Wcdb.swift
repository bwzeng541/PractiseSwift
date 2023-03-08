//
//  AppDelegate+Wcdb.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/1.
//

import Foundation
//import WCDBSwift

extension AppDelegate {
    /// 创建数据库-表
    func createWcdbTable()
    {
        WCDataManager.shared().createTable(searchHotsTable, clas: UrlHistoryItem.classForCoder())
        WCDataManager.shared().createTable(urlHistoryTable, clas: UrlHistoryItem.classForCoder())
       // WCDataBaseManager.shared.createTable(table: kTABLE.urlHistory, of: UrlHistoryItemFTS.self)
     }
}
