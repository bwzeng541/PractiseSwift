//
//  SwiftUIView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/17.
//

import UIKit
import RxSwift
import RxCocoa
class WebTopTools: UIView {
    
    var disposeBag = DisposeBag()

    private  var isInitLayout: Bool = false;
    @IBOutlet weak var btnCanle: UIButton!
    @IBOutlet weak var btnSumbit: UIButton!
    @IBOutlet weak var urlText: UITextField!

    class func webTopTools() -> WebTopTools {
          return Bundle.main.loadNibNamed("WebTopTools", owner: nil, options: [:])?.first as! WebTopTools;
      }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    override func layoutSubviews(){
        super .layoutSubviews()
        makeUI();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    func makeUI() {
        if isInitLayout==false {
            
        }
        isInitLayout = true
    }
}
 
