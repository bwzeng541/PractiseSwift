//
//  HomeViewCell.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/16.
//

import UIKit
import SnapKit
class HomeViewCell: UITableViewCell {
    var model:DataItem?{
        didSet{
            guard model != nil else{
                return
            }
            
            nameLabel.text = model?.name
            messageLabel.text = model?.message

        }
    }
  
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.lineBreakMode =  NSLineBreakMode.byWordWrapping
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubview()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubview() {
        backgroundColor = .white
        selectionStyle = .none
        
         contentView.addSubview(nameLabel)
         contentView.addSubview(messageLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview();
            make.right.equalToSuperview().offset(-14)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview().offset(-10)
        }
     }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
