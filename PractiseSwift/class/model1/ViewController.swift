//
//  ViewController.swift
//  A_swift
//
//  Created by casa on 2017/1/4.
//  Copyright © 2017年 casa. All rights reserved.
//

import UIKit
import CTMediator
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    var timerDispose: Disposable?
    var timerDispose2: Disposable?

let parap1 = ("subscribe",Model1_Capacity.Capactity1.rawValue)
    let parap2 = ("subscribe2",Model1_Capacity.Capactity2.rawValue)
    let clickDelegate = PublishSubject<Int>()

    deinit {
        
        print("is being deInitialized.");
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timerDispose2?.dispose();
        timerDispose?.dispose();
        super.viewDidDisappear(animated)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        
        timerDispose =  Observable<Int>.timer(.seconds(5), scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "testTimer4"))
            .subscribe(onNext: {[weak self] num in
                print(Thread.current, "subscribe===>", num)
                CTMediator.sharedInstance().broadcastBusinessNotify(Model1_Name, capacity: Model1_Capacity.Capactity1.rawValue, withInParam: self?.clickDelegate)
            })
        
        timerDispose2 = Observable<Int>.timer(.seconds(10), scheduler:MainScheduler.instance)
            .subscribe(onNext: {[weak self]  num in
                print(Thread.current, "subscribe2===>", num)
                CTMediator.sharedInstance().broadcastBusinessNotify(Model1_Name, capacity: Model1_Capacity.Capactity2.rawValue, withInParam: self?.parap2)
                self?.clickDelegate.onNext(1)

            })
     }
}

