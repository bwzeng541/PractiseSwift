//
//  AnimationTabBarController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/23.
//

import Foundation
import UIKit
import Moya
import SwifterSwift
import RxSwift
import RxCocoa
protocol RAMItemAnimationProtocol {
    
    func playAnimation(_ icon : UIImageView,_ textLabel : UILabel)
    func deselectAnimation(_ icon : UIImageView,_ textLabel : UILabel,_ defaultTextColor : UIColor)
    func selectedState(_ icon : UIImageView,_ textLabel : UILabel)
}

class RAMItemAnimation: NSObject, RAMItemAnimationProtocol {
    
    var duration : CGFloat = 0.6
    var textSelectedColor: UIColor = UIColor.gray
    var iconSelectedColor: UIColor?
    
    func playAnimation(_ icon : UIImageView,_ textLabel : UILabel) {
    }
    
    func deselectAnimation(_ icon : UIImageView,_ textLabel : UILabel,_ defaultTextColor : UIColor) {
        
    }
    
    func selectedState(_ icon: UIImageView, _ textLabel : UILabel) {
    }
    
}

class RAMBounceAnimation : RAMItemAnimation {
    
    override func playAnimation(_ icon : UIImageView,_ textLabel : UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }
    
    override func deselectAnimation(_ icon : UIImageView,_ textLabel : UILabel,_ defaultTextColor : UIColor) {
        textLabel.textColor = defaultTextColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysOriginal)
            icon.image = renderImage
            icon.tintColor = defaultTextColor
            
        }
    }
    
    override func selectedState(_ icon : UIImageView, _ textLabel : UILabel) {
        textLabel.textColor = textSelectedColor
        
        if let iconImage = icon.image {
             icon.image = iconImage.original
            icon.tintColor = textSelectedColor
        }
    }
    
    func playBounceAnimation(_ icon : UIImageView) {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = .cubic
        
        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
        
        if let iconImage = icon.image {
            icon.image = iconImage.original
            icon.tintColor = iconSelectedColor
        }
    }
    
}

class RAMAnimatedTabBarItem: UITabBarItem {
    
    var animation: RAMItemAnimation?
    
    var textColor = UIColor.gray
    
    func playAnimation(_ icon: UIImageView,_ textLabel: UILabel){
        guard let animation = animation else {
            print("add animation in UITabBarItem")
            return
        }
        animation.playAnimation( icon,  textLabel)
    }
    
    func deselectAnimation(_ icon: UIImageView, _ textLabel: UILabel) {
        animation?.deselectAnimation( icon,  textLabel,  textColor)
    }
    
    func selectedState(_ icon: UIImageView,_ textLabel: UILabel) {
        animation?.selectedState( icon,  textLabel)
    }
}

class AnimationTabBarController: UITabBarController {
    
    var iconsView: [(icon: UIImageView, textLabel: UILabel)] = []
    
    var iconsImage:[UIImage] = [R.image.v2_home()!, R.image.v2_order()!, R.image.shopCart()!, R.image.v2_my()!]
    var iconsSelectedImage:[UIImage] = [R.image.v2_home_r()!, R.image.v2_order_r()!, R.image.shopCart_r()!, R.image.v2_my_r()!]
    var shopCarIcon: UIImageView?
    
    private  let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.rx
            .notification( Notification.Name(rawValue: LFBSearchViewControllerDeinit))
            .subscribe(onNext: { [weak self] _ in
                self?.searchViewControllerDeinit()
            }).disposed(by: disposeBag)
    }
    
    deinit {
        
     }
    
    func searchViewControllerDeinit() {
        if shopCarIcon != nil {
//            let redDotView = ShopCarRedDotView.sharedRedDotView
//            redDotView.frame = CGRectMake(21 + 1, -3, 15, 15)
//            shopCarIcon?.addSubview(redDotView)
        }
    }
    
    func createViewContainers() -> [String: UIView] {
        var containersDict = [String: UIView]()
        
        guard let customItems = tabBar.items as? [RAMAnimatedTabBarItem] else
        {
            return containersDict
        }
        
        for index in 0..<customItems.count {
            let viewContainer = createViewContainer(index)
            containersDict["container\(index)"] = viewContainer
        }
        
        return containersDict
    }
    
    func createViewContainer(_ index: Int) -> UIView {
        
        let viewWidth: CGFloat = ScreenWidth / CGFloat(tabBar.items!.count)
        let viewHeight: CGFloat = tabBar.bounds.size.height
                
        let viewContainer = UIView(frame: CGRect.init(x: viewWidth * CGFloat(index), y: 0, width: viewWidth, height: viewHeight))
        
        viewContainer.backgroundColor = UIColor.clear
        viewContainer.isUserInteractionEnabled = true
        
        tabBar.addSubview(viewContainer)
        viewContainer.tag = index
        
       // let tap = UITapGestureRecognizer(target: self, action: "tabBarClick:")
      //  viewContainer.addGestureRecognizer(tap)
        
        return viewContainer
    }
    
    
    func createCustomIcons(_ containers : [String: UIView]) {
        if let items = tabBar.items {
 
            for (index, item) in items.enumerated() {
                
                assert(item.image != nil, "add image icon in UITabBarItem")
                
                guard let container = containers["container\(index)"] else
                {
                    print("No container given")
                    continue
                }
                
                container.tag = index
                
                let imageW:CGFloat = 21
                let imageX:CGFloat = (ScreenWidth / CGFloat(items.count) - imageW) * 0.5
                let imageY:CGFloat = 8
                let imageH:CGFloat = 21
                let icon = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageW, height: imageH))
                icon.image = item.image
                icon.tintColor = UIColor.clear
                
                
                // text
                let textLabel = UILabel()
                textLabel.frame =  CGRect.init(x: 0, y: 32, width: ScreenWidth/CGFloat(items.count), height: 49-32)
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clear
                textLabel.font = UIFont.systemFont(ofSize: 10)
                textLabel.textAlignment = NSTextAlignment.center
                textLabel.textColor = UIColor.gray
                textLabel.translatesAutoresizingMaskIntoConstraints = true
                container.addSubview(icon)
                container.addSubview(textLabel)
                
                
                if let tabBarItem = tabBar.items {
                    let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBarItem.count)
                    textLabel.bounds.size.width = textLabelWidth
                }
                
                if 2 == index {
                  /*  let redDotView = ShopCarRedDotView.sharedRedDotView
                    redDotView.frame = CGRectMake(imageH + 1, -3, 15, 15)
                    icon.addSubview(redDotView)
                    shopCarIcon = icon*/
                }
                
                let iconsAndLabels = (icon:icon, textLabel:textLabel)
                iconsView.append(iconsAndLabels)
                
            
                item.image = nil
                item.title = ""
                
                if index == 0 {
                    selectedIndex = 0
                    selectItem(0)
                }
            }
        }
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        setSelectIndex(from: selectedIndex, to: item.tag)
    }
    
    func selectItem(_ Index: Int) {
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        let selectIcon = iconsView[Index].icon
        selectIcon.image = iconsSelectedImage[Index]
        items[Index].selectedState(selectIcon, iconsView[Index].textLabel)
    }
    
    func setSelectIndex(from: Int,to: Int) {
        
        if to == 2 {
            let vc = children[selectedIndex]
            
            let shopCar = SelectedAdressViewController()
            let nav = BaseNavigationController(rootViewController: shopCar)
            nav.modalPresentationStyle =  .fullScreen
            vc.present(nav, animated: true, completion: nil)
            
            return
        }
        
        selectedIndex = to
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        
        let fromIV = iconsView[from].icon
        fromIV.image = iconsImage[from]
        items[from].deselectAnimation(fromIV, iconsView[from].textLabel)
        
        let toIV = iconsView[to].icon
        toIV.image = iconsSelectedImage[to]
        items[to].playAnimation(toIV, iconsView[to].textLabel)
    }
}
