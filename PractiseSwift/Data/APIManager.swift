//
//  APIManager.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/5.
//

import Foundation
import Moya
enum APISearchManager{
    case baiduSearch(String)
}

//data里面有中文
extension Data{
    var gb_18030_2000:String{
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        let dogString:String = NSString(data: self, encoding: enc)! as String
        return dogString
    }
}

extension String {
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
   
        var baiduSearchLink:String{
            return "https://www.baidu.com/s?word="+self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
    
}

extension APISearchManager: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: "https://suggestion.baidu.com/")!
    }
    var path: String {
        switch self {//https://suggestion.baidu.com/su?wd=wq&p=3&cb=window.bdsug.sug
           case .baiduSearch(let word):
            return "su?wd=\(word.urlEscaped)&p=3&cb=window.bdsug.sug"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
  
    

    
}
