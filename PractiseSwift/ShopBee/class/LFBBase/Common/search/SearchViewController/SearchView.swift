//
//  SearchView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import UIKit

class SearchView: UIView {

    private let searchLabel = UILabel()
    private var lastX: CGFloat = 0
    private var lastY: CGFloat = 35
    private var searchButtonClickCallback:((_ str: String) -> ())?
    private var btnsArray:[UIButton] = []
    var searchHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchLabel.frame = CGRectMake(0, 0, frame.size.width - 30, 35)
        searchLabel.font = UIFont.systemFont(ofSize: 15)
        searchLabel.textColor = UIColor.RGB(r:140, g: 140, b: 140)
        addSubview(searchLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect, searchTitleText: String) {
        self.init(frame: frame)
        searchLabel.text = searchTitleText
    }
    
    public func updateBtns(_ searchButtonTitleTexts: [String], searchButtonClickCallback:@escaping ((_ str: String) -> ())){
        var btnW: CGFloat = 0
        let btnH: CGFloat = 30
        let addW: CGFloat = 30
        let marginX: CGFloat = 10
        let marginY: CGFloat = 10
        
        lastX  = 0
        lastY  = 35
        searchHeight = 0
        for i in 0..<btnsArray.count {
            btnsArray[i].removeFromSuperview()
        }
        btnsArray.removeAll()
        
        for i in 0..<searchButtonTitleTexts.count {
            let btn = UIButton()
            btn.setTitle(searchButtonTitleTexts[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.titleLabel?.sizeToFit()
            btn.backgroundColor = UIColor.white
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 15
            btn.layer.borderWidth = 0.5
            btn.layer.borderColor = UIColor.RGB(r:200, g: 200, b: 200).cgColor
            btn.addTarget(self, action: #selector(searchButtonClick(_:)), for: .touchUpInside)
            btnW = btn.titleLabel!.width + addW

            if frame.width - lastX > btnW {
                btn.frame = CGRectMake(lastX, lastY, btnW, btnH)
            } else {
                btn.frame = CGRectMake(0, lastY + marginY + btnH, btnW, btnH)
            }
            
            lastX = btn.frame.maxX + marginX
            lastY = btn.y
            searchHeight = btn.frame.maxY
            btnsArray.append(btn)
            addSubview(btn)
        }
        
        self.searchButtonClickCallback = searchButtonClickCallback
    }
    
    @objc func searchButtonClick(_ sender: UIButton) {
        if searchButtonClickCallback != nil {
            searchButtonClickCallback!(sender.title(for: .normal)!)
        }
    }

}
