//
//  AddressField.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/2.
//

import UIKit

class AddressField: UITextField, WebInputViewDelegate {
  

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    

    fileprivate func makeUI(){
        self.borderStyle = .bezel
        self.returnKeyType = .go
        self.keyboardType = .emailAddress
        self.autocapitalizationType = .none
        self.font = UIFont.systemFont(ofSize: 15)
        let image = UIImage.init(named: "ljt");
        self.leftView = UIImageView.init(image: image)
        self.leftViewMode = .always
        self.layer.borderWidth = 1.0
        self.borderStyle = .roundedRect
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.colorWithHexStr("dfdfdf").cgColor;
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = true;
        self.clearButtonMode = .whileEditing;//UITextFieldViewModeWhileEditing
       let webInuputView =  WebInputView.init(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:40))
        self.inputAccessoryView = webInuputView
        webInuputView.delegate = self
    }
    
    
    func getNoBlank(str:String) -> String{
       var newStr = str.replacingOccurrences(of: " ", with: "")//英文空格
        newStr = newStr.replacingOccurrences(of: " ", with: "")//中文空格
        return newStr
    }

    func selectedRange(textField:UITextField ) -> NSRange{
        let beginning = textField.beginningOfDocument
        let selectedRangeRet = textField.selectedTextRange;
        let selectionStart = selectedRangeRet!.start;
        let selectionEnd = selectedRangeRet!.end;
        let location = textField.offset(from: beginning, to: selectionStart)
        let length = textField.offset(from: selectionStart, to: selectionEnd)
        return NSMakeRange(location, length)
    }
    
    func clickCharFromInputView(_ str: String) {
        var strNew :String = ""
        if self.text != nil {
            self.text = getNoBlank(str: self.text! )
            strNew += self.text!
        }
        let selectRange = selectedRange(textField: self)
        let insertPos = selectRange.location + selectRange.length
        var startPos = insertPos;
        let tt = getNoBlank(str: str)
        let value = tt.replacingOccurrences(of: "\n", with: "")
        let length = value.length
         if selectRange.length == 0 {
            strNew.insert(contentsOf:value, at: (strNew.index(strNew.startIndex, offsetBy: startPos)))
            startPos += length
         }
        else{
          // let range = Range.init(selectRange)
            let findindex = selectRange.location
            let fineEndIndex = selectRange.location+selectRange.length
            let index1 = String.Index.init(encodedOffset: findindex)
            let index5 = String.Index.init(encodedOffset: fineEndIndex-1)
            let range1:ClosedRange = index1 ... index5
            strNew.replaceSubrange(range1, with: value)
            startPos = findindex + length;
         }
        self.text = strNew;
        let newPosition = self.position(from: self.beginningOfDocument, offset: startPos)
        self.selectedTextRange = self.textRange(from: newPosition!, to: newPosition!)
        self.sendActions(for: .allEditingEvents)
    }
}
