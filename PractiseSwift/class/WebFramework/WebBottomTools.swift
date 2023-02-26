//
//  WebBottomTools.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/18.
//

import Foundation

class WebBottomTools: UIView{
class func webBottomTools() -> WebBottomTools {
      return Bundle.main.loadNibNamed("WebBottomTools", owner: nil, options: [:])?.first as! WebBottomTools;
  }
}
