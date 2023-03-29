//
//  EditAdressViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/26.
//

import UIKit
import RxSwift
import RxCocoa
enum EditAdressViewControllerType: Int {
    case Add
    case Edit
}

protocol editAdressViewControllerDelegate :AnyObject {
    func getCurrentAdress() -> Adress?
    func getAllAdress() -> [Adress]
    func clearAllAdress()
    func reloadAdressTableView()
    func remveAdress(_ remveIndex:Int)
    func insertAdress(_ adress:Adress,_ insertPos:Int )
}

class EditAdressViewController: BaseViewController {
    private let deleteView = UIView()
    private let scrollView = UIScrollView()
    private let adressView = UIView()
    private var contactsTextField: UITextField?
    private var phoneNumberTextField: UITextField?
    private var cityTextField: UITextField?
    private var areaTextField: UITextField?
    private var adressTextField: UITextField?
    private var manButton: LeftImageRightTextButton?
    private var womenButton: LeftImageRightTextButton?
    private var selectCityPickView: UIPickerView?
    private var currentSelectedCityIndex = -1
    private var adressViewMode:EditAdressViewMode?
    weak var editDelegate: editAdressViewControllerDelegate?
    var vcType: EditAdressViewControllerType = .Add
    var currentAdressRow: Int = -1

    private var disposeBag = DisposeBag()
    private lazy var cityArray: [String]? = {
        let array = ["北京市", "上海市", "天津市", "广州市", "佛山市", "深圳市", "廊坊市", "武汉市", "苏州市", "无锡市"]
        return array
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildNavigationItem()
        
        buildScrollView()
        
        buildAdressView()
        
        buildDeleteAdressView()
        
        buildModeView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        if currentAdressRow != -1 && vcType == .Edit {
            let adress = editDelegate!.getAllAdress()[currentAdressRow]//adresses![currentAdressRow]
            contactsTextField?.text = adress.accept_name
            if adress.telphone?.count == 11 {
                let telphone = adress.telphone! as NSString
                phoneNumberTextField?.text = telphone.substring(with: NSMakeRange(0, 3)) + " " + telphone.substring(with: NSMakeRange(3, 4)) + " " + telphone.substring(with: NSMakeRange(7, 4))
            }
            
            if adress.telphone?.count == 13 {
                phoneNumberTextField?.text = adress.telphone
            }
            cityTextField?.text = adress.city_name
            let range = (adress.address! as NSString).range(of: " ")
            areaTextField?.text = (adress.address! as NSString).substring(to: range.location)
            adressTextField?.text = (adress.address! as NSString).substring(from: range.location + 1)
            
            deleteView.isHidden = false
            //sendmessage
            contactsTextField?.sendActions(for: UIControl.Event.editingDidEnd)
            phoneNumberTextField?.sendActions(for: UIControl.Event.editingDidEnd)
            cityTextField?.sendActions(for: UIControl.Event.editingDidEnd)
            adressTextField?.sendActions(for: UIControl.Event.editingDidEnd)
            areaTextField?.sendActions(for: UIControl.Event.editingDidEnd)
            if adress.gender == "1" {
                manButton?.sendActions(for: UIControl.Event.touchUpInside)
            } else {
                womenButton?.sendActions(for: UIControl.Event.touchUpInside)
             }
        }
    }
    // MARK: - Method
    private func buildNavigationItem() {
        navigationItem.title = "修改地址"
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton( "保存", titleColor: UIColor.lightGray, target: self, action:#selector(self.saveButtonClick))
    }
    
    private func buildDeleteAdressView() {
        deleteView.frame = CGRectMake(0, adressView.frame.maxY + 10, view.width, 50)
        deleteView.backgroundColor = UIColor.white
        scrollView.addSubview(deleteView)
        
        let deleteLabel = UILabel(frame: CGRectMake(0, 0, view.width, 50))
        deleteLabel.text = "删除当前地址"
        deleteLabel.textAlignment = .center
        deleteLabel.font = UIFont.systemFont(ofSize: 15)
        deleteView.addSubview(deleteLabel)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.deleteViewClick))
        deleteView.addGestureRecognizer(tap)
        deleteView.isHidden = true
    }
    
   @objc func deleteViewClick() {
       editDelegate?.remveAdress(currentAdressRow)
       navigationController?.popViewController(animated: true)
       editDelegate?.reloadAdressTableView()
    }
    
    private func buildScrollView() {
        scrollView.frame = view.bounds
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    private func buildAdressView() {
        adressView.frame = CGRectMake(0, 10, view.width, 300)
        adressView.backgroundColor = UIColor.white
        scrollView.addSubview(adressView)
        
        let viewHeight: CGFloat = 50
        let leftMargin: CGFloat = 15
        let labelWidth: CGFloat = 70
        buildUnchangedLabel(CGRectMake(leftMargin, 0, labelWidth, viewHeight), text: "联系人")
        buildUnchangedLabel(CGRectMake(leftMargin, 2 * viewHeight, labelWidth, viewHeight), text: "手机号码")
        buildUnchangedLabel(CGRectMake(leftMargin, 3 * viewHeight, labelWidth, viewHeight), text: "所在城市")
        buildUnchangedLabel(CGRectMake(leftMargin, 4 * viewHeight, labelWidth, viewHeight), text: "所在地区")
        buildUnchangedLabel(CGRectMake(leftMargin, 5 * viewHeight, labelWidth, viewHeight), text: "详细地址")
        
        let lineView = UIView(frame: CGRectMake(leftMargin, 49, view.width - 10, 1))
        lineView.alpha = 0.15
        lineView.backgroundColor = UIColor.lightGray
        adressView.addSubview(lineView)
        
        let textFieldWidth = view.width * 0.6
        let x = leftMargin + labelWidth + 10
        contactsTextField = UITextField()
        buildTextField(contactsTextField!, frame: CGRectMake(x, 0, textFieldWidth, viewHeight), placeholder: "收货人姓名", tag: 1)
        
        phoneNumberTextField = UITextField()
        buildTextField(phoneNumberTextField!, frame: CGRectMake(x, 2 * viewHeight, textFieldWidth, viewHeight), placeholder: "鲜蜂侠联系你的电话", tag: 2)
        
        cityTextField = UITextField()
        buildTextField(cityTextField!, frame: CGRectMake(x, 3 * viewHeight, textFieldWidth, viewHeight), placeholder: "请选择城市", tag: 3)
        
        areaTextField = UITextField()
        buildTextField(areaTextField!, frame: CGRectMake(x, 4 * viewHeight, textFieldWidth, viewHeight), placeholder: "请选择你的住宅,大厦或学校", tag: 4)
        
        adressTextField = UITextField()
        buildTextField(adressTextField!, frame: CGRectMake(x, 5 * viewHeight, textFieldWidth, viewHeight), placeholder: "请输入楼号门牌号等详细信息", tag: 5)
        
        manButton = LeftImageRightTextButton()
        buildGenderButton(manButton!, frame: CGRectMake(phoneNumberTextField!.frame.minX, 50, 100, 50), title: "先生", tag: 101)
        
        womenButton = LeftImageRightTextButton()
        buildGenderButton(womenButton!, frame: CGRectMake(manButton!.frame.maxX + 10, 50, 100, 50), title: "女士", tag: 102)
    }
    
    private func buildUnchangedLabel(_ frame: CGRect, text: String) {
        let label = UILabel(frame: frame)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = LFBTextBlackColor
        adressView.addSubview(label)
        
        let lineView = UIView(frame: CGRectMake(15, frame.origin.y - 1, view.width - 10, 1))
        lineView.alpha = 0.15
        lineView.backgroundColor = UIColor.lightGray
        adressView.addSubview(lineView)
    }
    
    private func buildGenderButton(_ button: LeftImageRightTextButton, frame: CGRect, title: String, tag: Int) {
        button.tag = tag
        button.setImage(R.image.v2_noselected(), for: .normal)
        button.setImage(R.image.v2_selected(), for: .selected)
        //button.addTarget(self, action:#selector(self.genderButtonClick(_:)), for: .touchUpInside)
        button.setTitle(title, for: UIControl.State.normal)
        button.frame = frame
        button.setTitleColor(LFBTextBlackColor, for: .normal)
        adressView.addSubview(button)
    }
    
    private func buildModeView()
    {
        
        manButton?.tag = 1
        womenButton?.tag = 2

        manButton?.rx.tap.subscribe(onNext:{[weak self] in
            self?.manButton?.isSelected = true
            self?.womenButton?.isSelected = false
        }
        ).disposed(by: disposeBag)
        
        womenButton?.rx.tap.subscribe(onNext:{[weak self] in
            self?.womenButton?.isSelected = true
            self?.manButton?.isSelected = false
        }
        ).disposed(by: disposeBag)
        
        let btns = [womenButton,manButton].map({$0!})
        let selectButton = Observable.from(btns.map({ btn in
                    btn.rx.tap.map({btn})
        })).merge()
        let genderObservable = selectButton.map({ i in
            return i.tag
        }).asObservable()//.subscribe(onNext:{[weak self] i in
        let contactsTextObservable = contactsTextField!.rx.text.orEmpty.asObservable()
        let inobject = EditAdressViewMode.Input(tagSignal:((navigationItem.rightBarButtonItem?.customView as! UIButton).rx.tap.asObservable()) , validateUserGender:genderObservable,
                                                validatedUsername:contactsTextObservable,
                                 validatedUserIphone:phoneNumberTextField!.rx.text.orEmpty.asObservable(),
                                 validateUserCity:cityTextField!.rx.text.orEmpty.asObservable(),
                                 validateUserAer:areaTextField!.rx.text.orEmpty.asObservable(),
                                 validateUserDeital:adressTextField!.rx.text.orEmpty.asObservable())
        adressViewMode  = EditAdressViewMode()
        let out = adressViewMode?.transform(inobject)
        out?.databaseReuslt.subscribe(onNext:{[weak self] event in
            switch event {
            case .success(let v):
                self?.saveEidt(adre: v)
            case .failure(_):break
            default:
                break
            }
        }).disposed(by: disposeBag)
        out?.signupEnabled.bind(to:(navigationItem.rightBarButtonItem?.customView as! UIButton).rx.isEnabled ) .disposed(by: disposeBag)
    }

    private func saveEidt(adre:Adress){
        if vcType == .Add{
            editDelegate?.insertAdress(adre, 0)
        }
        
        if vcType == .Edit {
            let r = editDelegate!.getAllAdress()[currentAdressRow]
            r.gender = adre.gender
            r.city_name = adre.city_name
            r.accept_name = adre.accept_name
            r.address = adre.address
            r.telphone = adre.telphone
            editDelegate?.reloadAdressTableView()
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func buildTextField(_ textField: UITextField, frame: CGRect, placeholder: String, tag: Int) {
        textField.frame = frame
        
        if 2 == tag {
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        if 3 == tag {
            selectCityPickView = UIPickerView()
            Observable.just(self.cityArray!).bind(to: selectCityPickView!.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
            selectCityPickView!.rx.itemSelected
                .subscribe {[weak self] (event) in
                    switch event {
                    case .next(let selected):
                        self?.currentSelectedCityIndex = selected.row
                    default:
                        break
                    }
                }
                .disposed(by: disposeBag)
            textField.inputView = selectCityPickView
            textField.inputAccessoryView = buildInputView()
        }
        
        textField.tag = tag
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.delegate = self
        textField.textColor = LFBTextBlackColor
        adressView.addSubview(textField)
    }
    
    private func buildInputView() -> UIView {

        let toolBar = UIToolbar(frame: CGRectMake(0, 0, view.width, 40))
        toolBar.backgroundColor = UIColor.white
        
        let lineView = UIView(frame: CGRectMake(0, 0, view.width, 1))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        toolBar.addSubview(lineView)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.alpha = 0.8
        titleLabel.text = "选择城市"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.frame = CGRectMake(0, 0, view.width, toolBar.height)
        toolBar.addSubview(titleLabel)
        
        let cancleButton = UIButton(frame: CGRectMake(0, 0, 80, toolBar.height))
        cancleButton.tag = 10
         cancleButton.setTitle("取消", for: .normal)
        cancleButton.setTitleColor(UIColor.RGB(r:82, g: 188, b: 248), for: .normal)
        toolBar.addSubview(cancleButton)
        
        let determineButton = UIButton(frame: CGRectMake(view.width - 80, 0, 80, toolBar.height))
        determineButton.tag = 11
         determineButton.setTitleColor(UIColor.RGB(r:82, g: 188, b: 248), for: .normal)
        determineButton.setTitle("确定", for: .normal)
        toolBar.addSubview(determineButton)
       determineButton.rx.tap.subscribe(onNext: {[weak self] _ in
            if self?.currentSelectedCityIndex != -1 {
                       self?.cityTextField?.text = self?.cityArray![self?.currentSelectedCityIndex ?? 0]
                   }
                self?.cityTextField!.endEditing(true)
        }).disposed(by: disposeBag)
        cancleButton.rx.tap.subscribe(onNext: {[weak self] _ in
          
                self?.cityTextField!.endEditing(true)
        }).disposed(by: disposeBag)
        return toolBar
    }
    
    @objc func saveButtonClick() {
     }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditAdressViewController:UITextFieldDelegate{
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    {
        
    var isPressback = false
        let  char = string.cString(using: String.Encoding.utf8)!
               let isBackSpace = strcmp(char, "\\b")
               if (isBackSpace == -92) {
                   isPressback = true
               }
        
    if textField.tag == 2 {
        if textField.text?.count == 13 {
            if isPressback {
                return true
            }
            return false
            
        } else {
            
            if (textField.text?.count == 3 || textField.text?.count == 8) && !isPressback {
                textField.text = textField.text! + " "
            }
            
            return true
        }
    }
    
    return true
    }
}
