//
//  ADViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/18.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class ADViewController: UIViewController {

   let  rxCallback = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()

    typealias callBack = ((Bool) -> Void)
    private lazy var backImageView:UIImageView = {
        let backImageView = UIImageView.init(frame: UIScreen.main.bounds)
        backImageView.image = R.image.iphone_ad()
        return backImageView
    }()
    
    deinit {
        JTPrint(message: self)
    }
    
    private lazy var signInActivityIndicator:UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        activityIndicatorView.frame = CGRect.init(origin: CGPoint(x: self.view.size.width/2-25,y: self.view.size.height/2+25), size: CGSize.init(width: 50, height: 50))
       // activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    public var adCallBack : callBack?
    private var videoMode:AdViewModel?
    var imageUrl:String? {
        didSet{
            let url = URL(string: imageUrl)
            backImageView.kf.setImage(with: url, placeholder:R.image.iphone_ad(), options:  [
                .scaleFactor(UIScreen.main.scale),
                .transition(.flipFromLeft(1)),
                .cacheOriginalImage
            ])
            { [weak self]   result  in
                switch result
                {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                   Observable<Int>.timer(.seconds(5), scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "testTimer4"))
                        .subscribe(onNext: {[weak self] num in
                            DispatchQueue.main.async {
                                self?.rxCallback.onNext(true)
                                self?.rxCallback.dispose()
                            }
                        }).disposed(by:self!.disposeBag)
                case .failure(let err):
                    print("Task done for: \(err.errorDescription ?? "")")
                    self?.adCallBack!(false)
                    self?.rxCallback.onNext(false)
                    self?.rxCallback.dispose()
               }
           }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backImageView)
        self.view.addSubview(signInActivityIndicator)
        UIApplication.shared.setStatusBarHidden(false, with: .none)//setStatusBarHidden(false, animated: false)
        videoMode = AdViewModel.init();
        let oubject =  PublishSubject<Void>()
        let input = AdViewModel.Input(startEvent: oubject)
        let out = videoMode?.transform( input)
        out?.loading.asDriver(onErrorRecover: { _ in fatalError()
            
        }).drive(signInActivityIndicator.rx.isAnimating).disposed(by: disposeBag)
        out?.databaseReuslt.subscribe(onNext: { [weak self] event in
            switch event
            {
            case .success(let ret):
                self?.imageUrl = ret
            case .failure(let errdes):
                print("error"+errdes)
                self?.rxCallback.onNext(true)
            }
        })
        oubject.onNext(())
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
