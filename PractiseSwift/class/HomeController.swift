//
//  ViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/15.
//

import UIKit
import CTMediator
import RxSwift
import WebKit
private let kSessionsCellReuseIdentifier = "kSessionsCellReuseIdentifier"



class HomeController: UIViewController, UITableViewDelegate ,CTMediatorModuleProtocol, WebCoreManagerDelegate{
   // @IBOutlet weak var tableView: UITableView!
    
   private var ModeluName = Model1_Name;
 
    private weak var  clickDelegate:PublishSubject<Int>? = nil
    var dataListArr : BehaviorSubject<[SectionModel<String, DataItem>]>?
    var disposeBag = DisposeBag()
    private var bg:DisposeBag? = DisposeBag()
    
    lazy var webView:WKWebView={
        let webvi = WebCoreManager.share().createWKWebView(withUrl: "http://www.5tuu.com", isAutoSelected: true, delegate: self);
        WebCoreManager.share().updateUseWKWebview(webvi)
        return webvi!;
    }()
    
    lazy var webTopTools:WebTopTools={
        let _webTopTools = WebTopTools.webTopTools();
        return _webTopTools
    }()
    
    lazy var webBottomTools:WebBottomTools={
        let _webBottomTools = WebBottomTools.webBottomTools();
        return _webBottomTools
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("add from dev")
        CTMediator.sharedInstance().registerBusinessListener(self);
        //HomeDataModel.share.requestData();

        /*
        lazy var btnAdd:UIButton = {
            let button = UIButton(type: .contactAdd)
            self.view.addSubview(button)
            button.snp.makeConstraints({ make in
                make.left.equalToSuperview()
                make.top.equalToSuperview().offset(50)
                make.width.height.equalTo(60)
            })
            return button
        }()
        
        lazy var tableView: UITableView = {
             let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.view.frame.size.height)
            let table = UITableView(frame: frame, style: .plain)
            table.backgroundColor = UIColor.white
            table.delegate = self as? UITableViewDelegate
            table.dataSource = self as? UITableViewDataSource
            table.showsVerticalScrollIndicator = false
            table.showsHorizontalScrollIndicator = false
            table.tableFooterView = UIView()
            if #available(iOS 11.0, *) {
                table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
            } else {
                // Fallback on earlier versions
            }
            return table
        }()
        
        
        btnAdd.rx.tap.throttle(RxTimeInterval.milliseconds(30), scheduler: MainScheduler.instance).bind { [self] in
            HomeDataModel.share.addItem();
            dataListArr?.onNext([SectionModel(model: "", items:HomeDataModel.share.dataArray)])
        }.disposed(by: bg!)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.right.left.equalToSuperview();
            make.top.equalTo(btnAdd.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-200)
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: kSessionsCellReuseIdentifier)
        tableView.delegate = self;
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DataItem>>(
            configureCell: { (_, tv, indexPath, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: kSessionsCellReuseIdentifier) as! HomeViewCell
                cell.model = element
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].model
            }
        )

         dataListArr = BehaviorSubject(value: [SectionModel(model: "", items:HomeDataModel.share.dataArray)])
         dataListArr?.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: {[weak self] DataItem in
                let controller = CTMediator.sharedInstance().A_showSwift { (result) in
                           print(result)
                      }
                self?.present(controller!, animated: true,completion: nil);
            })
            .disposed(by: disposeBag)
     */
        
        self.view.addSubview(webTopTools);
        webTopTools.snp.makeConstraints { make in
            make.left.right.equalToSuperview();
            make.top.equalToSuperview().offset(kSafeAreaTop);
            make.height.equalTo(60);
        }
        
        self.view.addSubview(webBottomTools);
        webBottomTools.snp.makeConstraints { make in
            make.left.right.equalToSuperview();
            make.bottom.equalToSuperview().offset(-kSafeAreaBottom);
            make.height.equalTo(45);
        }
    
        self.view.addSubview(webView);
        
        webView.snp.makeConstraints { make in
            make.left.right.equalToSuperview();
            make.bottom.equalTo(webBottomTools.snp.top);
            make.bottom.equalToSuperview().offset(kSafeAreaBottom)
            make.top.equalTo(webTopTools.snp.bottom);
        }
        let request = NSURLRequest(url: "http://www.5tuu.com".URLValue!)
        webView.load(request as URLRequest)
        bindWebDelege();
    }

    func bindWebDelege(){
        
    }
    
    func processBusinessNotify(_ moudel: String?, capacity capcity: String?, withInParam inParam: Any?) {
        if moudel != ModeluName {
            return;
        }
        switch capcity {
        case Model1_Capacity.Capactity1.rawValue:
            print("Capactity1");
            clickDelegate  = inParam as? PublishSubject<Int>;
            clickDelegate?.subscribe(onNext: { event in
                print("subscribe Capactity1 %d" , event);
            }).disposed(by: disposeBag)
        case Model1_Capacity.Capactity2.rawValue:
            print("Capactity2");
        
        default: break
            
        }
    }
}

