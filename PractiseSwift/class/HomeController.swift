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
import Toast_Swift
import SwifterSwift
import sqlcipher
import TagListView
private let kSessionsCellReuseIdentifier = "kSessionsCellReuseIdentifier"



class HomeController: UIViewController, UITableViewDelegate ,CTMediatorModuleProtocol, WebCoreManagerDelegate{
   // @IBOutlet weak var tableView: UITableView!
    
   private var ModeluName = Model1_Name;
 
    private var isToolsHidde:Bool=false
   private var webTitle:String?=nil
   private var assetUrl:String?=nil
   private var current_Url:String?=nil
   private var webIcon_url:String?=nil;
        
    private weak var  clickDelegate:PublishSubject<Int>? = nil
    var dataListArr : BehaviorSubject<[SectionModel<String, DataItem>]>?
    var disposeBag = DisposeBag()
    private var bg:DisposeBag? = DisposeBag()
    
    lazy var webView:WKWebView={
        let webvi = WebCoreManager.share().createWKWebView(withUrl: "http://www.baidu.com", isAutoSelected: true, delegate: self);
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
    
//    lazy var progressView:UIProgressView={
//        let retProgressView = UIProgressView.init();
//        retProgressView.progressTintColor = UIColor.RGB(r: 255, g: 0, b: 0); // ProgressTintColor;
//        retProgressView.trackTintColor = UIColor.black;
//        retProgressView.progress=0;
//        return retProgressView
//    }()
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
        let request = NSURLRequest(url: "http://www.baidu.com".URLValue!)
        webView.load(request as URLRequest)
        bindWebViewAttribute()
     }

    func bindWebViewAttribute(){
        webView.rx.observeWeakly(String.self, "url").subscribe { [unowned self] (next) in
            webTopTools.urlText .text = next
        }.disposed(by: bg!)
        webView.rx.observeWeakly(String.self, "title").subscribe { [unowned self] (next) in
            webTopTools.titleText.text = next
        }.disposed(by: bg!)
        webView.rx.observeWeakly(Bool.self, "loading").subscribe { [unowned self] (next) in
            webTopTools.btnCanle.isHidden = !next!
        }.disposed(by: bg!)
        webTopTools.btnCanle.rx.tap
                 .subscribe(onNext: { [weak self] in
                     self?.webView.stopLoading()
                 })
                 .disposed(by: bg!)
        webTopTools.clickBlock={ [weak self] in
             let vv = AddressSearchView.addressSearchView()
            vv.frame = (self?.view.frame)!
            self?.view.addSubview(vv)
        }
    }
    
     func hideAdsByLoadingPercent(){
         webView.evaluateJavaScript("window.__firefox__.hideAdsByLoadingPercent()") { (result, err) in
               print(result ?? "", err ?? "")
         }
     }
    
    func webGetFavicon(){
       webView.evaluateJavaScript("__firefox__.favicon.getFavicon()") { (result, err) in
              print(result ?? "", err ?? "")
        }
     }
 
    func webCore_webViewLoadProgress(_ progress :Float)
    {
        webTopTools.updateProgress(progress)
        hideAdsByLoadingPercent()
    }
    
    func webCore_webViewTitleChange(_ title: String!) {
        self.webTitle = title;
        if (title.length>0) {
            let msg = " " + title + " "
            self.view.makeToast(msg, duration: 2, position: .center)
        }
    }
    
    func webCore_toolBarState(_ isHidden: Bool) {
        guard isToolsHidde != isHidden else {
            return
        }
        isToolsHidde = isHidden;
        var offset = kSafeAreaTop
        var offsetBottom = -kSafeAreaBottom
        if !isHidden {
        }
        else {
            offset = 0;
            offsetBottom = kSafeAreaBottom
        }
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.webTopTools.snp.updateConstraints({ make in
                make.top.equalToSuperview().offset(offset);
            })
            self?.webBottomTools.snp.updateConstraints({ make in
                make.bottom.equalToSuperview().offset(offsetBottom);
            })
            self?.view.layoutIfNeeded()
               }) { (complete) in
        }
     }
    
    func webCore_webView(_ webView: WKWebView!, didFinish navigation: WKNavigation!) {
        webGetFavicon()
        webView.evaluateJavaScript("document.title"){ (result, err) in
            self.webTitle = result as! String;
            guard webView!.url?.host?.compare("127.0.0.1") != .orderedSame else {
                return
            }
            let  urlString = webView.url!.absoluteString;
            let md5 = urlString.ios_md5;
            let historyItem = UrlHistoryItem()
            historyItem.iconUrl = self.webIcon_url ?? ""
            historyItem.webTitle = self.webTitle ?? ""
            historyItem.url = urlString
            historyItem.urlUid = md5;
            historyItem.timeDate = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
            WCDataManager.shared().insertOrReplace(historyItem, tableName: urlHistoryTable)
            /*WCDataBaseManager.shared.insertOrReplace(objects: [historyItem], intoTable:  kTABLE.urlHistory)*/
      }
    }
    
    func webCore_webView(_ webView: WKWebView!, didCommit navigation: WKNavigation!) {
        let  urlString = webView.url!.absoluteString;
        self.webTitle = nil;
        self.assetUrl = nil;
        self.current_Url = urlString
    }
    
    
    func webCore_webView(_ webView: WKWebView!, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard webView.url?.host?.compare("127.0.0.1") != .orderedSame else {
            return
        }
    }
    
    func webCore_userContentController(_ userContentController: WKUserContentController!, didReceive message: WKScriptMessage!) {
        if (message != nil) && message.name.compare("faviconMessageHandler") == .orderedSame {
              let array =  (message.body as! String).components(separatedBy: ":#:")
            if array.count > 0 {
                current_Url = array[0];
                if array.count > 1 {
                    webIcon_url = array[1]
                }
            }
        }
      
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

