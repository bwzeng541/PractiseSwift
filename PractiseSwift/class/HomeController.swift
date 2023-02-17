//
//  ViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/2/15.
//

import UIKit
import CTMediator
import RxSwift
private let kSessionsCellReuseIdentifier = "kSessionsCellReuseIdentifier"

class HomeController: UIViewController, UITableViewDelegate ,UITableViewDataSource,CTMediatorModuleProtocol{
    @IBOutlet weak var tableView: UITableView!
    
   private var ModeluName = Model1_Name;

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        CTMediator.sharedInstance().registerBusinessListener(self);
        HomeDataModel.share.requestData();

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
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview();
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: kSessionsCellReuseIdentifier)
        tableView.delegate = self;
        tableView.dataSource = self;

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = CTMediator.sharedInstance().A_showSwift { (result) in
            print(result)
        }
         self.present(controller!, animated: true,completion: nil);
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSessionsCellReuseIdentifier) as! HomeViewCell
         let model = HomeDataModel.share.dataArray[indexPath.row]
        cell.model = model
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: kSessionsCellReuseIdentifier, cacheBy: indexPath) { (cell) in
            let currentCell = cell as! HomeViewCell
            let model = HomeDataModel.share.dataArray[indexPath.row]
            currentCell.model = model
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeDataModel.share.dataArray.count;
    }
    
    
    func processBusinessNotify(_ moudel: String?, capacity capcity: String?, withInParam inParam: Any?) {
        if moudel != ModeluName {
            return;
        }
        switch capcity {
        case Model1_Capacity.Capactity1.rawValue:
            print("Capactity1");
            
        case Model1_Capacity.Capactity2.rawValue:
            print("Capactity2");
        
        default: break
            
        }
    }
}

