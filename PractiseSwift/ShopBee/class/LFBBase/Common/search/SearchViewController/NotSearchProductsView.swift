//
//  NotSearchProductsView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import UIKit

class NotSearchProductsView: UIView {

    private let topBackView = UIView()
    private let searchLabel = UILabel()
    private let markImageView = UIImageView()
    private let productLabel = UILabel()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        topBackView.frame = CGRectMake(0, 0, width, 50)
        topBackView.backgroundColor = UIColor.RGB(r:249, g: 242, b: 216)
        addSubview(topBackView)
        
        markImageView.contentMode = UIView.ContentMode.scaleAspectFill
        markImageView.image = R.image.icon_exclamationmark()//UIImage(named: "icon_exclamationmark")
        markImageView.frame = CGRectMake(15, (50 - 27) * 0.5, 27, 27)
        addSubview(markImageView)
        
        productLabel.textColor = UIColor.RGB(r:148, g: 107, b: 81)
        productLabel.font = UIFont.systemFont(ofSize: 14)
        productLabel.frame = CGRectMake(markImageView.frame.maxX + 10, 10, width * 0.7, 15)
        productLabel.text = "暂时没搜到〝星巴克〞相关商品"
        addSubview(productLabel)
        
        searchLabel.textColor = UIColor.RGB(r:252, g: 185, b: 47)
        searchLabel.font = UIFont.systemFont(ofSize: 12)
        searchLabel.text = "换其他关键词试试看,但是并没有什么卵用~"
        searchLabel.frame = CGRectMake(productLabel.x, productLabel.frame.maxY + 5, width * 0.7, 15)
        addSubview(searchLabel)
        
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = "大家都在买"
        titleLabel.frame = CGRectMake(10, 60, 200, 15)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchProductLabelText(text: String) {
        productLabel.text = "暂时没搜到" + "〝" + text + "〞" + "相关商品"
    }

}
