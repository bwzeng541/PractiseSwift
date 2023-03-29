//
//  SwiftUIView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/17.
//

import UIKit
import RxSwift
import RxCocoa

typealias clickTitleBlock = ()->Void

class WebTopTools: UIView {
    
    var disposeBag = DisposeBag()

     var clickBlock:clickTitleBlock?=nil
    
    //public var clickObServa: Observable<Void>? = nil

    private  var isInitLayout: Bool = false;
    
    @IBOutlet weak var btnCanle: UIButton!
    @IBOutlet weak var urlText: UILabel!
    @IBOutlet weak var titleText: UILabel!
   

    @IBOutlet weak var progressView: UIProgressView!
 
    
    lazy var btnShowHistory:UIButton={
        let _btn = UIButton.init(type: .system);
        self.addSubview(_btn)
        _btn.snp.makeConstraints { make in
            make.edges.equalTo(titleText.snp.edges)
        }
        return _btn
    }()
    
    class func webTopTools() -> WebTopTools {
        return R.nib.webTopTools.firstView(owner: nil)!
         // return Bundle.main.loadNibNamed("WebTopTools", owner: nil, options: [:])?.first as! WebTopTools;
      }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
             self.btnShowHistory.rx.tap.asObservable().throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance).subscribe(onNext:{ [weak self] in
                 self?.clickBlock?()
            }).disposed(by: disposeBag)
        }
        isInitLayout = true
    }
    
    public func updateProgress(_ progress :Float){
        if (progress == 1.0) {
            progressView.setProgress(progress, animated: true)
            UIView.animate(withDuration: 1) { [self] in
                progressView.alpha = 0.0;
            }
        }
        else{
            if (progressView.alpha < 1.0) {
                progressView.alpha = 1.0;
                progressView.setProgress(progress, animated: false)
            }
            progressView.setProgress(progress, animated: true)
        }
    }
}
 
