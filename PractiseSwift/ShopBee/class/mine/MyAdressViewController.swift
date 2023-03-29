//
//  MyAdressViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/26.
//

import UIKit
import RxSwift
import RxCocoa




class MyAdressViewController: BaseViewController {
    private var addAdressButton: UIButton?
    private var nullImageView = UIView()
    
    var selectedAdressCallback:((_ adress: Adress) -> ())?
    private var disposeBag = DisposeBag()

    var isSelectVC = false
    var adressTableView: LFBTableView?
    var adresses: [Adress]? {
        didSet {
            if adresses?.count == 0 {
                nullImageView.isHidden = false
                adressTableView?.isHidden = true
            } else {
                nullImageView.isHidden = true
                adressTableView?.isHidden = false
            }
        }
    }
    
    deinit {
        JTPrint(message: self)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ selectedAdress: @escaping ((_ adress:Adress) -> ())) {
        self.init(nibName: nil, bundle: nil)
        selectedAdressCallback = selectedAdress
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildNavigationItem()

        buildAdressTableView()

        buildNullImageView()

        loadAdressData()

        buildBottomAddAdressButtom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func buildNavigationItem() {
        navigationItem.title = "我的收获地址"
    }
    
    private func buildAdressTableView() {
        adressTableView = LFBTableView(frame: view.bounds, style: .plain)
        adressTableView?.register(cellWithClass: AdressCell.self)
        adressTableView?.frame.origin.y += 10;
        adressTableView?.backgroundColor = UIColor.clear
        adressTableView?.rowHeight = 80
        adressTableView?.delegate = self
        adressTableView?.dataSource = self
        view.addSubview(adressTableView!)
    }
    
    private func buildNullImageView() {
        nullImageView.backgroundColor = UIColor.clear
        nullImageView.frame = CGRectMake(0, 0, 200, 200)
        nullImageView.center = view.center
        nullImageView.center.y -= 100
        view.addSubview(nullImageView)
        
        let imageView = UIImageView(image: R.image.v2_address_empty())
        imageView.center.x = 100
        imageView.center.y = 100
        nullImageView.addSubview(imageView)
        
        let label = UILabel(frame: CGRectMake(0, imageView.frame.maxY + 10, 200, 20))
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "你还没有地址哦~"
        nullImageView.addSubview(label)
    }
    
    private func loadAdressData() {
        AdressViewMode.shared.adressSubject.subscribe(onNext: { [weak self] event in
            switch event
            {
            case .success(let ret):
                self?.adresses = ret
                self?.adressTableView?.isHidden = false
                self?.adressTableView?.reloadData()
                self?.nullImageView.isHidden = true
                UserInfo.sharedUserInfo.setAllAdress(self?.adresses ?? [])
            case .failure(_):
                self?.adressTableView?.isHidden = true
                self?.nullImageView.isHidden = false
                UserInfo.sharedUserInfo.cleanAllAdress()
            }
        }).disposed(by: disposeBag)

    }
    
    private func buildBottomAddAdressButtom() {
        let bottomView = UIView(frame: CGRectMake(0, ScreenHeight - 60 - 64, ScreenWidth, 60))
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
    
        addAdressButton = UIButton(frame: CGRectMake(ScreenWidth * 0.15, 12, ScreenWidth * 0.7, 60 - 12 * 2))
        addAdressButton?.backgroundColor = LFBNavigationYellowColor
        addAdressButton?.setTitle("+ 新增地址", for: .normal)
        addAdressButton?.setTitleColor(UIColor.black, for: .normal)
        addAdressButton?.layer.masksToBounds = true
        addAdressButton?.layer.cornerRadius = 8
        addAdressButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addAdressButton?.addTarget(self, action: #selector(self.addAdressButtonClick), for: .touchUpInside)
        bottomView.addSubview(addAdressButton!)
    }
    
    @objc
    func addAdressButtonClick(){
        let editVC = EditAdressViewController()
        editVC.editDelegate = self
        editVC.vcType = EditAdressViewControllerType.Add
        navigationController?.pushViewController(editVC, animated: true)
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

extension MyAdressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var tmpSelf = self
        let cell = AdressCell.adressCell(tableView, indexPath) {  (ret) in
            let editAdressVC = EditAdressViewController()
            editAdressVC.editDelegate = tmpSelf
            editAdressVC.vcType = EditAdressViewControllerType.Edit
            editAdressVC.currentAdressRow = indexPath.row
            tmpSelf?.navigationController?.pushViewController(editAdressVC, animated: true)
        }
        cell.adress = adresses![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectVC {
            selectedAdressCallback?(adresses![indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
}

extension MyAdressViewController :editAdressViewControllerDelegate{
    func getCurrentAdress() -> Adress? {
        return nil
    }
    
    func getAllAdress() -> [Adress] {
        return adresses!
    }
    
    func clearAllAdress() {
         
    }
    
    func reloadAdressTableView() {
        adressTableView?.reloadData()
    }
    
    func remveAdress(_ remveIndex: Int) {
        adresses!.remove(at: remveIndex)
        adressTableView?.deleteRows(at: [IndexPath.init(row: remveIndex, section: 0)], with: UITableView.RowAnimation.fade)
    }
    
    func insertAdress(_ adress: Adress, _ insertPos: Int) {
        adresses!.insert(adress, at: insertPos)
        adressTableView?.insertRows(at: [IndexPath.init(row: insertPos, section: 0)], with: UITableView.RowAnimation.fade)
    }
    
    
}
