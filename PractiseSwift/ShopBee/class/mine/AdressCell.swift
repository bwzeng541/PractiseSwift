//
//  AdressCell.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/26.
//

import UIKit

class AdressCell: UITableViewCell {

    private let nameLabel       = UILabel()
    private let phoneLabel      = UILabel()
    private let adressLabel     = UILabel()
    private let lineView        = UIView()
    private let modifyImageView = UIImageView()
    private let bottomView      = UIView()
    
    var modifyClickCallBack:((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var adress: Adress? {
        didSet {
            nameLabel.text = adress!.accept_name
            phoneLabel.text = adress!.telphone
            adressLabel.text = adress!.address
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCell.SelectionStyle.none
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.white
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = LFBTextBlackColor
        contentView.addSubview(nameLabel)
        
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.textColor = LFBTextBlackColor
        contentView.addSubview(phoneLabel)
        
        adressLabel.font = UIFont.systemFont(ofSize: 13)
        adressLabel.textColor = UIColor.lightGray
        contentView.addSubview(adressLabel)
        
        lineView.backgroundColor = UIColor.lightGray
        lineView.alpha = 0.2
        contentView.addSubview(lineView)
        
        modifyImageView.image = R.image.v2_address_edit_highlighted()// UIImage(named: "v2_address_edit_highlighted")
        modifyImageView.contentMode = UIView.ContentMode.center
        contentView.addSubview(modifyImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.modifyImageViewClick(_:)))
        modifyImageView.isUserInteractionEnabled = true
        modifyImageView.addGestureRecognizer(tap)
        
        bottomView.backgroundColor = UIColor.lightGray
        bottomView.alpha = 0.4
        contentView.addSubview(bottomView)
    }
    static private let identifier = "AdressCell"

    class func adressCell(_ tableView: UITableView, _ indexPath: IndexPath,_ modifyClickCallBack:@escaping ((Int) -> Void)) -> AdressCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier, for:indexPath) as? AdressCell
        if cell == nil {
            cell = AdressCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        cell?.modifyClickCallBack = modifyClickCallBack
        cell?.modifyImageView.tag = indexPath.row
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        nameLabel.frame = CGRectMake(10, 15, 80, 20)
        phoneLabel.frame = CGRectMake(nameLabel.frame.maxX + 10, 15, 150, 20)
        adressLabel.frame = CGRectMake(10, phoneLabel.frame.maxY + 10, width * 0.6, 20)
        lineView.frame = CGRectMake(width * 0.8, 10, 1, height - 20)
        modifyImageView.frame = CGRectMake(width * 0.8 + (width * 0.2 - 40) * 0.5, (height - 40) * 0.5, 40, 40)
        bottomView.frame = CGRectMake(0, height - 1, width, 1)
    }
    
    
    // MARK: - Action
   @objc func modifyImageViewClick(_ tap: UIGestureRecognizer) {
        if modifyClickCallBack != nil {
            modifyClickCallBack!(tap.view!.tag)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
