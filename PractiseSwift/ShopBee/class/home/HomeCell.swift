//
//  HomeCell.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import UIKit
import Kingfisher
enum HomeCellTyep: Int {
    case Horizontal = 0
    case Vertical = 1
}

class HomeCell: UICollectionViewCell {
    //MARK: - 初始化子空间
    private lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        return backImageView
        }()
    
    private lazy var goodsImageView: UIImageView = {
        let goodsImageView = UIImageView()
        goodsImageView.contentMode = .scaleAspectFit
        return goodsImageView
        }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.font = HomeCollectionTextFont
        nameLabel.textColor = UIColor.black
        return nameLabel
        }()
    
    private lazy var fineImageView: UIImageView = {
        let fineImageView = UIImageView()
        fineImageView.image = R.image.jingxuanPng()
        return fineImageView
        }()
    
    private lazy var giveImageView: UIImageView = {
        let giveImageView = UIImageView()
        giveImageView.image = R.image.buyOnePng()
        return giveImageView
        }()
    
    private lazy var specificsLabel: UILabel = {
        let specificsLabel = UILabel()
        specificsLabel.textColor = UIColor.RGB(r:100, g: 100, b: 100)
        specificsLabel.font = UIFont.systemFont(ofSize: 12)
        specificsLabel.textAlignment = .left
        return specificsLabel
        }()
    
    private var discountPriceView: DiscountPriceView?
    
    private lazy var buyView: BuyView = {
        let buyView = BuyView()
        return buyView
        }()
    
    
    private var type: HomeCellTyep? {
        didSet {
            backImageView.isHidden = !(type == HomeCellTyep.Horizontal)
            goodsImageView.isHidden = (type == HomeCellTyep.Horizontal)
            nameLabel.isHidden = (type == HomeCellTyep.Horizontal)
            fineImageView.isHidden = (type == HomeCellTyep.Horizontal)
            giveImageView.isHidden = (type == HomeCellTyep.Horizontal)
            specificsLabel.isHidden = (type == HomeCellTyep.Horizontal)
            discountPriceView?.isHidden = (type == HomeCellTyep.Horizontal)
            buyView.isHidden = (type == HomeCellTyep.Horizontal)
        }
    }
    
    var addButtonClick:((_ imageView: UIImageView) -> ())?
    
    // MARK: - 便利构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(backImageView)
        addSubview(goodsImageView)
        addSubview(nameLabel)
        addSubview(fineImageView)
        addSubview(giveImageView)
        addSubview(specificsLabel)
        addSubview(buyView)
        
        weak var tmpSelf = self
        buyView.clickAddShopCar = {()
            if tmpSelf?.addButtonClick != nil {
                tmpSelf!.addButtonClick!(tmpSelf!.goodsImageView)
            }
        }
    }
    
    // MARK: - 模型set方法
    var activities: Activities? {
        didSet {
            self.type = .Horizontal
            backImageView.kf.setImage(with: URL(string: activities!.img!), placeholder: R.image.v2_placeholder_full_size())
        }
    }
    
    var goods: Goods? {
        didSet {
            self.type = .Vertical
            
            goodsImageView.kf.setImage(with: URL(string: goods!.img!), placeholder: R.image.v2_placeholder_square())
            nameLabel.text = goods?.name
            if goods!.pm_desc == "买一赠一" {
                giveImageView.isHidden = false
            } else {
                
                giveImageView.isHidden = true
            }
            if discountPriceView != nil {
                discountPriceView!.removeFromSuperview()
            }
            discountPriceView = DiscountPriceView(price: goods?.price, marketPrice: goods?.market_price)
            addSubview(discountPriceView!)
            
            specificsLabel.text = goods?.specifics
            buyView.goods = goods
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        //
        backImageView.frame = bounds
        goodsImageView.frame = CGRectMake(0, 0, width, width)
       /* nameLabel.frame = CGRectMake(5, width, width - 15, 20)
        fineImageView.frame = CGRectMake(5, nameLabel.frame.maxY, 30, 15)
        giveImageView.frame = CGRectMake(fineImageView.frame.maxX + 3, fineImageView.y, 35, 15)
        specificsLabel.frame = CGRectMake(nameLabel.x, fineImageView.frame.maxY, width, 20)
        discountPriceView?.frame = CGRectMake(nameLabel.x, (specificsLabel.frame.maxY), 60, height - (specificsLabel.frame.maxY))
        buyView.frame = CGRectMake(width - 85, height - 30, 80, 25)*/
        buyView.frame = CGRectMake(width - 85, height - 30, 80, 25)
        discountPriceView?.frame = CGRectMake(5,height-20, 60,   20)
        specificsLabel.frame = CGRectMake(discountPriceView!.x, discountPriceView!.y-20, width, 20)
        giveImageView.frame = CGRectMake(discountPriceView!.maxX+3, specificsLabel.y-20, 35, 15)
        fineImageView.frame = CGRectMake(5, giveImageView.y, 30, 15)
        nameLabel.frame = CGRectMake(5, fineImageView.y-20, width-15, 20)
    }
    
}
