 
import UIKit

class HomeCollectionFooterView: UICollectionReusableView {
    
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "点击查看更多商品 >"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.RGB(r:150, g: 150, b: 150)
        titleLabel.frame = CGRectMake(0, 0, ScreenWidth, 60)
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideLabel() {
        self.titleLabel.isHidden = true
    }
    
    func showLabel() {
        self.titleLabel.isHidden = false
    }
    
    func setFooterTitle(_ text: String,_ textColor: UIColor) {
        titleLabel.text = text
        titleLabel.textColor = textColor
    }
}

class HomeCollectionHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "新鲜热卖"
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.frame = CGRectMake(10, 0, 200, 20)
        titleLabel.textColor = UIColor.RGB(r:150, g: 150, b: 150)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
