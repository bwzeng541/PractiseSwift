//
//  AddressSearchView.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/3.
//

import UIKit
import RxSwift
import TagListView
func JTPrint<N>(message: N, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){

 
        print("\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息\(message)");
 }

class AddressSearchView: UIView, TagListViewDelegate {

    @IBOutlet weak var btnCanle: UIButton!
    @IBOutlet weak var addressField: AddressField!
    @IBOutlet weak var histoyView:UIView!
    @IBOutlet weak var sugguestView:UIView!
    @IBOutlet weak var tagListView: TagListView!

    private let searchModel = SearchViewModel()
    private var isInit:Bool = false
    private var disposeBag = DisposeBag()


    
    lazy var tableView: UITableView = {
         let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.frame.size.height)
        let table = UITableView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.gray
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
      
        table.register(UINib(nibName: "Searchcell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        self.histoyView.addSubview(table)
        
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return table
    }()
    
    
    class func addressSearchView() -> AddressSearchView {
        return R.nib.addressSearchView.firstView(owner: nil)!
        //  return Bundle.main.loadNibNamed("AddressSearchView", owner: nil, options: [:])?.first as! AddressSearchView;
      }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        JTPrint(message: self)
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        bindEvent()
        bindTableView()
    }
    
    private func bindEvent(){
        guard isInit == false else{
            return
        }
        isInit = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(node:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        tagListView.textFont = .systemFont(ofSize: 15)
        tagListView.delegate = self;

        //tagListView.layoutSubviews()
        let v = tagListView.intrinsicContentSize
        tagListView.alignment = .left//borderColor
        self.tagListView.selectedBorderColor = UIColor.yellow
        self.tagListView.textColor = UIColor.red
        tagListView.snp.updateConstraints { make in
            make.height.equalTo(v.height)
        }
        sugguestView.snp.updateConstraints({ make in
            make.height.equalTo(21+v.height)
        })
        
        self.btnCanle.rx.tap.asObservable().throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance).subscribe(onNext:{ [weak self] in
            self?.removeFromSuperview()
       }).disposed(by: disposeBag)
    
        addressField.becomeFirstResponder()
        let input = SearchViewModel.Input(makeSearchText:self.addressField.rx.text.asObservable())
        let out = searchModel.transform( input)
        out.searchReulst.asDriver(onErrorJustReturn: []).drive(
            onNext: { [weak self] (objects) in
                guard let self = self else { return }
                self.updateData(objects)
            }).disposed(by: disposeBag)
        
        
        out.databaseReuslt.bind(to: tableView.rx.items){(tb,row,model) -> UITableViewCell in
            //其中对cell进行数据模型赋值，以此实现了数据模型model与视图View的分离
            let cell = tb.dequeueReusableCell(withIdentifier: "CustomCell") as? Searchcell
            cell?.labelTitle?.text = model.webTitle
            cell?.labelUrl?.text = model.url
            
            return cell!
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(UrlHistoryItem.self)
            .subscribe(onNext: { UrlHistoryItem in
                
             })
            .disposed(by: disposeBag)
        
//        let tapGesture = UITapGestureRecognizer()
//        self.addGestureRecognizer(tapGesture)
//        
//        tapGesture.rx.event.bind {[weak self] _ in
//            self?.addressField.resignFirstResponder()
//        }.disposed(by: disposeBag)
    }
    
    @objc func keyboardWillChangeFrame(node : Notification){
        let duration = node.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
               // 2.获取键盘最终 Y值
         let endFrame = (node.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
               var y = endFrame.origin.y-40
        if y > UIScreen.main.bounds.size.height-100 {
            y = kSafeAreaBottom
        }
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.histoyView.snp.updateConstraints({ make in
                make.bottom.equalToSuperview().offset(-y);
            })

            self?.layoutIfNeeded()
        }){ (complete) in
        }
    }
    
    private func bindTableView(){
       
        }
    
    private func updateData(_ itmes:[UrlHistoryItem]){
        UIView.animate(withDuration: 0, animations: { [weak self] in
            if itmes.count == 0 {
                self?.sugguestView.snp.updateConstraints({ make in
                    make.height.equalTo(0)
                })
            }
            else{
                self?.tagListView.removeAllTags();
                for i in 0..<itmes.count {
                    let listView =  self?.tagListView.addTag(itmes[i].webTitle)
                    listView!.setUrl(itmes[i].url)
                }
                let v = self?.tagListView.intrinsicContentSize
                self?.tagListView.snp.updateConstraints { make in
                    make.height.equalTo(v!.height)
                }
                self?.sugguestView.snp.updateConstraints({ make in
                    make.height.equalTo(21+v!.height)
                })
            }
            self?.layoutIfNeeded()
               }) { (complete) in
        }
    }
    
    @objc  func tagPressed(_ title: String, tagView: TagView, sender: TagListView){
       
    }
}


private var TagViewUrlKey   = "TagViewUrlKey"
extension TagView {
    //                objc_setAssociatedObject(self, &ToastKeys.activeToasts, activeToasts, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    public func setUrl(_ value: String?) {
        objc_setAssociatedObject(self, &TagViewUrlKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    public func url() -> String? {
        return objc_getAssociatedObject(self, &TagViewUrlKey) as? String
    }
    
}
