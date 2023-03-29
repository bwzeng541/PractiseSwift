//
//  SelectedAdressViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/24.
//

import UIKit

class SelectedAdressViewController: AnimationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        buildNavigationItem()    }
    
    deinit{
        JTPrint(message: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserInfo.sharedUserInfo.hasDefaultAdress() {
            let titleView = AdressTitleView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 30))
            titleView.setTitle((UserInfo.sharedUserInfo.defaultAdress()?.address) as! String)
            titleView.frame = CGRect.init(x: 0, y: 0, width: titleView.adressWidth, height: 30)
            navigationItem.titleView = titleView
            
            let tap = UITapGestureRecognizer(target: self, action:#selector(self.titleViewClick))
            navigationItem.titleView?.addGestureRecognizer(tap)
        }
    }
    
    private func buildNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButton("扫一扫", titleColor: UIColor.black,
                                                                     image: (R.image.icon_black_scancode())!, hightLightImage: nil,
                                                                     target: self, action: Selector(("leftItemClick")), type: .Left)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("搜 索", titleColor: UIColor.black,
                                                                      image:R.image.icon_search()!,hightLightImage: nil,
                                                                      target: self, action: Selector(("rightItemClick")), type: .Right)
        
        let titleView = AdressTitleView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 30))
        titleView.frame = CGRect.init(x: 0, y: 0, width: titleView.adressWidth, height: 30)
        navigationItem.titleView = titleView
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.titleViewClick))
        navigationItem.titleView?.addGestureRecognizer(tap)
    }
   
    
    @objc func leftItemClick() {
        let qrCode = QRCodeViewController()
        navigationController?.pushViewController(qrCode, animated: true)
    }
    
    @objc func rightItemClick() {
        let searchVC = SearchProductViewController()
        navigationController!.pushViewController(searchVC, animated: false)
    }
    

    @objc func titleViewClick() {
        weak var tmpSelf = self

        let adressVC = MyAdressViewController { (adress) -> () in
            let titleView = AdressTitleView(frame: CGRectMake(0, 0, 0, 30))
            titleView.setTitle(adress.address!)
            titleView.frame = CGRectMake(0, 0, titleView.adressWidth, 30)
            tmpSelf?.navigationItem.titleView = titleView
            UserInfo.sharedUserInfo.setDefaultAdress(adress)

            let tap = UITapGestureRecognizer(target: self, action:#selector(self.titleViewClick))
            tmpSelf?.navigationItem.titleView?.addGestureRecognizer(tap)
        }
        adressVC.isSelectVC = true
        navigationController?.pushViewController(adressVC, animated: true)
    }
}
